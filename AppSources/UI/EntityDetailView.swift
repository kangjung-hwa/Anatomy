import SwiftUI

struct EntityDetailView: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    let entity: AnatomyEntity

    private var muscle: Muscle? {
        guard entity.kind == .muscle else { return nil }
        return try? JSONDecoder.anatomyDecoder.decode(Muscle.self, from: entity.jsonData())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                metadataSection
                if let muscle {
                    muscleSection(muscle)
                }
                sourcesSection
            }
            .padding()
        }
        .navigationTitle(entity.name.ko)
        .toolbar {
            Button {
                favoritesStore.toggle(entity.id)
            } label: {
                Image(systemName: favoritesStore.contains(entity.id) ? "star.fill" : "star")
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entity.name.ko)
                .font(.title)
            Text(entity.name.en)
                .font(.headline)
                .foregroundStyle(.secondary)
            if !entity.tags.isEmpty {
                FlowLayout(items: entity.tags) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondary.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
        }
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Metadata")
                .font(.headline)
            KeyValueRow(title: "Region", value: entity.region.rawValue)
            KeyValueRow(title: "Review", value: entity.reviewStatus.rawValue)
            KeyValueRow(title: "Confidence", value: String(format: "%.2f", entity.confidence))
        }
    }

    private func muscleSection(_ muscle: Muscle) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Muscle Details")
                .font(.headline)
            AttachmentGroup(title: "Origin", points: muscle.origin)
            AttachmentGroup(title: "Insertion", points: muscle.insertion)
            ActionGroup(actions: muscle.actions)
            InnervationGroup(refs: muscle.innervation)
        }
    }

    private var sourcesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sources")
                .font(.headline)
            ForEach(entity.sources, id: \.self) { source in
                VStack(alignment: .leading, spacing: 4) {
                    Text(source.title)
                        .font(.subheadline)
                    Text([source.type, source.edition, source.sourcePage]
                        .compactMap { $0 }
                        .joined(separator: " • "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

private struct KeyValueRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
        }
    }
}

private struct AttachmentGroup: View {
    let title: String
    let points: [AttachmentPoint]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
            ForEach(points, id: \.self) { point in
                Text("\(point.landmark.ko) · \(point.landmark.en)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct ActionGroup: View {
    let actions: [ActionMovement]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Actions")
                .font(.subheadline)
            ForEach(actions, id: \.self) { action in
                Text("\(action.movement.ko) (\(action.movement.en)) · \(action.plane.rawValue)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct InnervationGroup: View {
    let refs: [NerveRef]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Innervation")
                .font(.subheadline)
            ForEach(refs, id: \.self) { ref in
                Text("\(ref.nerve) · \(ref.roots.joined(separator: ", "))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct FlowLayout<Item: Hashable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                content(item)
            }
        }
    }
}

private extension AnatomyEntity {
    func jsonData() throws -> Data {
        try JSONEncoder.anatomyEncoder.encode(self)
    }
}

private extension JSONDecoder {
    static let anatomyDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

private extension JSONEncoder {
    static let anatomyEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}

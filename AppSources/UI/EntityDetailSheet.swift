import SwiftUI

struct EntityDetailSheet: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    let entity: Anatomy3DEntity
    let notes: [StudyNote]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    relationSection
                    notesSection
                    attributionSection
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
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entity.name.ko)
                .font(.title2)
            Text(entity.name.en)
                .font(.headline)
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                TagView(text: entity.kind.rawValue)
                TagView(text: entity.layer.rawValue)
            }
        }
    }

    private var relationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Relations")
                .font(.headline)
            RelationRow(title: "Origin", values: entity.relations?.origin)
            RelationRow(title: "Insertion", values: entity.relations?.insertion)
            RelationRow(title: "Innervated by", values: entity.relations?.innervatedBy)
            RelationRow(title: "Supplied by", values: entity.relations?.suppliedBy)
            RelationRow(title: "Adjacent to", values: entity.relations?.adjacentTo)
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Study Notes")
                .font(.headline)
            if notes.isEmpty {
                Text("노트가 없습니다.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(notes) { note in
                    VStack(alignment: .leading, spacing: 6) {
                        NoteRow(title: "요약", value: note.summaryKo)
                        NoteRow(title: "요가 relevance", value: note.yogaRelevanceKo)
                        NoteRow(title: "Cue", value: note.cuesKo)
                        NoteRow(title: "자주 하는 실수", value: note.commonMistakesKo)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }

    private var attributionSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Sources")
                .font(.headline)
            Text(entity.source.title)
                .font(.subheadline)
            Text("\(entity.source.project) · \(entity.source.license)")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(entity.source.attribution)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

private struct RelationRow: View {
    let title: String
    let values: [String]?

    var body: some View {
        if let values, !values.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                Text(values.joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct NoteRow: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
    }
}

private struct TagView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.secondary.opacity(0.2))
            .clipShape(Capsule())
    }
}

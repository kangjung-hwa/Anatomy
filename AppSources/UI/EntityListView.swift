import SwiftUI

struct EntityListView: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    let entities: [AnatomyEntity]

    private var groupedByKind: [AnatomyKind: [AnatomyEntity]] {
        Dictionary(grouping: entities, by: \.kind)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(AnatomyKind.allCases, id: \.self) { kind in
                    if let items = groupedByKind[kind] {
                        Section(header: Text(kind.rawValue.capitalized)) {
                            ForEach(items, id: \.id) { entity in
                                NavigationLink {
                                    EntityDetailView(entity: entity)
                                        .environmentObject(favoritesStore)
                                } label: {
                                    EntityRow(entity: entity)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Browse")
        }
    }
}

private struct EntityRow: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    let entity: AnatomyEntity

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entity.name.ko)
                    .font(.headline)
                Text(entity.name.en)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if favoritesStore.contains(entity.id) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
            }
        }
    }
}

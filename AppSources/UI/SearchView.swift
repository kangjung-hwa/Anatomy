import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @State private var query = ""
    let entities: [Anatomy3DEntity]
    let notesByEntityId: [String: [StudyNote]]

    private var results: [Anatomy3DEntity] {
        SearchIndex(entities: [], entities3D: entities).search3D(query: query)
    }

    var body: some View {
        NavigationStack {
            List(results, id: \.id) { entity in
                NavigationLink {
                    EntityDetailSheet(entity: entity, notes: notesByEntityId[entity.id] ?? [])
                        .environmentObject(favoritesStore)
                } label: {
                    VStack(alignment: .leading) {
                        Text(entity.name.ko)
                        Text(entity.name.en)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Search")
        }
        .searchable(text: $query, prompt: "근육/뼈/신경 검색")
    }
}

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @State private var query = ""
    let entities: [AnatomyEntity]

    private var results: [AnatomyEntity] {
        SearchIndex(entities: entities).search(query: query)
    }

    var body: some View {
        NavigationStack {
            List(results, id: \.id) { entity in
                NavigationLink {
                    EntityDetailView(entity: entity)
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

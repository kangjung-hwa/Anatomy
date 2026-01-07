import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    let entities: [AnatomyEntity]

    private var favoriteEntities: [AnatomyEntity] {
        entities.filter { favoritesStore.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            if favoriteEntities.isEmpty {
                ContentUnavailableView("즐겨찾기 없음", systemImage: "star")
            } else {
                List(favoriteEntities, id: \.id) { entity in
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
            }
        }
        .navigationTitle("Favorites")
    }
}

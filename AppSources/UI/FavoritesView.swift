import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    let entities: [Anatomy3DEntity]
    @State private var selectedEntity: Anatomy3DEntity?

    private var favoriteEntities: [Anatomy3DEntity] {
        entities.filter { favoritesStore.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            if favoriteEntities.isEmpty {
                ContentUnavailableView("즐겨찾기 없음", systemImage: "star")
            } else {
                List(favoriteEntities, id: \.id) { entity in
                    Button {
                        selectedEntity = entity
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
        .sheet(item: $selectedEntity) { entity in
            FavoriteViewerSheet(entity: entity)
                .environmentObject(favoritesStore)
        }
    }
}

private struct FavoriteViewerSheet: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    let entity: Anatomy3DEntity

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Viewer3DThumbnail(entity: entity)
                EntityDetailSheet(entity: entity, notes: [])
            }
            .navigationTitle("3D Viewer")
            .toolbar {
                Button {
                    favoritesStore.toggle(entity.id)
                } label: {
                    Image(systemName: favoritesStore.contains(entity.id) ? "star.fill" : "star")
                }
            }
        }
    }
}

private struct Viewer3DThumbnail: View {
    let entity: Anatomy3DEntity

    var body: some View {
        Viewer3DViewPlaceholder(entity: entity)
            .frame(height: 220)
            .padding(.horizontal)
    }
}

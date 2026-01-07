import SwiftUI

struct AppRootView: View {
    @State private var bundleIndex = BundleIndex(legacyBundles: [], indexEntities: [], studyNotes: [])
    @State private var loadError: String?
    @StateObject private var favoritesStore = FavoritesStore()

    var body: some View {
        Group {
            if let error = loadError {
                ContentUnavailableView("데이터 로딩 실패", systemImage: "exclamationmark.triangle") {
                    Text(error)
                }
            } else if bundleIndex.indexEntities.isEmpty {
                ContentUnavailableView("로딩 중", systemImage: "hourglass")
            } else {
                TabView {
                    Viewer3DView(
                        entities: bundleIndex.indexEntities,
                        notesByEntityId: bundleIndex.notesByEntityId
                    )
                    .environmentObject(favoritesStore)
                    .tabItem {
                        Label("3D Viewer", systemImage: "cube")
                    }
                    SearchView(
                        entities: bundleIndex.indexEntities,
                        notesByEntityId: bundleIndex.notesByEntityId
                    )
                        .environmentObject(favoritesStore)
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                    FavoritesView(entities: bundleIndex.indexEntities)
                        .environmentObject(favoritesStore)
                        .tabItem {
                            Label("Favorites", systemImage: "star")
                        }
                }
            }
        }
        .task {
            do {
                let loader = BundleLoader()
                bundleIndex = try loader.loadBundles(
                    from: ["anatomy_3d_index", "anatomy_study_notes", "upper_limb_muscles"]
                )
            } catch {
                loadError = error.localizedDescription
            }
        }
    }
}

#Preview {
    AppRootView()
}

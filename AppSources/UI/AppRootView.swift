import SwiftUI

struct AppRootView: View {
    @State private var bundleIndex = BundleIndex(bundles: [])
    @State private var loadError: String?
    @StateObject private var favoritesStore = FavoritesStore()

    var body: some View {
        Group {
            if let error = loadError {
                ContentUnavailableView("데이터 로딩 실패", systemImage: "exclamationmark.triangle") {
                    Text(error)
                }
            } else if bundleIndex.allEntities.isEmpty {
                ContentUnavailableView("로딩 중", systemImage: "hourglass")
            } else {
                TabView {
                    EntityListView(entities: bundleIndex.allEntities)
                        .environmentObject(favoritesStore)
                        .tabItem {
                            Label("Browse", systemImage: "list.bullet")
                        }
                    SearchView(entities: bundleIndex.allEntities)
                        .environmentObject(favoritesStore)
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                    FavoritesView(entities: bundleIndex.allEntities)
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
                bundleIndex = try loader.loadBundles(from: ["upper_limb_muscles"])
            } catch {
                loadError = error.localizedDescription
            }
        }
    }
}

#Preview {
    AppRootView()
}

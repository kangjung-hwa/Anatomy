import Foundation

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: Set<String>

    private let storageKey = "favorite_entity_ids"

    init() {
        if let stored = UserDefaults.standard.array(forKey: storageKey) as? [String] {
            favorites = Set(stored)
        } else {
            favorites = []
        }
    }

    func contains(_ entityId: String) -> Bool {
        favorites.contains(entityId)
    }

    func toggle(_ entityId: String) {
        if favorites.contains(entityId) {
            favorites.remove(entityId)
        } else {
            favorites.insert(entityId)
        }
        persist()
    }

    private func persist() {
        UserDefaults.standard.set(Array(favorites), forKey: storageKey)
    }
}

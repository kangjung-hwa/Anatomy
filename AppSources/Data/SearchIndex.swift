import Foundation

struct SearchIndex {
    private let legacyEntities: [AnatomyEntity]
    private let entities3D: [Anatomy3DEntity]

    init(entities: [AnatomyEntity], entities3D: [Anatomy3DEntity] = []) {
        self.legacyEntities = entities
        self.entities3D = entities3D
    }

    func searchLegacy(query: String) -> [AnatomyEntity] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return legacyEntities }
        let needle = trimmed.lowercased()
        return legacyEntities.filter { entity in
            let names = [entity.name.ko, entity.name.en]
            let aliasMatches = entity.aliases.ko + entity.aliases.en
            let tags = entity.tags
            return (names + aliasMatches + tags).contains { $0.lowercased().contains(needle) }
        }
    }

    func search3D(query: String) -> [Anatomy3DEntity] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return entities3D }
        let needle = trimmed.lowercased()
        return entities3D.filter { entity in
            let names = [entity.name.ko, entity.name.en]
            let aliasMatches = entity.aliases.ko + entity.aliases.en
            let tags = entity.tags
            return (names + aliasMatches + tags).contains { $0.lowercased().contains(needle) }
        }
    }
}

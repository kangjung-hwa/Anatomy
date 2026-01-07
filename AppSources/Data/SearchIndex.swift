import Foundation

struct SearchIndex {
    private let entities: [AnatomyEntity]

    init(entities: [AnatomyEntity]) {
        self.entities = entities
    }

    func search(query: String) -> [AnatomyEntity] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return entities }
        let needle = trimmed.lowercased()
        return entities.filter { entity in
            let names = [entity.name.ko, entity.name.en]
            let aliasMatches = entity.aliases.ko + entity.aliases.en
            let tags = entity.tags
            return (names + aliasMatches + tags).contains { $0.lowercased().contains(needle) }
        }
    }
}

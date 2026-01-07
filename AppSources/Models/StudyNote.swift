import Foundation

struct StudyNoteSource: Codable, Hashable {
    let title: String
    let license: String
    let url: String
    let section: String?
}

struct StudyNote: Codable, Identifiable, Hashable {
    let id: String
    let keyEntityId: String
    let summaryKo: String
    let yogaRelevanceKo: String
    let cuesKo: String
    let commonMistakesKo: String
    let sources: [StudyNoteSource]

    enum CodingKeys: String, CodingKey {
        case id
        case keyEntityId = "key_entity_id"
        case summaryKo = "summary_ko"
        case yogaRelevanceKo = "yoga_relevance_ko"
        case cuesKo = "cues_ko"
        case commonMistakesKo = "common_mistakes_ko"
        case sources
    }
}

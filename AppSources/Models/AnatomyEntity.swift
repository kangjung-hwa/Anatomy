import Foundation

enum AnatomyKind: String, Codable, CaseIterable {
    case muscle
    case bone
    case nerve
    case joint
    case ligament
    case vessel
    case artery
    case vein
    case organ
    case skin
    case fascia
}

enum AnatomyRegion: String, Codable, CaseIterable {
    case headNeck = "head_neck"
    case trunk
    case upperLimb = "upper_limb"
    case lowerLimb = "lower_limb"
}

enum ReviewStatus: String, Codable, CaseIterable {
    case draft
    case reviewed
    case verified
}

struct LocalizedText: Codable, Hashable {
    let ko: String
    let en: String

    func value(locale: String) -> String {
        if locale.lowercased().hasPrefix("en") {
            return en
        }
        return ko
    }
}

struct Aliases: Codable, Hashable {
    let ko: [String]
    let en: [String]
}

struct Source: Codable, Hashable {
    let title: String
    let type: String
    let edition: String?
    let year: Int?
    let note: String?
    let sourcePage: String?

    enum CodingKeys: String, CodingKey {
        case title
        case type
        case edition
        case year
        case note
        case sourcePage = "source_page"
    }
}

struct AnatomyEntity: Codable, Identifiable, Hashable {
    let id: String
    let kind: AnatomyKind
    let name: LocalizedText
    let aliases: Aliases
    let region: AnatomyRegion
    let tags: [String]
    let sources: [Source]
    let confidence: Double
    let reviewStatus: ReviewStatus
    let lastReviewedAt: Date

    var displayName: String {
        name.value(locale: Locale.current.identifier)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case kind
        case name
        case aliases
        case region
        case tags
        case sources
        case confidence
        case reviewStatus = "review_status"
        case lastReviewedAt = "last_reviewed_at"
    }
}

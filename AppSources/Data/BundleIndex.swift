import Foundation

struct AnatomyBundle: Codable, Hashable {
    let bundleId: String
    let bundleType: String
    let version: String
    let locale: String
    let generatedAt: Date
    let entities: [AnatomyEntity]

    enum CodingKeys: String, CodingKey {
        case bundleId = "bundle_id"
        case bundleType = "bundle_type"
        case version
        case locale
        case generatedAt = "generated_at"
        case entities
    }
}

struct BundleIndex: Hashable {
    let legacyBundles: [AnatomyBundle]
    let indexEntities: [Anatomy3DEntity]
    let studyNotes: [StudyNote]

    var allEntities: [AnatomyEntity] {
        legacyBundles.flatMap(\.entities)
    }

    var groupedByKind: [AnatomyKind: [AnatomyEntity]] {
        Dictionary(grouping: allEntities, by: \.kind)
    }

    var notesByEntityId: [String: [StudyNote]] {
        Dictionary(grouping: studyNotes, by: \.keyEntityId)
    }
}

import Foundation

enum AnatomyLayer: String, Codable, CaseIterable {
    case skin
    case fascia
    case muscle
    case nerve
    case artery
    case vein
    case bone
    case organ
    case joint
    case ligament
}

enum MeshFormat: String, Codable {
    case usdz
    case gltf
}

struct MeshInfo: Codable, Hashable {
    let file: String
    let format: MeshFormat
    let scale: Double?
    let pivot: [Double]?
}

struct HierarchyInfo: Codable, Hashable {
    let parentId: String?
    let childrenIds: [String]?

    enum CodingKeys: String, CodingKey {
        case parentId = "parent_id"
        case childrenIds = "children_ids"
    }
}

struct RelationsInfo: Codable, Hashable {
    let origin: [String]?
    let insertion: [String]?
    let innervatedBy: [String]?
    let suppliedBy: [String]?
    let adjacentTo: [String]?

    enum CodingKeys: String, CodingKey {
        case origin
        case insertion
        case innervatedBy = "innervated_by"
        case suppliedBy = "supplied_by"
        case adjacentTo = "adjacent_to"
    }
}

struct SourceAttribution: Codable, Hashable {
    let title: String
    let project: String
    let license: String
    let attribution: String
    let url: String?
}

struct Anatomy3DEntity: Codable, Identifiable, Hashable {
    let id: String
    let kind: AnatomyKind
    let layer: AnatomyLayer
    let name: LocalizedText
    let aliases: Aliases
    let tags: [String]
    let mesh: MeshInfo
    let hierarchy: HierarchyInfo?
    let relations: RelationsInfo?
    let source: SourceAttribution

    var displayName: String {
        name.value(locale: Locale.current.identifier)
    }
}

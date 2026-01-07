import Foundation

struct AttachmentPoint: Codable, Hashable {
    let bone: String
    let landmark: LocalizedText
}

enum ActionPlane: String, Codable, CaseIterable {
    case sagittal
    case frontal
    case transverse
    case multi
}

struct ActionMovement: Codable, Hashable {
    let joint: String
    let movement: LocalizedText
    let plane: ActionPlane
    let note: String?
}

struct NerveRef: Codable, Hashable {
    let nerve: String
    let roots: [String]
    let note: String?
}

struct EntityRef: Codable, Hashable {
    let entity: String
    let note: String?
}

struct Muscle: Codable, Identifiable, Hashable {
    let base: AnatomyEntity
    let origin: [AttachmentPoint]
    let insertion: [AttachmentPoint]
    let actions: [ActionMovement]
    let innervation: [NerveRef]
    let bloodSupply: [EntityRef]?
    let synergists: [EntityRef]?
    let antagonists: [EntityRef]?
    let clinicalNotes: [String]?

    var id: String { base.id }
    var name: LocalizedText { base.name }
    var region: AnatomyRegion { base.region }

    enum CodingKeys: String, CodingKey {
        case origin
        case insertion
        case actions
        case innervation
        case bloodSupply = "blood_supply"
        case synergists
        case antagonists
        case clinicalNotes = "clinical_notes"
    }

    init(base: AnatomyEntity,
         origin: [AttachmentPoint],
         insertion: [AttachmentPoint],
         actions: [ActionMovement],
         innervation: [NerveRef],
         bloodSupply: [EntityRef]? = nil,
         synergists: [EntityRef]? = nil,
         antagonists: [EntityRef]? = nil,
         clinicalNotes: [String]? = nil) {
        self.base = base
        self.origin = origin
        self.insertion = insertion
        self.actions = actions
        self.innervation = innervation
        self.bloodSupply = bloodSupply
        self.synergists = synergists
        self.antagonists = antagonists
        self.clinicalNotes = clinicalNotes
    }

    init(from decoder: Decoder) throws {
        let base = try AnatomyEntity(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let origin = try container.decode([AttachmentPoint].self, forKey: .origin)
        let insertion = try container.decode([AttachmentPoint].self, forKey: .insertion)
        let actions = try container.decode([ActionMovement].self, forKey: .actions)
        let innervation = try container.decode([NerveRef].self, forKey: .innervation)
        let bloodSupply = try container.decodeIfPresent([EntityRef].self, forKey: .bloodSupply)
        let synergists = try container.decodeIfPresent([EntityRef].self, forKey: .synergists)
        let antagonists = try container.decodeIfPresent([EntityRef].self, forKey: .antagonists)
        let clinicalNotes = try container.decodeIfPresent([String].self, forKey: .clinicalNotes)

        self.init(
            base: base,
            origin: origin,
            insertion: insertion,
            actions: actions,
            innervation: innervation,
            bloodSupply: bloodSupply,
            synergists: synergists,
            antagonists: antagonists,
            clinicalNotes: clinicalNotes
        )
    }

    func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(origin, forKey: .origin)
        try container.encode(insertion, forKey: .insertion)
        try container.encode(actions, forKey: .actions)
        try container.encode(innervation, forKey: .innervation)
        try container.encodeIfPresent(bloodSupply, forKey: .bloodSupply)
        try container.encodeIfPresent(synergists, forKey: .synergists)
        try container.encodeIfPresent(antagonists, forKey: .antagonists)
        try container.encodeIfPresent(clinicalNotes, forKey: .clinicalNotes)
    }
}

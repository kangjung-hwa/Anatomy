import Foundation

enum BundleLoaderError: Error, LocalizedError {
    case missingResource(String)

    var errorDescription: String? {
        switch self {
        case .missingResource(let resource):
            return "Missing bundle resource: \(resource)"
        }
    }
}

final class BundleLoader {
    private let decoder: JSONDecoder

    init() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func loadBundles(from resourceNames: [String]) throws -> BundleIndex {
        var legacyBundles: [AnatomyBundle] = []
        var indexEntities: [Anatomy3DEntity] = []
        var studyNotes: [StudyNote] = []

        for name in resourceNames {
            guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
                throw BundleLoaderError.missingResource(name)
            }
            let data = try Data(contentsOf: url)
            let payload = try decoder.decode(BundlePayload.self, from: data)
            switch payload {
            case .legacy(let bundle):
                legacyBundles.append(bundle)
            case .index(let bundle):
                indexEntities.append(contentsOf: bundle.entities)
            case .notes(let bundle):
                studyNotes.append(contentsOf: bundle.notes)
            }
        }

        return BundleIndex(legacyBundles: legacyBundles, indexEntities: indexEntities, studyNotes: studyNotes)
    }
}

private struct BundleHeader: Codable {
    let bundleType: String

    enum CodingKeys: String, CodingKey {
        case bundleType = "bundle_type"
    }
}

private enum BundlePayload: Codable {
    case legacy(AnatomyBundle)
    case index(Anatomy3DIndexBundle)
    case notes(StudyNotesBundle)

    init(from decoder: Decoder) throws {
        let header = try BundleHeader(from: decoder)
        switch header.bundleType {
        case "anatomy_3d_index":
            self = .index(try Anatomy3DIndexBundle(from: decoder))
        case "anatomy_study_notes":
            self = .notes(try StudyNotesBundle(from: decoder))
        default:
            self = .legacy(try AnatomyBundle(from: decoder))
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .legacy(let bundle):
            try bundle.encode(to: encoder)
        case .index(let bundle):
            try bundle.encode(to: encoder)
        case .notes(let bundle):
            try bundle.encode(to: encoder)
        }
    }
}

struct Anatomy3DIndexBundle: Codable, Hashable {
    let bundleId: String
    let bundleType: String
    let version: String
    let locale: String
    let generatedAt: Date
    let entities: [Anatomy3DEntity]

    enum CodingKeys: String, CodingKey {
        case bundleId = "bundle_id"
        case bundleType = "bundle_type"
        case version
        case locale
        case generatedAt = "generated_at"
        case entities
    }
}

struct StudyNotesBundle: Codable, Hashable {
    let bundleId: String
    let bundleType: String
    let version: String
    let locale: String
    let generatedAt: Date
    let notes: [StudyNote]

    enum CodingKeys: String, CodingKey {
        case bundleId = "bundle_id"
        case bundleType = "bundle_type"
        case version
        case locale
        case generatedAt = "generated_at"
        case notes
    }
}

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
        let bundles = try resourceNames.map { name in
            guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
                throw BundleLoaderError.missingResource(name)
            }
            let data = try Data(contentsOf: url)
            return try decoder.decode(AnatomyBundle.self, from: data)
        }
        return BundleIndex(bundles: bundles)
    }
}

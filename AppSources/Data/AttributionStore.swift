import Foundation

struct AttributionStore {
    let attributions: [SourceAttribution]

    init(entities: [Anatomy3DEntity]) {
        let sources = entities.map(\.source)
        self.attributions = Array(Set(sources)).sorted { $0.title < $1.title }
    }
}

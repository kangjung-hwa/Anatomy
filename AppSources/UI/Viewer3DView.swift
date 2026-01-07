import SwiftUI

struct Viewer3DView: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @State private var selectedEntity: Anatomy3DEntity?
    @State private var activeLayers: Set<AnatomyLayer> = Set(AnatomyLayer.allCases)

    let entities: [Anatomy3DEntity]
    let notesByEntityId: [String: [StudyNote]]

    private var visibleEntities: [Anatomy3DEntity] {
        entities.filter { activeLayers.contains($0.layer) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Viewer3DViewPlaceholder(entity: selectedEntity)
                    .frame(height: 280)
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            if let entity = selectedEntity {
                                favoritesStore.toggle(entity.id)
                            }
                        } label: {
                            Image(systemName: favoritesStore.contains(selectedEntity?.id ?? "") ? "star.fill" : "star")
                                .foregroundStyle(.yellow)
                                .padding(8)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .padding()
                        .disabled(selectedEntity == nil)
                    }

                LayerToggleView(activeLayers: $activeLayers)

                List(visibleEntities, id: \.id) { entity in
                    Button {
                        selectedEntity = entity
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entity.name.ko)
                                Text(entity.name.en)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if favoritesStore.contains(entity.id) {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                }
            }
            .navigationTitle("3D Viewer")
            .sheet(item: $selectedEntity) { entity in
                EntityDetailSheet(entity: entity, notes: notesByEntityId[entity.id] ?? [])
                    .environmentObject(favoritesStore)
            }
        }
    }
}

private struct LayerToggleView: View {
    @Binding var activeLayers: Set<AnatomyLayer>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(AnatomyLayer.allCases, id: \.self) { layer in
                    Toggle(layer.rawValue, isOn: Binding(
                        get: { activeLayers.contains(layer) },
                        set: { isOn in
                            if isOn {
                                activeLayers.insert(layer)
                            } else {
                                activeLayers.remove(layer)
                            }
                        }
                    ))
                    .toggleStyle(.switch)
                }
            }
            .padding(.horizontal)
        }
    }
}

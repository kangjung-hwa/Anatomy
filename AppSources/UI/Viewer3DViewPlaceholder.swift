import SceneKit
import SwiftUI

struct Viewer3DViewPlaceholder: View {
    let entity: Anatomy3DEntity?

    var body: some View {
        SceneView(
            scene: Self.makeScene(),
            options: [.autoenablesDefaultLighting, .allowsCameraControl]
        )
        .overlay(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 4) {
                Text(entity?.displayName ?? "대상 선택")
                    .font(.headline)
                Text(entity?.mesh.file ?? "mesh 없음 - placeholder")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(8)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .padding()
        }
    }

    private static func makeScene() -> SCNScene {
        let scene = SCNScene()
        let sphere = SCNSphere(radius: 0.5)
        sphere.firstMaterial?.diffuse.contents = UIColor.systemTeal
        let node = SCNNode(geometry: sphere)
        scene.rootNode.addChildNode(node)
        return scene
    }
}

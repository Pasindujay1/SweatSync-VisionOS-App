import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @State private var repCount: Int = 0
    @State private var animateBar1 = false
    @State private var animateBar2 = false
    @State private var animateBar3 = false
    @Environment(AppModel.self) private var appModel

    var body: some View {
        RealityView { content in
            // BAR 1: Blue
            let bar1 = ModelEntity(mesh: .generateBox(size: [0.05, 0.1, 0.05]))
            bar1.position = [-0.2, 0.05, -0.5]
            bar1.model?.materials = [SimpleMaterial(color: .blue, isMetallic: false)]
            bar1.name = "bar1"
            bar1.generateCollisionShapes(recursive: false) 
            content.add(bar1)

            // BAR 2: Green
            let bar2 = ModelEntity(mesh: .generateBox(size: [0.05, 0.1, 0.05]))
            bar2.position = [0.0, 0.05, -0.5]
            bar2.model?.materials = [SimpleMaterial(color: .green, isMetallic: false)]
            bar2.name = "bar2"
            bar2.generateCollisionShapes(recursive: false)
            content.add(bar2)

            // BAR 3: Red
            let bar3 = ModelEntity(mesh: .generateBox(size: [0.05, 0.1, 0.05]))
            bar3.position = [0.2, 0.05, -0.5]
            bar3.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
            bar3.name = "bar3"
            bar3.generateCollisionShapes(recursive: false)
            content.add(bar3)

            // Floating text
            let textMesh = MeshResource.generateText(
                "Workout Progress",
                extrusionDepth: 0.01,
                font: .systemFont(ofSize: 0.1),
                containerFrame: .zero,
                alignment: .center,
                lineBreakMode: .byWordWrapping
            )
            let text = ModelEntity(mesh: textMesh, materials: [SimpleMaterial(color: .white, isMetallic: false)])
            text.position = [0.0, 0.25, -0.5]
            content.add(text)

        } update: { content in
            if let bar1 = content.entities.first(where: { $0.name == "bar1" }) {
                bar1.transform.scale.y = animateBar1 ? 1.5 : 1.0
            }
            if let bar2 = content.entities.first(where: { $0.name == "bar2" }) {
                bar2.transform.scale.y = animateBar2 ? 1.5 : 1.0
            }
            if let bar3 = content.entities.first(where: { $0.name == "bar3" }) {
                bar3.transform.scale.y = animateBar3 ? 1.5 : 1.0
            }
        }
        .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
            withAnimation(.easeInOut(duration: 0.4)) {
                repCount = (repCount + 1) % 3
                animateBar1 = (repCount == 0)
                animateBar2 = (repCount == 1)
                animateBar3 = (repCount == 2)
            }
        })
        .onAppear {
            appModel.immersiveSpaceState = .open
        }
        .onDisappear {
            appModel.immersiveSpaceState = .closed
        }
    }
}

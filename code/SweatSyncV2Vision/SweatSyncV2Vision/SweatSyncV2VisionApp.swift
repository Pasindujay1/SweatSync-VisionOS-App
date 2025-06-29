import SwiftUI

@main
struct SweatSyncV2VisionApp: App {
    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel) 
        }

        ImmersiveSpace(id: "ImmersiveView") {
            ImmersiveView()
                .environment(appModel)
        }
    }
}

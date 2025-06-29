import SwiftUI

struct ToggleImmersiveSpaceButton: View {

    @Environment(AppModel.self) private var appModel

    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    @State private var isPressed = false

    var body: some View {
        Button {
            isPressed = true
            Task { @MainActor in
                switch appModel.immersiveSpaceState {
                    case .open:
                        appModel.immersiveSpaceState = .inTransition
                        await dismissImmersiveSpace()
                    case .closed:
                        appModel.immersiveSpaceState = .inTransition
                        switch await openImmersiveSpace(id: appModel.immersiveSpaceID) {
                            case .opened:
                                break
                            case .userCancelled, .error:
                                fallthrough
                            @unknown default:
                                appModel.immersiveSpaceState = .closed
                        }
                    case .inTransition:
                        break
                }
                isPressed = false
            }
        } label: {
            HStack(spacing: 24) {
                Image(systemName: appModel.immersiveSpaceState == .open ? "eye.slash" : "eye")
                    .font(.system(size: 48, weight: .bold))
                Text(appModel.immersiveSpaceState == .open ? "Hide Immersive Space" : "Show Immersive Space")
                    .font(.system(size: 36, weight: .semibold))
            }
            .padding(.horizontal, 48)
            .padding(.vertical, 28)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
            .shadow(color: .blue.opacity(0.18), radius: 18, x: 0, y: 8)
            .scaleEffect(isPressed ? 1.10 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
            .foregroundColor(appModel.immersiveSpaceState == .open ? .red : .blue)
            .accessibilityLabel(appModel.immersiveSpaceState == .open ? "Hide Immersive Space" : "Show Immersive Space")
            .accessibilityHint("Toggles the immersive workout progress view")
            .frame(minWidth: 420, minHeight: 90)
        }
        .disabled(appModel.immersiveSpaceState == .inTransition)
        .buttonStyle(PlainButtonStyle())
    }
}

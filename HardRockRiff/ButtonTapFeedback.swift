import AudioToolbox
import SwiftUI
import UIKit

enum ButtonTapFeedback {
    private static let impact = UIImpactFeedbackGenerator(style: .light)

    
    static func play() {
        impact.prepare()
        impact.impactOccurred()
        AudioServicesPlaySystemSound(SystemSoundID(1104))
    }
}


struct SoundPlainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        SoundPlainFeedbackLabel(label: configuration.label)
    }
}

private struct SoundPlainFeedbackLabel<Label: View>: View {
    let label: Label
    @Environment(\.isEnabled) private var isEnabled
    @State private var didPlayForCurrentTouch = false

    var body: some View {
        label
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        guard isEnabled else { return }
                        guard !didPlayForCurrentTouch else { return }
                        didPlayForCurrentTouch = true
                        ButtonTapFeedback.play()
                    }
                    .onEnded { _ in
                        didPlayForCurrentTouch = false
                    }
            )
    }
}

extension ButtonStyle where Self == SoundPlainButtonStyle {
    static var soundPlain: SoundPlainButtonStyle { SoundPlainButtonStyle() }
}

extension View {
    
    func onTapGestureWithButtonFeedback(_ action: @escaping () -> Void) -> some View {
        onTapGesture {
            ButtonTapFeedback.play()
            action()
        }
    }
}

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

    static func perform(_ action: () -> Void) {
        play()
        action()
    }
}


struct SoundPlainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
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

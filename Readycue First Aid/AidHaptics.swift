import UIKit

/// Central haptic feedback helper.
enum AidHaptics {
    private static let light = UIImpactFeedbackGenerator(style: .light)
    private static let heavy = UIImpactFeedbackGenerator(style: .heavy)
    private static let notifier = UINotificationFeedbackGenerator()

    static func tap() {
        light.impactOccurred()
    }

    static func beat() {
        heavy.impactOccurred()
    }

    static func success() {
        notifier.notificationOccurred(.success)
    }

    static func error() {
        notifier.notificationOccurred(.error)
    }
}

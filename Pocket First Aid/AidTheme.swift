import SwiftUI

enum AidTheme {
    static let background = Color(red: 0.980, green: 0.965, blue: 0.945)
    static let card = Color.white
    static let ink = Color(red: 0.150, green: 0.200, blue: 0.231)
    static let subtle = Color(red: 0.478, green: 0.510, blue: 0.529)
    static let primary = Color(red: 0.878, green: 0.333, blue: 0.282)     // warm coral
    static let primaryDeep = Color(red: 0.690, green: 0.227, blue: 0.188)
    static let peach = Color(red: 0.984, green: 0.890, blue: 0.863)
    static let amber = Color(red: 0.937, green: 0.651, blue: 0.247)
    static let amberSoft = Color(red: 0.992, green: 0.925, blue: 0.827)
    static let sage = Color(red: 0.298, green: 0.686, blue: 0.490)
    static let sageSoft = Color(red: 0.871, green: 0.949, blue: 0.902)
    static let slate = Color(red: 0.243, green: 0.361, blue: 0.462)
    static let slateSoft = Color(red: 0.878, green: 0.914, blue: 0.941)
    static let line = Color(red: 0.918, green: 0.894, blue: 0.867)

    static let heroGradient = LinearGradient(
        gradient: Gradient(colors: [primary, primaryDeep]),
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    static let calmGradient = LinearGradient(
        gradient: Gradient(colors: [slate, Color(red: 0.165, green: 0.263, blue: 0.349)]),
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}

struct AidCardStyle: ViewModifier {
    var padding: CGFloat = 16
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AidTheme.card)
                    .shadow(color: AidTheme.ink.opacity(0.06), radius: 10, x: 0, y: 4)
            )
    }
}

extension View {
    func aidCard(padding: CGFloat = 16) -> some View {
        modifier(AidCardStyle(padding: padding))
    }
}

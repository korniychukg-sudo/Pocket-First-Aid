import SwiftUI

struct AidLaunchScreen: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            AidTheme.heroGradient
                .ignoresSafeArea()
            VStack(spacing: 22) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.14))
                        .frame(width: 116, height: 116)
                        .scaleEffect(pulse ? 1.08 : 0.94)
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 88, height: 88)
                    AidFillIcon(shape: AidCrossShape(), size: 44, color: AidTheme.sage)
                }
                Text("Pocket First Aid")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("Getting ready...")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.75))
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

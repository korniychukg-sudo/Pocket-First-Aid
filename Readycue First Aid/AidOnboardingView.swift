import SwiftUI

/// Three illustrated slides shown once on first launch.
struct AidOnboardingView: View {
    let onFinish: () -> Void

    @State private var page = 0
    @State private var float = false

    private struct Slide {
        let image: String
        let title: String
        let caption: String
    }

    private let slides: [Slide] = [
        Slide(image: "intro_1",
              title: "Help at Your Fingertips",
              caption: "Thirty-two everyday emergencies, each broken into big, calm, step-by-step screens you can follow under pressure."),
        Slide(image: "intro_2",
              title: "Learn Before You Need It",
              caption: "A gentle quiz builds your reflexes, and ready-made checklists keep your home, car, and travel kits stocked."),
        Slide(image: "intro_3",
              title: "Always Ready, Fully Offline",
              caption: "Everything lives on your phone - no account, no internet needed. In a real emergency, always call your local emergency number first.")
    ]

    var body: some View {
        ZStack {
            AidTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                TabView(selection: $page) {
                    ForEach(0..<3, id: \.self) { i in
                        slideView(slides[i])
                            .tag(i)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        Capsule()
                            .fill(i == page ? AidTheme.primary : AidTheme.peach)
                            .frame(width: i == page ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: page)
                    }
                }
                .padding(.top, 10)

                Button(action: advance) {
                    Text(page == 2 ? "Get Started" : "Continue")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(AidTheme.heroGradient)
                        )
                }
                .padding(.horizontal, 28)
                .padding(.top, 18)

                Button(action: { finish() }) {
                    Text("Skip")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(page == 2 ? .clear : AidTheme.subtle)
                        .padding(.vertical, 10)
                }
                .disabled(page == 2)
                .padding(.bottom, 12)
            }
            .frame(maxWidth: 560)
        }
    }

    private func slideView(_ slide: Slide) -> some View {
        VStack(spacing: 20) {
            Image(slide.image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .shadow(color: AidTheme.ink.opacity(0.12), radius: 16, x: 0, y: 8)
                .padding(.horizontal, 34)
                .padding(.top, 16)
                .offset(y: float ? -7 : 7)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
                        float = true
                    }
                }
            Text(slide.title)
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .foregroundColor(AidTheme.ink)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            Text(slide.caption)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.subtle)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer(minLength: 0)
        }
    }

    private func advance() {
        AidHaptics.tap()
        if page < 2 {
            withAnimation { page += 1 }
        } else {
            finish()
        }
    }

    private func finish() {
        AidHaptics.success()
        onFinish()
    }
}

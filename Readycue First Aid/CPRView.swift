import SwiftUI

/// CPR guide with a 110 beats-per-minute compression metronome (visual + haptic).
struct CPRView: View {
    @State private var running = false
    @State private var beatOn = false
    @State private var beatCount = 0
    @State private var timer: Timer? = nil

    private let interval = 60.0 / 110.0   // 110 bpm

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("CPR Coach")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(AidTheme.ink)
                        Text("Compressions at 110 beats per minute")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(AidTheme.subtle)
                    }
                    Spacer()
                }
                .padding(.top, 6)

                metronomeCard

                VStack(alignment: .leading, spacing: 12) {
                    Text("The full sequence")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(AidTheme.ink)
                    ForEach(Array(AidContent.cprSteps.enumerated()), id: \.offset) { pair in
                        HStack(alignment: .top, spacing: 14) {
                            ZStack {
                                Circle().fill(AidTheme.peach).frame(width: 36, height: 36)
                                Text("\(pair.offset + 1)")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(AidTheme.primary)
                            }
                            Text(pair.element)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(AidTheme.ink)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .aidCard()

                Text("This coach is a training aid and a rhythm keeper. In a real emergency, call your local emergency number first - dispatchers guide CPR over the phone.")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(AidTheme.subtle.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                Spacer().frame(height: 8)
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .background(AidTheme.background.ignoresSafeArea())
        .navigationBarHidden(true)
        .onDisappear { stop() }
    }

    private var metronomeCard: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(AidTheme.peach)
                    .frame(width: 170, height: 170)
                    .scaleEffect(beatOn ? 1.12 : 1.0)
                    .animation(.easeOut(duration: interval * 0.5), value: beatOn)
                Circle()
                    .fill(AidTheme.heroGradient)
                    .frame(width: 130, height: 130)
                    .scaleEffect(beatOn ? 1.06 : 0.96)
                    .animation(.easeOut(duration: interval * 0.5), value: beatOn)
                VStack(spacing: 2) {
                    Text(running ? "\(beatCount)" : "110")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    Text(running ? "pushes" : "per min")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                }
            }
            Text(running ? "Push hard and fast with the beat. Let the chest rise fully between pushes." : "Start the beat and push in rhythm: at least 5 cm deep, full recoil.")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.subtle)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            Button(action: toggle) {
                Text(running ? "Stop the Beat" : "Start the Beat")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(running ? AidTheme.primary : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(running ? AnyShapeStyle(AidTheme.peach) : AnyShapeStyle(AidTheme.heroGradient))
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .aidCard(padding: 22)
    }

    private func toggle() {
        running ? stop() : start()
    }

    private func start() {
        running = true
        beatCount = 0
        AidHaptics.beat()
        beatOn = true
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            beatCount += 1
            AidHaptics.beat()
            beatOn.toggle()
        }
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
        running = false
        beatOn = false
    }
}

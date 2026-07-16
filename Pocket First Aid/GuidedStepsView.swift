import SwiftUI

/// Full-screen guided walkthrough: one big step per screen with progress.
struct GuidedStepsView: View {
    let emergency: AidEmergency
    @Environment(\.presentationMode) private var presentationMode

    @State private var index = 0
    @State private var appeared = false

    private var category: AidCategory {
        AidContent.category(emergency.categoryID)
    }

    private var isFinished: Bool {
        index >= emergency.steps.count
    }

    var body: some View {
        ZStack {
            AidTheme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                topBar
                if isFinished {
                    finishView
                } else {
                    stepView
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) { appeared = true }
        }
    }

    private var topBar: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    ZStack {
                        Circle().fill(AidTheme.card).frame(width: 38, height: 38)
                            .shadow(color: AidTheme.ink.opacity(0.08), radius: 5, x: 0, y: 2)
                        AidIcon(shape: AidXShape(), size: 15, color: AidTheme.ink, weight: 2.2)
                    }
                }
                Spacer()
                Text(emergency.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(AidTheme.ink)
                    .lineLimit(1)
                Spacer()
                Text(isFinished ? "Done" : "\(index + 1)/\(emergency.steps.count)")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(AidTheme.subtle)
                    .frame(width: 44, alignment: .trailing)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(category.soft)
                    Capsule()
                        .fill(category.tint)
                        .frame(width: max(10, geo.size.width * CGFloat(Double(min(index + 1, emergency.steps.count)) / Double(emergency.steps.count))))
                        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: index)
                }
            }
            .frame(height: 8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var stepView: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 12)
            VStack(spacing: 22) {
                ZStack {
                    Circle()
                        .fill(category.soft)
                        .frame(width: 94, height: 94)
                    Text("\(index + 1)")
                        .font(.system(size: 42, weight: .heavy, design: .rounded))
                        .foregroundColor(category.tint)
                }
                Text(emergency.steps[index])
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(AidTheme.ink)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 8)
                    .minimumScaleFactor(0.7)
            }
            .padding(26)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(AidTheme.card)
                    .shadow(color: AidTheme.ink.opacity(0.08), radius: 14, x: 0, y: 8)
            )
            .padding(.horizontal, 22)
            .id(index)
            .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)))
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 16)
            Spacer(minLength: 12)
            controls
        }
        .frame(maxWidth: 620)
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button(action: back) {
                HStack(spacing: 7) {
                    AidIcon(shape: AidChevronShape(pointRight: false), size: 15,
                            color: index == 0 ? AidTheme.subtle.opacity(0.35) : AidTheme.ink, weight: 2.2)
                    Text("Back")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(index == 0 ? AidTheme.subtle.opacity(0.35) : AidTheme.ink)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(AidTheme.card)
                        .shadow(color: AidTheme.ink.opacity(0.06), radius: 6, x: 0, y: 3)
                )
            }
            .disabled(index == 0)
            Button(action: next) {
                HStack(spacing: 7) {
                    Text(index + 1 == emergency.steps.count ? "Finish" : "Next Step")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                    AidIcon(shape: AidChevronShape(pointRight: true), size: 15, color: .white, weight: 2.4)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(AidTheme.heroGradient)
                )
            }
        }
        .padding(.horizontal, 22)
        .padding(.bottom, 24)
    }

    private var finishView: some View {
        VStack(spacing: 18) {
            Spacer()
            Image(emergency.art)
                .resizable()
                .scaledToFill()
                .frame(width: 170, height: 170)
                .clipShape(Circle())
                .overlay(Circle().stroke(AidTheme.card, lineWidth: 6))
                .shadow(color: AidTheme.ink.opacity(0.12), radius: 12, x: 0, y: 6)
            Text("All Steps Covered")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(AidTheme.ink)
            Text("Review the warnings and aftercare on the guide page, and remember: when in doubt, call for professional help.")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.subtle)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 44)
            Spacer()
            Button(action: { index = 0 }) {
                Text("Start Over")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(AidTheme.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(AidTheme.primary.opacity(0.4), lineWidth: 1.5)
                    )
            }
            .padding(.horizontal, 26)
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Done")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(AidTheme.heroGradient)
                    )
            }
            .padding(.horizontal, 26)
            .padding(.bottom, 26)
        }
        .frame(maxWidth: 620)
    }

    private func next() {
        AidHaptics.tap()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            index += 1
        }
        if isFinished {
            AidHaptics.success()
        }
    }

    private func back() {
        guard index > 0 else { return }
        AidHaptics.tap()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            index -= 1
        }
    }
}

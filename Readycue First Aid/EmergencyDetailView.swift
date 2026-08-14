import SwiftUI

/// Big, calm, numbered steps for one emergency.
struct EmergencyDetailView: View {
    let emergency: AidEmergency
    @EnvironmentObject var store: AidStore
    @Environment(\.presentationMode) private var presentationMode
    @State private var showGuided = false

    private var category: AidCategory {
        AidContent.category(emergency.categoryID)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack(alignment: .topLeading) {
                    Image(emergency.art)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 190)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        ZStack {
                            Circle().fill(Color.white.opacity(0.92)).frame(width: 38, height: 38)
                            AidIcon(shape: AidChevronShape(pointRight: false), size: 16, color: AidTheme.ink, weight: 2.2)
                        }
                    }
                    .padding(12)
                }

                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(emergency.title)
                            .font(.system(size: 27, weight: .bold, design: .rounded))
                            .foregroundColor(AidTheme.ink)
                        HStack(spacing: 7) {
                            severityBadge
                            Text(category.title)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(AidTheme.subtle)
                        }
                    }
                    Spacer()
                }

                callBanner

                guidedButton

                VStack(spacing: 12) {
                    ForEach(Array(emergency.steps.enumerated()), id: \.offset) { pair in
                        stepCard(number: pair.offset + 1, text: pair.element)
                    }
                }

                dontsCard

                if !emergency.aftercare.isEmpty {
                    aftercareCard
                }

                Text(AidContent.disclaimer)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(AidTheme.subtle.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .padding(.top, 4)
                Spacer().frame(height: 14)
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .background(AidTheme.background.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear { store.markOpened(emergency.id) }
        .fullScreenCover(isPresented: $showGuided) {
            GuidedStepsView(emergency: emergency)
        }
    }

    private var severityBadge: some View {
        Text(emergency.severity.title.uppercased())
            .font(.system(size: 10, weight: .heavy, design: .rounded))
            .foregroundColor(emergency.severity.tint)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(Capsule().fill(emergency.severity.soft))
    }

    private var guidedButton: some View {
        Button(action: {
            AidHaptics.tap()
            showGuided = true
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(Color.white.opacity(0.2)).frame(width: 40, height: 40)
                    AidIcon(shape: AidChevronShape(pointRight: true), size: 18, color: .white, weight: 2.6)
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text("Guided Mode")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("One big step at a time, hands-free pace")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                }
                Spacer()
                Text("\(emergency.steps.count) steps")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(14)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AidTheme.calmGradient)
                    Image("texture_soft")
                        .resizable(resizingMode: .tile)
                        .opacity(0.4)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .shadow(color: AidTheme.slate.opacity(0.3), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var aftercareCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 9) {
                AidIcon(shape: AidSparkleShape(), size: 20, color: AidTheme.sage, weight: 1.9)
                Text("Afterward")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(AidTheme.ink)
            }
            ForEach(Array(emergency.aftercare.enumerated()), id: \.offset) { pair in
                HStack(alignment: .top, spacing: 10) {
                    AidIcon(shape: AidCheckShape(), size: 13, color: AidTheme.sage, weight: 2.4)
                        .padding(.top, 3)
                    Text(pair.element)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(AidTheme.subtle)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AidTheme.sageSoft)
        )
    }

    private var callBanner: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(emergency.callFirst ? Color.white.opacity(0.2) : AidTheme.peach)
                    .frame(width: 44, height: 44)
                AidIcon(shape: PhoneShape(), size: 24,
                        color: emergency.callFirst ? .white : AidTheme.primary, weight: 1.9)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(emergency.callFirst ? "Call emergency services now" : "When to get medical help")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(emergency.callFirst ? .white : AidTheme.ink)
                Text(emergency.whenToCall)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(emergency.callFirst ? .white.opacity(0.9) : AidTheme.subtle)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(emergency.callFirst ? AnyShapeStyle(AidTheme.heroGradient) : AnyShapeStyle(AidTheme.card))
                .shadow(color: emergency.callFirst ? AidTheme.primaryDeep.opacity(0.25) : AidTheme.ink.opacity(0.05),
                        radius: 8, x: 0, y: 4)
        )
    }

    private func stepCard(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle().fill(category.soft).frame(width: 40, height: 40)
                Text("\(number)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(category.tint)
            }
            Text(text)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.ink)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .aidCard(padding: 14)
    }

    private var dontsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 9) {
                AidIcon(shape: WarnTriangleShape(), size: 20, color: AidTheme.amber, weight: 1.9)
                Text("Never do this")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(AidTheme.ink)
            }
            ForEach(Array(emergency.donts.enumerated()), id: \.offset) { pair in
                HStack(alignment: .top, spacing: 10) {
                    AidIcon(shape: AidXShape(), size: 13, color: AidTheme.primary, weight: 2.4)
                        .padding(.top, 3)
                    Text(pair.element)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(AidTheme.subtle)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AidTheme.amberSoft)
        )
    }
}

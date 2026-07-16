import SwiftUI

/// Big, calm, numbered steps for one emergency.
struct EmergencyDetailView: View {
    let emergency: AidEmergency
    @EnvironmentObject var store: AidStore
    @Environment(\.presentationMode) private var presentationMode

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
                    VStack(alignment: .leading, spacing: 2) {
                        Text(emergency.title)
                            .font(.system(size: 27, weight: .bold, design: .rounded))
                            .foregroundColor(AidTheme.ink)
                        Text(category.title)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(AidTheme.subtle)
                    }
                    Spacer()
                }

                callBanner

                VStack(spacing: 12) {
                    ForEach(Array(emergency.steps.enumerated()), id: \.offset) { pair in
                        stepCard(number: pair.offset + 1, text: pair.element)
                    }
                }

                dontsCard

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

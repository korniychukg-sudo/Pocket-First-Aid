import SwiftUI

struct MoreView: View {
    @EnvironmentObject var store: AidStore
    @State private var showPrivacy = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Text("More")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(AidTheme.ink)
                    Spacer()
                }
                .padding(.top, 6)

                numbersCard
                progressCard
                aboutCard
                Spacer().frame(height: 8)
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .background(AidTheme.background.ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(isPresented: $showPrivacy) {
            AidWebPanel(urlString: "https://example.com")
        }
    }

    private var numbersCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 9) {
                AidIcon(shape: PhoneShape(), size: 20, color: AidTheme.primary, weight: 1.9)
                Text("Emergency Numbers")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(AidTheme.ink)
            }
            Text("Memorize the number where you live and where you travel.")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.subtle)
            ForEach(AidContent.numbers) { entry in
                HStack {
                    Text(entry.region)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(AidTheme.ink)
                    Spacer()
                    Text(entry.number)
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundColor(AidTheme.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(AidTheme.peach))
                }
                if entry.id != AidContent.numbers.last?.id {
                    Rectangle().fill(AidTheme.line).frame(height: 1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .aidCard()
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your Progress")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(AidTheme.ink)
            progressRow(icon: AnyView(AidIcon(shape: AidBookShape(), size: 20, color: AidTheme.primary, weight: 1.8)),
                        label: "Guides read", value: "\(store.topicsOpened.count) of \(AidContent.emergencies.count)")
            progressRow(icon: AnyView(AidIcon(shape: AidStarShape(), size: 20, color: AidTheme.amber, weight: 1.8)),
                        label: "Best quiz round", value: store.quizRounds > 0 ? "\(store.quizBestScore) of 10" : "Not played yet")
            progressRow(icon: AnyView(AidIcon(shape: KitBoxShape(), size: 20, color: AidTheme.sage, weight: 1.8)),
                        label: "Kit items stocked",
                        value: "\(AidContent.kits.reduce(0) { $0 + store.checkedCount(kit: $1.id) }) of \(AidContent.kits.reduce(0) { $0 + $1.items.count })")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .aidCard()
    }

    private func progressRow(icon: AnyView, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            icon
            Text(label)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.subtle)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(AidTheme.ink)
        }
    }

    private var aboutCard: some View {
        VStack(spacing: 14) {
            Button(action: { showPrivacy = true }) {
                HStack {
                    Text("Privacy Policy")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(AidTheme.primary)
                    Spacer()
                    AidIcon(shape: AidChevronShape(pointRight: true), size: 14, color: AidTheme.subtle.opacity(0.5), weight: 2)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            Rectangle().fill(AidTheme.line).frame(height: 1)
            HStack(spacing: 8) {
                AidIcon(shape: AidShieldShape(), size: 18, color: AidTheme.sage, weight: 1.8)
                Text("No account. No tracking. Works fully offline.")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(AidTheme.sage)
                Spacer()
            }
            Text(AidContent.disclaimer)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.subtle)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            Text("Pocket First Aid 1.0")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.subtle.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .aidCard()
    }
}

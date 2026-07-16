import SwiftUI

struct RootView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case 0:
                    NavigationView { GuideHomeView() }
                        .navigationViewStyle(StackNavigationViewStyle())
                case 1:
                    NavigationView { CPRView() }
                        .navigationViewStyle(StackNavigationViewStyle())
                case 2:
                    NavigationView { KitView() }
                        .navigationViewStyle(StackNavigationViewStyle())
                case 3:
                    NavigationView { LearnView() }
                        .navigationViewStyle(StackNavigationViewStyle())
                default:
                    NavigationView { MoreView() }
                        .navigationViewStyle(StackNavigationViewStyle())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack(spacing: 0) {
                tabButton(index: 0, label: "Guide") { color in
                    AnyView(AidIcon(shape: AidCrossShape(), size: 24, color: color, weight: 1.9))
                }
                tabButton(index: 1, label: "CPR") { color in
                    AnyView(AidIcon(shape: PulseHeartShape(), size: 24, color: color, weight: 1.9))
                }
                tabButton(index: 2, label: "Kits") { color in
                    AnyView(AidIcon(shape: KitBoxShape(), size: 24, color: color, weight: 1.9))
                }
                tabButton(index: 3, label: "Learn") { color in
                    AnyView(AidIcon(shape: GradCapShape(), size: 24, color: color, weight: 1.9))
                }
                tabButton(index: 4, label: "More") { color in
                    AnyView(AidIcon(shape: MoreDotsShape(), size: 24, color: color, weight: 1.9))
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 6)
            .background(
                AidTheme.card
                    .shadow(color: AidTheme.ink.opacity(0.06), radius: 8, x: 0, y: -3)
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
        .background(AidTheme.background.ignoresSafeArea())
    }

    private func tabButton(index: Int, label: String, icon: (Color) -> AnyView) -> some View {
        let active = selectedTab == index
        let color = active ? AidTheme.primary : AidTheme.subtle.opacity(0.65)
        return Button(action: { selectedTab = index }) {
            VStack(spacing: 4) {
                icon(color)
                Text(label)
                    .font(.system(size: 11, weight: active ? .semibold : .medium, design: .rounded))
                    .foregroundColor(color)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

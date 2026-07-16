import SwiftUI

/// First aid kit checklists: home, car, travel.
struct KitView: View {
    @EnvironmentObject var store: AidStore
    @State private var selectedKit = "home"
    @State private var confirmReset = false

    private var kit: AidKit {
        AidContent.kits.first { $0.id == selectedKit } ?? AidContent.kits[0]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("My Kits")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(AidTheme.ink)
                        Text("Stock up before you need it")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(AidTheme.subtle)
                    }
                    Spacer()
                }
                .padding(.top, 6)

                HStack(spacing: 8) {
                    ForEach(AidContent.kits) { k in
                        kitChip(k)
                    }
                }

                ZStack(alignment: .bottomLeading) {
                    Image(kit.art)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(kit.title)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text(kit.subtitle)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        Spacer()
                        Text("\(store.checkedCount(kit: kit.id))/\(kit.items.count)")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color.black.opacity(0.35)))
                    }
                    .padding(14)
                }

                progressBar

                VStack(spacing: 8) {
                    ForEach(Array(kit.items.enumerated()), id: \.offset) { pair in
                        itemRow(index: pair.offset, text: pair.element)
                    }
                }

                Button(action: { confirmReset = true }) {
                    Text("Reset This Kit")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(AidTheme.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(AidTheme.primary.opacity(0.4), lineWidth: 1.5)
                        )
                }
                Spacer().frame(height: 8)
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .background(AidTheme.background.ignoresSafeArea())
        .navigationBarHidden(true)
        .alert(isPresented: $confirmReset) {
            Alert(
                title: Text("Reset \(kit.title)"),
                message: Text("All checkmarks in this kit will be cleared."),
                primaryButton: .destructive(Text("Reset")) { store.resetKit(kit.id) },
                secondaryButton: .cancel()
            )
        }
    }

    private func kitChip(_ k: AidKit) -> some View {
        let active = selectedKit == k.id
        return Button(action: {
            AidHaptics.tap()
            selectedKit = k.id
        }) {
            Text(k.title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(active ? .white : AidTheme.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(active ? AidTheme.primary : AidTheme.peach)
                )
        }
    }

    private var progressBar: some View {
        let done = store.checkedCount(kit: kit.id)
        let ratio = kit.items.isEmpty ? 0 : Double(done) / Double(kit.items.count)
        return VStack(alignment: .leading, spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(AidTheme.peach)
                    Capsule()
                        .fill(ratio >= 1.0 ? AidTheme.sage : AidTheme.primary)
                        .frame(width: max(8, geo.size.width * CGFloat(ratio)))
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: ratio)
                }
            }
            .frame(height: 10)
            if ratio >= 1.0 {
                HStack(spacing: 6) {
                    AidIcon(shape: AidCheckShape(), size: 13, color: AidTheme.sage, weight: 2.4)
                    Text("Fully stocked. Check expiry dates twice a year.")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(AidTheme.sage)
                }
            }
        }
    }

    private func itemRow(index: Int, text: String) -> some View {
        let checked = store.isChecked(kit: kit.id, index: index)
        return Button(action: {
            AidHaptics.tap()
            store.toggle(kit: kit.id, index: index)
        }) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(checked ? AidTheme.sage : AidTheme.card)
                        .frame(width: 26, height: 26)
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(checked ? AidTheme.sage : AidTheme.line, lineWidth: 1.6)
                        .frame(width: 26, height: 26)
                    if checked {
                        AidIcon(shape: AidCheckShape(), size: 13, color: .white, weight: 2.6)
                    }
                }
                Text(text)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(checked ? AidTheme.subtle : AidTheme.ink)
                    .strikethrough(checked, color: AidTheme.subtle.opacity(0.6))
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AidTheme.card)
                    .shadow(color: AidTheme.ink.opacity(0.04), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

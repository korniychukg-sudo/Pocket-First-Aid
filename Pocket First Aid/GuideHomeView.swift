import SwiftUI

struct GuideHomeView: View {
    @EnvironmentObject var store: AidStore
    @State private var query = ""

    private var searchResults: [AidEmergency] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return [] }
        return AidContent.emergencies.filter {
            $0.title.localizedCaseInsensitiveContains(trimmed)
        }
    }

    private var isWide: Bool {
        UIScreen.main.bounds.width > 700
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                emergencyBanner
                searchField
                if !query.trimmingCharacters(in: .whitespaces).isEmpty {
                    searchList
                } else {
                    categoryGrid
                }
                Spacer().frame(height: 8)
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .background(AidTheme.background.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Pocket First Aid")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(AidTheme.ink)
                Text("Calm steps for urgent moments")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(AidTheme.subtle)
            }
            Spacer()
            let opened = store.topicsOpened.count
            if opened > 0 {
                VStack(spacing: 1) {
                    Text("\(opened)/\(AidContent.emergencies.count)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(AidTheme.primary)
                    Text("read")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(AidTheme.subtle)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Capsule().fill(AidTheme.peach))
            }
        }
        .padding(.top, 6)
    }

    private var emergencyBanner: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(Color.white.opacity(0.18)).frame(width: 54, height: 54)
                AidIcon(shape: PhoneShape(), size: 28, color: .white, weight: 2.0)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Real emergency?")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("Call your local emergency number first. This app supports you while help is on the way.")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(AidTheme.heroGradient)
                Image("texture_soft")
                    .resizable(resizingMode: .tile)
                    .opacity(0.45)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .shadow(color: AidTheme.primaryDeep.opacity(0.25), radius: 12, x: 0, y: 6)
        )
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            AidIcon(shape: AidSparkleShape(), size: 16, color: AidTheme.subtle.opacity(0.7), weight: 1.6)
            TextField("Search: burn, choking, sting...", text: $query)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.ink)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            if !query.isEmpty {
                Button(action: { query = "" }) {
                    AidIcon(shape: AidXShape(), size: 14, color: AidTheme.subtle, weight: 2.0)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AidTheme.card)
                .shadow(color: AidTheme.ink.opacity(0.05), radius: 6, x: 0, y: 3)
        )
    }

    private var searchList: some View {
        VStack(spacing: 10) {
            if searchResults.isEmpty {
                VStack(spacing: 12) {
                    Image("empty_search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                    Text("Nothing matches yet. Try a shorter word.")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(AidTheme.subtle)
                }
                .padding(.top, 20)
            } else {
                ForEach(searchResults) { emergency in
                    NavigationLink(destination: EmergencyDetailView(emergency: emergency)) {
                        emergencyRow(emergency)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    private func emergencyRow(_ e: AidEmergency) -> some View {
        let cat = AidContent.category(e.categoryID)
        return HStack(spacing: 12) {
            Image(e.art)
                .resizable()
                .scaledToFill()
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text(e.title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(AidTheme.ink)
                Text(cat.title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(AidTheme.subtle)
            }
            Spacer()
            AidIcon(shape: AidChevronShape(pointRight: true), size: 14, color: AidTheme.subtle.opacity(0.5), weight: 2)
        }
        .aidCard(padding: 12)
    }

    private var categoryGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: isWide ? 3 : 2)
        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(AidContent.categories) { cat in
                NavigationLink(destination: CategoryView(category: cat)) {
                    VStack(alignment: .leading, spacing: 0) {
                        Image(cat.art)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 96)
                            .clipped()
                        VStack(alignment: .leading, spacing: 3) {
                            Text(cat.title)
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(AidTheme.ink)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            Text("\(AidContent.emergencies(in: cat.id).count) guides")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(AidTheme.subtle)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AidTheme.card)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: AidTheme.ink.opacity(0.06), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Category screen

struct CategoryView: View {
    let category: AidCategory
    @EnvironmentObject var store: AidStore
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ZStack(alignment: .topLeading) {
                    Image(category.art)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 170)
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
                        Text(category.title)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(AidTheme.ink)
                        Text(category.subtitle)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(AidTheme.subtle)
                    }
                    Spacer()
                }
                ForEach(AidContent.emergencies(in: category.id)) { emergency in
                    NavigationLink(destination: EmergencyDetailView(emergency: emergency)) {
                        HStack(spacing: 12) {
                            Image(emergency.art)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 56, height: 56)
                                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(emergency.title)
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(AidTheme.ink)
                                HStack(spacing: 5) {
                                    if emergency.callFirst {
                                        Text("CALL FIRST")
                                            .font(.system(size: 9, weight: .heavy, design: .rounded))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 7)
                                            .padding(.vertical, 3)
                                            .background(Capsule().fill(AidTheme.primary))
                                    }
                                    Text("\(emergency.steps.count) steps")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(AidTheme.subtle)
                                }
                            }
                            Spacer()
                            if store.topicsOpened.contains(emergency.id) {
                                AidIcon(shape: AidCheckShape(), size: 15, color: AidTheme.sage, weight: 2.4)
                            }
                            AidIcon(shape: AidChevronShape(pointRight: true), size: 14, color: AidTheme.subtle.opacity(0.5), weight: 2)
                        }
                        .aidCard(padding: 12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer().frame(height: 8)
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .background(AidTheme.background.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

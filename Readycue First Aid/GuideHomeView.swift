import SwiftUI

struct GuideHomeView: View {
    @EnvironmentObject var store: AidStore
    @State private var query = ""
    @State private var pulse = false

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
                    quickAccessRow
                    featuredCard
                    HStack {
                        Text("Browse by Category")
                            .font(.system(size: 19, weight: .bold, design: .rounded))
                            .foregroundColor(AidTheme.ink)
                        Spacer()
                    }
                    .padding(.top, 2)
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
                Text("Readycue: First Aid")
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
                Circle()
                    .stroke(Color.white.opacity(0.35), lineWidth: 2)
                    .frame(width: 62, height: 62)
                    .scaleEffect(pulse ? 1.14 : 0.96)
                    .opacity(pulse ? 0.15 : 0.7)
                Circle().fill(Color.white.opacity(0.18)).frame(width: 54, height: 54)
                AidIcon(shape: PhoneShape(), size: 28, color: .white, weight: 2.0)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false)) {
                    pulse = true
                }
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

    private var quickAccessRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Act Fast")
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundColor(AidTheme.ink)
            HStack(spacing: 10) {
                ForEach(AidContentPlus.quickAccessIDs, id: \.self) { id in
                    if let e = AidContent.emergencies.first(where: { $0.id == id }) {
                        NavigationLink(destination: EmergencyDetailView(emergency: e)) {
                            VStack(spacing: 7) {
                                Image(e.art)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 62, height: 62)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(AidTheme.card, lineWidth: 3))
                                    .shadow(color: AidTheme.ink.opacity(0.10), radius: 5, x: 0, y: 3)
                                Text(shortTitle(e))
                                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                                    .foregroundColor(AidTheme.ink)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.75)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func shortTitle(_ e: AidEmergency) -> String {
        switch e.id {
        case "choking-adult": return "Choking"
        case "severe-bleeding": return "Bleeding"
        case "heart-attack": return "Heart Attack"
        case "stroke": return "Stroke"
        default: return e.title
        }
    }

    private var featuredCard: some View {
        let featured = AidContentPlus.featuredEmergency()
        return NavigationLink(destination: EmergencyDetailView(emergency: featured)) {
            ZStack(alignment: .bottomLeading) {
                Image(featured.art)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 168)
                    .clipped()
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.45)]),
                    startPoint: .center, endPoint: .bottom
                )
                VStack(alignment: .leading, spacing: 3) {
                    Text("GUIDE OF THE DAY")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                        .tracking(1.2)
                    HStack(spacing: 8) {
                        Text(featured.title)
                            .font(.system(size: 21, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(featured.severity.title.uppercased())
                            .font(.system(size: 9, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(featured.severity.tint))
                    }
                    Text("Two quiet minutes today - real confidence tomorrow.")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(14)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: AidTheme.ink.opacity(0.12), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var categoryGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: isWide ? 3 : 2)
        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(AidContent.categories) { cat in
                NavigationLink(destination: CategoryView(category: cat)) {
                    categoryCell(cat)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private func categoryCell(_ cat: AidCategory) -> some View {
        let guides = AidContent.emergencies(in: cat.id)
        let read = guides.filter { store.topicsOpened.contains($0.id) }.count
        return VStack(alignment: .leading, spacing: 0) {
            Image(cat.art)
                .resizable()
                .scaledToFill()
                .frame(height: 96)
                .clipped()
            VStack(alignment: .leading, spacing: 6) {
                Text(cat.title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(AidTheme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                HStack(spacing: 8) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(cat.soft)
                            Capsule()
                                .fill(cat.tint)
                                .frame(width: max(read == 0 ? 0 : 6, geo.size.width * CGFloat(Double(read) / Double(max(guides.count, 1)))))
                        }
                    }
                    .frame(height: 6)
                    Text("\(read)/\(guides.count)")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(read == guides.count ? cat.tint : AidTheme.subtle)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AidTheme.card)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: AidTheme.ink.opacity(0.06), radius: 8, x: 0, y: 4)
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
                ForEach(AidContent.emergencies(in: category.id).sorted { $0.severity < $1.severity }) { emergency in
                    NavigationLink(destination: EmergencyDetailView(emergency: emergency)) {
                        HStack(spacing: 12) {
                            Image(emergency.art)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 56, height: 56)
                                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(emergency.title)
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(AidTheme.ink)
                                HStack(spacing: 6) {
                                    Text(emergency.severity.title.uppercased())
                                        .font(.system(size: 9, weight: .heavy, design: .rounded))
                                        .foregroundColor(emergency.severity.tint)
                                        .padding(.horizontal, 7)
                                        .padding(.vertical, 3)
                                        .background(Capsule().fill(emergency.severity.soft))
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

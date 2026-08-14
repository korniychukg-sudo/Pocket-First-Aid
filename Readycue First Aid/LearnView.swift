import SwiftUI

/// Learn hub: quiz rounds and first aid myth busting.
struct LearnView: View {
    @EnvironmentObject var store: AidStore

    private enum Mode {
        case hub, quiz, myths
    }

    @State private var mode: Mode = .hub

    // Quiz state
    @State private var round: [AidQuizQuestion] = []
    @State private var index = 0
    @State private var chosen: Int? = nil
    @State private var score = 0
    @State private var finished = false

    // Myth state
    @State private var mythOrder: [AidMyth] = []
    @State private var mythIndex = 0
    @State private var mythChoice: Bool? = nil

    private let roundSize = 10

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Learn")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(AidTheme.ink)
                        Text("Build reflexes before you need them")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(AidTheme.subtle)
                    }
                    Spacer()
                    if mode != .hub {
                        Button(action: backToHub) {
                            Text("Exit")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(AidTheme.primary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(AidTheme.peach))
                        }
                    }
                }
                .padding(.top, 6)

                switch mode {
                case .hub:
                    hubView
                case .quiz:
                    if finished {
                        resultCard
                    } else if !round.isEmpty {
                        questionCard
                    }
                case .myths:
                    if !mythOrder.isEmpty {
                        mythCard
                    }
                }
                Spacer().frame(height: 8)
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .background(AidTheme.background.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    // MARK: - Hub

    private var hubView: some View {
        VStack(spacing: 14) {
            ZStack(alignment: .bottomLeading) {
                Image("learn_hero")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.35)]),
                    startPoint: .center, endPoint: .bottom
                )
                Text("Five calm minutes here can matter more than anything else you do today.")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(14)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: AidTheme.ink.opacity(0.10), radius: 10, x: 0, y: 5)

            modeCard(
                title: "Quick Quiz",
                caption: "10 random questions from a pool of \(AidContentPlus.allQuiz.count), with explanations",
                stat: store.quizRounds > 0 ? "Best \(store.quizBestScore)/10 - \(store.quizRounds) rounds" : "Not played yet",
                tint: AidTheme.primary, soft: AidTheme.peach,
                icon: AnyView(AidIcon(shape: GradCapShape(), size: 26, color: AidTheme.primary, weight: 1.9))
            ) {
                startRound()
            }

            modeCard(
                title: "Myth Busters",
                caption: "True or myth? \(AidContentPlus.myths.count) famous first aid beliefs put on trial",
                stat: "\(store.mythsBusted.count) of \(AidContentPlus.myths.count) busted",
                tint: AidTheme.slate, soft: AidTheme.slateSoft,
                icon: AnyView(AidIcon(shape: AidSparkleShape(), size: 26, color: AidTheme.slate, weight: 1.9))
            ) {
                startMyths()
            }

            HStack(spacing: 0) {
                statBlock(value: "\(store.topicsOpened.count)/\(AidContent.emergencies.count)", caption: "guides read")
                Rectangle().fill(AidTheme.line).frame(width: 1, height: 36)
                statBlock(value: store.quizRounds > 0 ? "\(store.quizBestScore)/10" : "-", caption: "best quiz")
                Rectangle().fill(AidTheme.line).frame(width: 1, height: 36)
                statBlock(value: "\(store.mythsBusted.count)", caption: "myths busted")
            }
            .aidCard(padding: 14)
        }
    }

    private func modeCard(title: String, caption: String, stat: String, tint: Color, soft: Color,
                          icon: AnyView, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(soft)
                        .frame(width: 56, height: 56)
                    icon
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(AidTheme.ink)
                    Text(caption)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(AidTheme.subtle)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(stat)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(tint)
                }
                Spacer()
                AidIcon(shape: AidChevronShape(pointRight: true), size: 15, color: AidTheme.subtle.opacity(0.5), weight: 2)
            }
            .aidCard(padding: 14)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func statBlock(value: String, caption: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(AidTheme.primary)
            Text(caption)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.subtle)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Quiz

    private var questionCard: some View {
        let q = round[index]
        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Question \(index + 1) of \(round.count)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(AidTheme.subtle)
                Spacer()
                Text("Score \(score)")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(AidTheme.primary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(AidTheme.peach)
                    Capsule()
                        .fill(AidTheme.primary)
                        .frame(width: max(8, geo.size.width * CGFloat(Double(index) / Double(round.count))))
                        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: index)
                }
            }
            .frame(height: 8)

            Text(q.question)
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundColor(AidTheme.ink)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 10) {
                ForEach(0..<q.options.count, id: \.self) { i in
                    optionRow(q: q, i: i)
                }
            }

            if let picked = chosen {
                VStack(alignment: .leading, spacing: 8) {
                    Text(picked == q.correct ? "Correct" : "Not quite")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(picked == q.correct ? AidTheme.sage : AidTheme.primary)
                    Text(q.explanation)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(AidTheme.subtle)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(picked == q.correct ? AidTheme.sageSoft : AidTheme.peach)
                )

                Button(action: next) {
                    Text(index + 1 == round.count ? "See Results" : "Next Question")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(AidTheme.heroGradient)
                        )
                }
            }
        }
        .aidCard(padding: 18)
    }

    private func optionRow(q: AidQuizQuestion, i: Int) -> some View {
        let picked = chosen
        let isCorrect = i == q.correct
        let isPicked = picked == i
        var bg: Color = AidTheme.background
        var fg: Color = AidTheme.ink
        if picked != nil {
            if isCorrect {
                bg = AidTheme.sage; fg = .white
            } else if isPicked {
                bg = AidTheme.primary; fg = .white
            } else {
                fg = AidTheme.subtle
            }
        }
        return Button(action: { pick(i, q: q) }) {
            HStack {
                Text(q.options[i])
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(fg)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                if picked != nil && isCorrect {
                    AidIcon(shape: AidCheckShape(), size: 15, color: .white, weight: 2.6)
                } else if isPicked && !isCorrect {
                    AidIcon(shape: AidXShape(), size: 14, color: .white, weight: 2.6)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(bg)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(picked == nil ? AidTheme.line : Color.clear, lineWidth: 1.4)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(picked != nil)
    }

    private var resultCard: some View {
        VStack(spacing: 16) {
            Image(score >= 8 ? "learn_gold" : (score >= 5 ? "learn_silver" : "learn_bronze"))
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            Text("\(score) out of \(round.count)")
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundColor(AidTheme.ink)
            Text(resultLine)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.subtle)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            if score == store.quizBestScore && score > 0 {
                Text("New personal best")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(AidTheme.amber)
            }
            Button(action: startRound) {
                Text("Play Again")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(AidTheme.heroGradient)
                    )
            }
            Button(action: backToHub) {
                Text("Back to Learn")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(AidTheme.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .aidCard(padding: 22)
    }

    private var resultLine: String {
        switch score {
        case 9...: return "Outstanding. Your calm head would make a real difference."
        case 7...8: return "Strong result. Review the ones you missed and try again."
        case 5...6: return "Good base. The explanations are doing their job."
        default: return "Everyone starts somewhere. Each round makes you a safer person to be around."
        }
    }

    // MARK: - Myths

    private var mythCard: some View {
        let myth = mythOrder[mythIndex]
        let busted = store.mythsBusted.contains(myth.id)
        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Myth \(mythIndex + 1) of \(mythOrder.count)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(AidTheme.subtle)
                Spacer()
                if busted {
                    HStack(spacing: 5) {
                        AidIcon(shape: AidCheckShape(), size: 12, color: AidTheme.sage, weight: 2.6)
                        Text("Busted before")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(AidTheme.sage)
                    }
                }
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(AidTheme.slateSoft)
                    Capsule()
                        .fill(AidTheme.slate)
                        .frame(width: max(8, geo.size.width * CGFloat(Double(mythIndex) / Double(mythOrder.count))))
                        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: mythIndex)
                }
            }
            .frame(height: 8)

            Text("People say:")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(AidTheme.subtle)
            Text("\u{201C}\(myth.statement)\u{201D}")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(AidTheme.ink)
                .fixedSize(horizontal: false, vertical: true)

            if mythChoice == nil {
                HStack(spacing: 12) {
                    mythButton(label: "True", value: true, tint: AidTheme.sage)
                    mythButton(label: "Myth", value: false, tint: AidTheme.primary)
                }
            } else {
                let correct = mythChoice == myth.isTrue
                VStack(alignment: .leading, spacing: 8) {
                    Text(myth.isTrue ? (correct ? "Right - it is true" : "Actually, this one is true")
                                     : (correct ? "Busted - it is a myth" : "Careful - this one is a myth"))
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(correct ? AidTheme.sage : AidTheme.primary)
                    Text(myth.verdict)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(AidTheme.subtle)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(correct ? AidTheme.sageSoft : AidTheme.peach)
                )

                Button(action: nextMyth) {
                    Text(mythIndex + 1 == mythOrder.count ? "Finish" : "Next Myth")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(AidTheme.calmGradient)
                        )
                }
            }
        }
        .aidCard(padding: 18)
    }

    private func mythButton(label: String, value: Bool, tint: Color) -> some View {
        Button(action: { pickMyth(value) }) {
            Text(label)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(tint)
                )
        }
    }

    // MARK: - Logic

    private func backToHub() {
        AidHaptics.tap()
        mode = .hub
        round = []
        finished = false
        mythOrder = []
    }

    private func startRound() {
        AidHaptics.tap()
        round = Array(AidContentPlus.allQuiz.shuffled().prefix(roundSize))
        index = 0
        score = 0
        chosen = nil
        finished = false
        mode = .quiz
    }

    private func pick(_ i: Int, q: AidQuizQuestion) {
        guard chosen == nil else { return }
        chosen = i
        if i == q.correct {
            score += 1
            AidHaptics.success()
        } else {
            AidHaptics.error()
        }
    }

    private func next() {
        if index + 1 == round.count {
            finished = true
            store.recordQuiz(score: score)
        } else {
            index += 1
            chosen = nil
        }
    }

    private func startMyths() {
        AidHaptics.tap()
        mythOrder = AidContentPlus.myths.shuffled()
        mythIndex = 0
        mythChoice = nil
        mode = .myths
    }

    private func pickMyth(_ value: Bool) {
        guard mythChoice == nil else { return }
        mythChoice = value
        let myth = mythOrder[mythIndex]
        let correct = value == myth.isTrue
        store.recordMyth(id: myth.id, correct: correct)
        if correct {
            AidHaptics.success()
        } else {
            AidHaptics.error()
        }
    }

    private func nextMyth() {
        if mythIndex + 1 == mythOrder.count {
            backToHub()
        } else {
            mythIndex += 1
            mythChoice = nil
        }
    }
}

import SwiftUI

/// Quiz tab: 10 random questions per round with explanations.
struct LearnView: View {
    @EnvironmentObject var store: AidStore

    @State private var round: [AidQuizQuestion] = []
    @State private var index = 0
    @State private var chosen: Int? = nil
    @State private var score = 0
    @State private var finished = false

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
                }
                .padding(.top, 6)

                if round.isEmpty {
                    startCard
                } else if finished {
                    resultCard
                } else {
                    questionCard
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

    // MARK: - Start

    private var startCard: some View {
        VStack(spacing: 16) {
            Image("learn_hero")
                .resizable()
                .scaledToFit()
                .frame(height: 190)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            Text("Ten quick questions")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(AidTheme.ink)
            Text("Each round draws \(roundSize) random questions from \(AidContent.quiz.count). Wrong answers come with a short explanation - that is where the learning happens.")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.subtle)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
            if store.quizRounds > 0 {
                HStack(spacing: 0) {
                    statBlock(value: "\(store.quizBestScore)/\(roundSize)", caption: "best round")
                    Rectangle().fill(AidTheme.line).frame(width: 1, height: 36)
                    statBlock(value: "\(store.quizRounds)", caption: "rounds played")
                }
            }
            Button(action: startRound) {
                Text("Start Round")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(AidTheme.heroGradient)
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .aidCard(padding: 20)
    }

    private func statBlock(value: String, caption: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(AidTheme.primary)
            Text(caption)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(AidTheme.subtle)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Question

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

    // MARK: - Result

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
            Button(action: { round = []; finished = false }) {
                Text("Back to Overview")
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

    // MARK: - Logic

    private func startRound() {
        AidHaptics.tap()
        round = Array(AidContent.quiz.shuffled().prefix(roundSize))
        index = 0
        score = 0
        chosen = nil
        finished = false
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
}

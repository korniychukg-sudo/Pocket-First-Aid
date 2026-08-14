import SwiftUI

// Custom line-drawn icons. No SF Symbols, no emoji anywhere in the app.

struct AidCrossShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        let a = w * 0.30 // arm half-width
        p.move(to: CGPoint(x: w * 0.5 - a / 2, y: h * 0.10))
        p.addLine(to: CGPoint(x: w * 0.5 + a / 2, y: h * 0.10))
        p.addLine(to: CGPoint(x: w * 0.5 + a / 2, y: h * 0.5 - a / 2))
        p.addLine(to: CGPoint(x: w * 0.90, y: h * 0.5 - a / 2))
        p.addLine(to: CGPoint(x: w * 0.90, y: h * 0.5 + a / 2))
        p.addLine(to: CGPoint(x: w * 0.5 + a / 2, y: h * 0.5 + a / 2))
        p.addLine(to: CGPoint(x: w * 0.5 + a / 2, y: h * 0.90))
        p.addLine(to: CGPoint(x: w * 0.5 - a / 2, y: h * 0.90))
        p.addLine(to: CGPoint(x: w * 0.5 - a / 2, y: h * 0.5 + a / 2))
        p.addLine(to: CGPoint(x: w * 0.10, y: h * 0.5 + a / 2))
        p.addLine(to: CGPoint(x: w * 0.10, y: h * 0.5 - a / 2))
        p.addLine(to: CGPoint(x: w * 0.5 - a / 2, y: h * 0.5 - a / 2))
        p.closeSubpath()
        return p
    }
}

struct PulseHeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        // Heart outline
        p.move(to: CGPoint(x: w * 0.50, y: h * 0.26))
        p.addCurve(to: CGPoint(x: w * 0.10, y: h * 0.42),
                   control1: CGPoint(x: w * 0.34, y: h * 0.06),
                   control2: CGPoint(x: w * 0.08, y: h * 0.20))
        p.addCurve(to: CGPoint(x: w * 0.50, y: h * 0.88),
                   control1: CGPoint(x: w * 0.12, y: h * 0.62),
                   control2: CGPoint(x: w * 0.34, y: h * 0.76))
        p.addCurve(to: CGPoint(x: w * 0.90, y: h * 0.42),
                   control1: CGPoint(x: w * 0.66, y: h * 0.76),
                   control2: CGPoint(x: w * 0.88, y: h * 0.62))
        p.addCurve(to: CGPoint(x: w * 0.50, y: h * 0.26),
                   control1: CGPoint(x: w * 0.92, y: h * 0.20),
                   control2: CGPoint(x: w * 0.66, y: h * 0.06))
        p.closeSubpath()
        // Pulse line
        p.move(to: CGPoint(x: w * 0.22, y: h * 0.50))
        p.addLine(to: CGPoint(x: w * 0.38, y: h * 0.50))
        p.addLine(to: CGPoint(x: w * 0.46, y: h * 0.36))
        p.addLine(to: CGPoint(x: w * 0.56, y: h * 0.62))
        p.addLine(to: CGPoint(x: w * 0.62, y: h * 0.50))
        p.addLine(to: CGPoint(x: w * 0.78, y: h * 0.50))
        return p
    }
}

struct KitBoxShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.addRoundedRect(in: CGRect(x: w * 0.10, y: h * 0.28, width: w * 0.80, height: h * 0.58),
                         cornerSize: CGSize(width: 5, height: 5))
        // Handle
        p.move(to: CGPoint(x: w * 0.36, y: h * 0.28))
        p.addLine(to: CGPoint(x: w * 0.36, y: h * 0.16))
        p.addLine(to: CGPoint(x: w * 0.64, y: h * 0.16))
        p.addLine(to: CGPoint(x: w * 0.64, y: h * 0.28))
        // Plus mark
        p.move(to: CGPoint(x: w * 0.50, y: h * 0.44))
        p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.70))
        p.move(to: CGPoint(x: w * 0.37, y: h * 0.57))
        p.addLine(to: CGPoint(x: w * 0.63, y: h * 0.57))
        return p
    }
}

struct GradCapShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.50, y: h * 0.16))
        p.addLine(to: CGPoint(x: w * 0.92, y: h * 0.38))
        p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.60))
        p.addLine(to: CGPoint(x: w * 0.08, y: h * 0.38))
        p.closeSubpath()
        p.move(to: CGPoint(x: w * 0.26, y: h * 0.50))
        p.addLine(to: CGPoint(x: w * 0.26, y: h * 0.72))
        p.addQuadCurve(to: CGPoint(x: w * 0.74, y: h * 0.72), control: CGPoint(x: w * 0.50, y: h * 0.90))
        p.addLine(to: CGPoint(x: w * 0.74, y: h * 0.50))
        p.move(to: CGPoint(x: w * 0.86, y: h * 0.42))
        p.addLine(to: CGPoint(x: w * 0.86, y: h * 0.66))
        return p
    }
}

struct MoreDotsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        let r = min(w, h) * 0.11
        let xs = [w * 0.28, w * 0.72]
        let ys = [h * 0.28, h * 0.72]
        for x in xs {
            for y in ys {
                p.addEllipse(in: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            }
        }
        return p
    }
}

struct AidChevronShape: Shape {
    var pointRight: Bool = true
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        if pointRight {
            p.move(to: CGPoint(x: w * 0.34, y: h * 0.18))
            p.addLine(to: CGPoint(x: w * 0.68, y: h * 0.50))
            p.addLine(to: CGPoint(x: w * 0.34, y: h * 0.82))
        } else {
            p.move(to: CGPoint(x: w * 0.66, y: h * 0.18))
            p.addLine(to: CGPoint(x: w * 0.32, y: h * 0.50))
            p.addLine(to: CGPoint(x: w * 0.66, y: h * 0.82))
        }
        return p
    }
}

struct AidCheckShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.16, y: h * 0.54))
        p.addLine(to: CGPoint(x: w * 0.42, y: h * 0.78))
        p.addLine(to: CGPoint(x: w * 0.86, y: h * 0.24))
        return p
    }
}

struct AidXShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.24, y: h * 0.24))
        p.addLine(to: CGPoint(x: w * 0.76, y: h * 0.76))
        p.move(to: CGPoint(x: w * 0.76, y: h * 0.24))
        p.addLine(to: CGPoint(x: w * 0.24, y: h * 0.76))
        return p
    }
}

struct WarnTriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.50, y: h * 0.12))
        p.addLine(to: CGPoint(x: w * 0.92, y: h * 0.86))
        p.addLine(to: CGPoint(x: w * 0.08, y: h * 0.86))
        p.closeSubpath()
        p.move(to: CGPoint(x: w * 0.50, y: h * 0.38))
        p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.62))
        p.move(to: CGPoint(x: w * 0.50, y: h * 0.72))
        p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.74))
        return p
    }
}

struct PhoneShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.24, y: h * 0.14))
        p.addQuadCurve(to: CGPoint(x: w * 0.40, y: h * 0.36), control: CGPoint(x: w * 0.42, y: h * 0.18))
        p.addQuadCurve(to: CGPoint(x: w * 0.36, y: h * 0.50), control: CGPoint(x: w * 0.32, y: h * 0.44))
        p.addQuadCurve(to: CGPoint(x: w * 0.50, y: h * 0.64), control: CGPoint(x: w * 0.40, y: h * 0.58))
        p.addQuadCurve(to: CGPoint(x: w * 0.64, y: h * 0.60), control: CGPoint(x: w * 0.56, y: h * 0.68))
        p.addQuadCurve(to: CGPoint(x: w * 0.86, y: h * 0.76), control: CGPoint(x: w * 0.82, y: h * 0.58))
        p.addQuadCurve(to: CGPoint(x: w * 0.62, y: h * 0.88), control: CGPoint(x: w * 0.80, y: h * 0.88))
        p.addQuadCurve(to: CGPoint(x: w * 0.14, y: h * 0.36), control: CGPoint(x: w * 0.22, y: h * 0.74))
        p.addQuadCurve(to: CGPoint(x: w * 0.24, y: h * 0.14), control: CGPoint(x: w * 0.12, y: h * 0.20))
        p.closeSubpath()
        return p
    }
}

struct AidSparkleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2
        let inner = r * 0.22
        p.move(to: CGPoint(x: c.x, y: c.y - r))
        p.addQuadCurve(to: CGPoint(x: c.x + r, y: c.y), control: CGPoint(x: c.x + inner, y: c.y - inner))
        p.addQuadCurve(to: CGPoint(x: c.x, y: c.y + r), control: CGPoint(x: c.x + inner, y: c.y + inner))
        p.addQuadCurve(to: CGPoint(x: c.x - r, y: c.y), control: CGPoint(x: c.x - inner, y: c.y + inner))
        p.addQuadCurve(to: CGPoint(x: c.x, y: c.y - r), control: CGPoint(x: c.x - inner, y: c.y - inner))
        p.closeSubpath()
        return p
    }
}

struct MetronomeWaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.08, y: h * 0.5))
        p.addLine(to: CGPoint(x: w * 0.24, y: h * 0.5))
        p.addLine(to: CGPoint(x: w * 0.34, y: h * 0.22))
        p.addLine(to: CGPoint(x: w * 0.48, y: h * 0.78))
        p.addLine(to: CGPoint(x: w * 0.58, y: h * 0.34))
        p.addLine(to: CGPoint(x: w * 0.66, y: h * 0.5))
        p.addLine(to: CGPoint(x: w * 0.92, y: h * 0.5))
        return p
    }
}

struct AidShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.50, y: h * 0.10))
        p.addLine(to: CGPoint(x: w * 0.84, y: h * 0.24))
        p.addCurve(to: CGPoint(x: w * 0.50, y: h * 0.90),
                   control1: CGPoint(x: w * 0.84, y: h * 0.60),
                   control2: CGPoint(x: w * 0.72, y: h * 0.80))
        p.addCurve(to: CGPoint(x: w * 0.16, y: h * 0.24),
                   control1: CGPoint(x: w * 0.28, y: h * 0.80),
                   control2: CGPoint(x: w * 0.16, y: h * 0.60))
        p.closeSubpath()
        return p
    }
}

struct AidBookShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.50, y: h * 0.22))
        p.addQuadCurve(to: CGPoint(x: w * 0.12, y: h * 0.18), control: CGPoint(x: w * 0.30, y: h * 0.10))
        p.addLine(to: CGPoint(x: w * 0.12, y: h * 0.78))
        p.addQuadCurve(to: CGPoint(x: w * 0.50, y: h * 0.84), control: CGPoint(x: w * 0.30, y: h * 0.72))
        p.addQuadCurve(to: CGPoint(x: w * 0.88, y: h * 0.78), control: CGPoint(x: w * 0.70, y: h * 0.72))
        p.addLine(to: CGPoint(x: w * 0.88, y: h * 0.18))
        p.addQuadCurve(to: CGPoint(x: w * 0.50, y: h * 0.22), control: CGPoint(x: w * 0.70, y: h * 0.10))
        p.move(to: CGPoint(x: w * 0.50, y: h * 0.22))
        p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.84))
        return p
    }
}

struct AidStarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2
        let inner = r * 0.45
        for i in 0..<10 {
            let ang = CGFloat(i) * .pi / 5 - .pi / 2
            let rad = i % 2 == 0 ? r : inner
            let pt = CGPoint(x: c.x + rad * cos(ang), y: c.y + rad * sin(ang))
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}

/// A stroked icon with uniform styling.
struct AidIcon<S: Shape>: View {
    let shape: S
    var size: CGFloat = 24
    var color: Color = AidTheme.ink
    var weight: CGFloat = 1.8

    var body: some View {
        shape
            .stroke(color, style: StrokeStyle(lineWidth: weight, lineCap: .round, lineJoin: .round))
            .frame(width: size, height: size)
    }
}

/// A filled icon.
struct AidFillIcon<S: Shape>: View {
    let shape: S
    var size: CGFloat = 24
    var color: Color = AidTheme.ink

    var body: some View {
        shape
            .fill(color)
            .frame(width: size, height: size)
    }
}

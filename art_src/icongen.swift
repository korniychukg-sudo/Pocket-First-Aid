import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

let space = CGColorSpaceCreateDeviceRGB()

func col(_ r: Double, _ g: Double, _ b: Double, _ a: Double = 1) -> CGColor {
    CGColor(colorSpace: space, components: [CGFloat(r), CGFloat(g), CGFloat(b), CGFloat(a)])!
}

let size = 1024
let ctx = CGContext(data: nil, width: size, height: size, bitsPerComponent: 8,
                    bytesPerRow: size * 4, space: space,
                    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
ctx.setShouldAntialias(true)
ctx.interpolationQuality = .high

let s = Double(size)
ctx.translateBy(x: 0, y: CGFloat(s))
ctx.scaleBy(x: 1, y: -1)

struct IconRNG {
    var state: UInt64 = 0xA1D5EEDBEEF01234
    mutating func next() -> Double {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return Double(state % 1_000_000) / 1_000_000.0
    }
}
var rng = IconRNG()

let ink = col(0.150, 0.200, 0.231)
let cream = col(0.992, 0.976, 0.953)
let creamShade = col(0.945, 0.914, 0.871)
let coral = col(0.878, 0.333, 0.282)
let coralDeep = col(0.690, 0.227, 0.188)
let coralLight = col(0.933, 0.463, 0.404)
let peach = col(0.984, 0.890, 0.863)
let amber = col(0.937, 0.651, 0.247)
let amberDeep = col(0.808, 0.525, 0.169)
let sage = col(0.298, 0.686, 0.490)
let sageDeep = col(0.227, 0.549, 0.384)

if let g = CGGradient(colorsSpace: space,
                      colors: [coralLight, coral, coralDeep] as CFArray,
                      locations: [0.0, 0.55, 1.0]) {
    ctx.drawLinearGradient(g, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: s), options: [])
}

for _ in 0..<90 {
    let x = rng.next() * s
    let y = rng.next() * s
    let r = 1.2 + rng.next() * 2.4
    let a = 0.04 + rng.next() * 0.07
    ctx.setFillColor(col(1, 1, 1, a))
    ctx.fillEllipse(in: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
}

func sparkle(_ cx: Double, _ cy: Double, _ r: Double, _ alpha: Double) {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: cx, y: cy - r))
    path.addQuadCurve(to: CGPoint(x: cx + r, y: cy), control: CGPoint(x: cx + r * 0.18, y: cy - r * 0.18))
    path.addQuadCurve(to: CGPoint(x: cx, y: cy + r), control: CGPoint(x: cx + r * 0.18, y: cy + r * 0.18))
    path.addQuadCurve(to: CGPoint(x: cx - r, y: cy), control: CGPoint(x: cx - r * 0.18, y: cy + r * 0.18))
    path.addQuadCurve(to: CGPoint(x: cx, y: cy - r), control: CGPoint(x: cx - r * 0.18, y: cy - r * 0.18))
    path.closeSubpath()
    ctx.setFillColor(col(1, 0.98, 0.94, alpha))
    ctx.addPath(path)
    ctx.fillPath()
}

sparkle(s * 0.845, s * 0.180, s * 0.052, 0.95)
sparkle(s * 0.155, s * 0.800, s * 0.036, 0.75)
ctx.setFillColor(col(1, 0.98, 0.94, 0.8))
ctx.fillEllipse(in: CGRect(x: s * 0.130, y: s * 0.215, width: s * 0.022, height: s * 0.022))
ctx.fillEllipse(in: CGRect(x: s * 0.868, y: s * 0.760, width: s * 0.017, height: s * 0.017))

let plateC = CGPoint(x: s * 0.5, y: s * 0.5)
let plateR = s * 0.372
ctx.setFillColor(col(0.984, 0.890, 0.863, 0.98))
ctx.fillEllipse(in: CGRect(x: plateC.x - plateR, y: plateC.y - plateR, width: plateR * 2, height: plateR * 2))
ctx.setStrokeColor(col(1, 1, 1, 0.85))
ctx.setLineWidth(CGFloat(s * 0.008))
ctx.strokeEllipse(in: CGRect(x: plateC.x - plateR * 0.985, y: plateC.y - plateR * 0.985,
                             width: plateR * 1.97, height: plateR * 1.97))

let kitW = s * 0.470
let kitH = s * 0.340
let kitX = s * 0.5 - kitW / 2
let kitY = s * 0.395
let kitR = s * 0.052
let lineW = CGFloat(s * 0.0165)

ctx.setFillColor(col(0.60, 0.17, 0.14, 0.18))
ctx.fillEllipse(in: CGRect(x: s * 0.5 - kitW * 0.54, y: kitY + kitH - s * 0.012,
                           width: kitW * 1.08, height: s * 0.055))

let handle = CGMutablePath()
let hw = kitW * 0.34
let hTop = kitY - s * 0.078
handle.move(to: CGPoint(x: s * 0.5 - hw / 2, y: kitY + s * 0.02))
handle.addCurve(to: CGPoint(x: s * 0.5 + hw / 2, y: kitY + s * 0.02),
                control1: CGPoint(x: s * 0.5 - hw * 0.42, y: hTop),
                control2: CGPoint(x: s * 0.5 + hw * 0.42, y: hTop))
ctx.addPath(handle)
ctx.setStrokeColor(ink)
ctx.setLineWidth(CGFloat(s * 0.030))
ctx.setLineCap(.round)
ctx.strokePath()

let kitRect = CGRect(x: kitX, y: kitY, width: kitW, height: kitH)
let kitPath = CGPath(roundedRect: kitRect, cornerWidth: CGFloat(kitR), cornerHeight: CGFloat(kitR), transform: nil)
ctx.addPath(kitPath)
ctx.setFillColor(cream)
ctx.fillPath()

ctx.saveGState()
ctx.addPath(kitPath)
ctx.clip()
ctx.setFillColor(creamShade)
ctx.fill(CGRect(x: kitX, y: kitY + kitH * 0.78, width: kitW, height: kitH * 0.22))
ctx.setFillColor(coral)
ctx.fill(CGRect(x: kitX, y: kitY, width: kitW, height: kitH * 0.205))
ctx.setFillColor(coralDeep)
ctx.fill(CGRect(x: kitX, y: kitY + kitH * 0.165, width: kitW, height: kitH * 0.04))
ctx.restoreGState()

ctx.addPath(kitPath)
ctx.setStrokeColor(ink)
ctx.setLineWidth(lineW)
ctx.strokePath()

let crossC = CGPoint(x: s * 0.5, y: kitY + kitH * 0.615)
let arm = s * 0.0525
let ext = s * 0.124
let vBar = CGPath(roundedRect: CGRect(x: crossC.x - arm, y: crossC.y - ext, width: arm * 2, height: ext * 2),
                  cornerWidth: CGFloat(s * 0.020), cornerHeight: CGFloat(s * 0.020), transform: nil)
let hBar = CGPath(roundedRect: CGRect(x: crossC.x - ext, y: crossC.y - arm, width: ext * 2, height: arm * 2),
                  cornerWidth: CGFloat(s * 0.020), cornerHeight: CGFloat(s * 0.020), transform: nil)
let crossPath = vBar.union(hBar)
ctx.addPath(crossPath)
ctx.setFillColor(sage)
ctx.fillPath()
ctx.saveGState()
ctx.addPath(crossPath)
ctx.clip()
ctx.setFillColor(sageDeep)
ctx.fill(CGRect(x: crossC.x - ext, y: crossC.y + ext * 0.62, width: ext * 2, height: ext * 0.38))
ctx.restoreGState()
ctx.addPath(crossPath)
ctx.setStrokeColor(ink)
ctx.setLineWidth(CGFloat(s * 0.012))
ctx.strokePath()

func plaster(center: CGPoint, angle: Double, len: Double, wid: Double) {
    ctx.saveGState()
    ctx.translateBy(x: center.x, y: center.y)
    ctx.rotate(by: CGFloat(angle))
    let rect = CGRect(x: -len / 2, y: -wid / 2, width: len, height: wid)
    let p = CGPath(roundedRect: rect, cornerWidth: CGFloat(wid / 2), cornerHeight: CGFloat(wid / 2), transform: nil)
    ctx.addPath(p)
    ctx.setFillColor(amber)
    ctx.fillPath()
    ctx.saveGState()
    ctx.addPath(p)
    ctx.clip()
    ctx.setFillColor(amberDeep.copy(alpha: 0.45)!)
    ctx.fill(CGRect(x: -len / 2, y: wid * 0.22, width: len, height: wid * 0.28))
    ctx.restoreGState()
    let pad = CGRect(x: -wid * 0.34, y: -wid * 0.34, width: wid * 0.68, height: wid * 0.68)
    let padPath = CGPath(roundedRect: pad, cornerWidth: CGFloat(wid * 0.14), cornerHeight: CGFloat(wid * 0.14), transform: nil)
    ctx.addPath(padPath)
    ctx.setFillColor(cream)
    ctx.fillPath()
    ctx.setFillColor(col(0.55, 0.42, 0.20, 0.75))
    for sx in [-1.0, 1.0] {
        for (dx, dy) in [(0.33, -0.16), (0.40, 0.10), (0.30, 0.22)] {
            let px = sx * len * dx
            let py = wid * dy
            let dr = wid * 0.045
            ctx.fillEllipse(in: CGRect(x: px - dr, y: py - dr, width: dr * 2, height: dr * 2))
        }
    }
    ctx.addPath(p)
    ctx.setStrokeColor(ink)
    ctx.setLineWidth(CGFloat(s * 0.011))
    ctx.strokePath()
    ctx.restoreGState()
}

plaster(center: CGPoint(x: s * 0.700, y: s * 0.712), angle: -0.52, len: s * 0.30, wid: s * 0.105)
plaster(center: CGPoint(x: s * 0.310, y: s * 0.302), angle: -0.52, len: s * 0.24, wid: s * 0.086)

let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "./AppIcon-1024.png"
if let img = ctx.makeImage(),
   let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: out) as CFURL,
                                              UTType.png.identifier as CFString, 1, nil) {
    CGImageDestinationAddImage(dest, img, nil)
    CGImageDestinationFinalize(dest)
    print("icon written \(out)")
}

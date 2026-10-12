import SwiftUI

struct WaveBanner: View {
    let imageData: Data
    let title: String
    let subtitle: String
    var accessibilityImageLabel: String = ""

    var body: some View {
        ZStack {
            FullBleedBackground(data: imageData, accessibilityLabel: accessibilityImageLabel)
                .frame(height: 240)
                .mask {
                    WaveShape()
                }

            VStack(spacing: 0) {
                PrismaTitle(text: title, size: 32, stroked: true, alignment: .center)
                PrismaTitle(text: subtitle, size: 20, stroked: true, alignment: .center)
            }
            .padding(.horizontal, 64)
        }
        .frame(height: 240)
    }
}

private struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let waveHeight: CGFloat = 14

        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - waveHeight))
        path.addQuadCurve(
            to: CGPoint(x: rect.width / 2, y: rect.height - waveHeight),
            control: CGPoint(x: rect.width * 0.75, y: rect.height)
        )
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height),
            control: CGPoint(x: rect.width * 0.25, y: rect.height - (waveHeight * 2))
        )
        path.closeSubpath()
        return path
    }
}

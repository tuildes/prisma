import SwiftUI

struct PrismaTitle: View {
    let text: String
    var size: CGFloat = 24
    var stroked: Bool = false
    var lightMode: Bool = false
    var alignment: TextAlignment = .leading

    var body: some View {
        Text(text)
            .font(prismaFont(size: size))
            .foregroundStyle(foreground)
            .shadow(
                color: stroked ? shadowColor : .clear,
                radius: stroked ? 2 : 0
            )
            .multilineTextAlignment(alignment)
            .accessibilityLabel(text)
    }

    private var foreground: Color {
        guard stroked else { return Color.text }
        return lightMode ? .black : .white
    }

    private var shadowColor: Color {
        lightMode ? .white : .black
    }

    private func prismaFont(size: CGFloat) -> Font {
        if UIFont(name: "Staatliches", size: size) != nil {
            return .custom("Staatliches", size: size)
        }
        return .system(size: size, weight: .bold, design: .rounded)
    }
}

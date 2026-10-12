import SwiftUI

struct PolaroidCard: View {
    let aesthetic: AestheticModel
    var rotation: Double = 0
    var action: (() -> Void)?

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            coverImage
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

            VStack(alignment: .trailing, spacing: -4) {
                PrismaTitle(text: aesthetic.name, size: 36, alignment: .trailing)
                PrismaTitle(
                    text: "\(aesthetic.totalReferences) references",
                    size: 16,
                    alignment: .trailing
                )
            }
            .padding(.trailing, 4)
        }
        .padding(12)
        .background {
            Image("paper_texture")
                .resizable()
                .scaledToFill()
                .clipped()
        }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
        .rotationEffect(.radians(rotation))
        .contentShape(Rectangle())
        .onTapGesture {
            action?()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(aesthetic.name), \(aesthetic.totalReferences) references")
        .accessibilityHint(aesthetic.imageDescription)
        .modifier(PolaroidAccessibilityModifier(action: action))
    }

    @ViewBuilder
    private var coverImage: some View {
        ZStack {
            Color.black.opacity(0.06)

            if let uiImage = UIImage(data: aesthetic.coverImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Image(systemName: "photo")
                    .foregroundStyle(Color.tint)
            }
        }
    }
}

private struct PolaroidAccessibilityModifier: ViewModifier {
    let action: (() -> Void)?

    @ViewBuilder
    func body(content: Content) -> some View {
        if let action {
            content
                .accessibilityAddTraits(.isButton)
                .accessibilityAction { action() }
        } else {
            content
        }
    }
}

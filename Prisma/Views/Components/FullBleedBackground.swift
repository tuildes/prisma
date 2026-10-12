import SwiftUI

/// Bound full-bleed image so `scaledToFill` cannot collapse to a black screen.
struct FullBleedBackground: View {
    let image: Image
    var accessibilityLabel: String?

    var body: some View {
        GeometryReader { proxy in
            image
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                .accessibilityLabel(accessibilityLabel ?? "Background")
        }
        .ignoresSafeArea()
    }
}

extension FullBleedBackground {
    init(uiImage: UIImage?, accessibilityLabel: String? = nil) {
        if let uiImage {
            self.init(image: Image(uiImage: uiImage), accessibilityLabel: accessibilityLabel)
        } else {
            self.init(image: Image(systemName: "photo"), accessibilityLabel: accessibilityLabel)
        }
    }

    init(data: Data, accessibilityLabel: String? = nil) {
        self.init(uiImage: UIImage(data: data), accessibilityLabel: accessibilityLabel)
    }
}

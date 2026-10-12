import SwiftUI

struct FullscreenImageView: View {
    let imageData: Data
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .accessibilityLabel("Fullscreen reference")
            }
        }
        .statusBarHidden(true)
    }
}

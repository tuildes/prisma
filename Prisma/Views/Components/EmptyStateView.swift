import SwiftUI

struct EmptyStateView: View {
    var title: String = "No Aesthetics Yet"
    var message: String = "Tap + to create your first aesthetic."

    var body: some View {
        VStack(spacing: 16) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 160)
                .accessibilityHidden(true)

            PrismaTitle(text: title, size: 28, alignment: .center)

            Text(message)
                .font(.system(size: 16))
                .foregroundStyle(Color.text.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
    }
}

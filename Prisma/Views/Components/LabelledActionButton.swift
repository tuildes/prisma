import SwiftUI

struct LabelledActionButton: View {
    let systemImage: String
    let title: String
    var lightMode: Bool = false
    var enabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .semibold))
                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundStyle(lightMode ? Color.black : Color.white)
            .shadow(color: lightMode ? .white : .black, radius: 2)
            .frame(minWidth: 64)
            .opacity(enabled ? 1 : 0.35)
        }
        .disabled(!enabled)
        .buttonStyle(.plain)
    }
}

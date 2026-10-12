import PhotosUI
import SwiftUI
import UIKit

struct FormSection<Content: View>: View {
    let title: String
    var required: Bool
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 8) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.highlight)
                    .textCase(.uppercase)

                Spacer(minLength: 8)

                RequirementBadge(required: required)
            }

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RequirementBadge: View {
    var required: Bool

    var body: some View {
        Text(required ? "Required" : "Optional")
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(required ? Color.text : Color.text.opacity(0.72))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                required ? Color.brand.opacity(0.28) : Color.text.opacity(0.1),
                in: Capsule()
            )
            .accessibilityLabel(required ? "Required" : "Optional")
    }
}

struct PrismaFormField: View {
    let title: String
    @Binding var text: String
    var prompt: String
    var caption: String?
    var keyboard: UIKeyboardType = .default
    var capitalization: TextInputAutocapitalization = .sentences
    var autocorrectionDisabled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.text)

            TextField(prompt, text: $text)
                .textFieldStyle(.plain)
                .textInputAutocapitalization(capitalization)
                .keyboardType(keyboard)
                .autocorrectionDisabled(autocorrectionDisabled)
                .prismaFieldSurface()

            if let caption {
                Text(caption)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.text.opacity(0.6))
            }
        }
    }
}

struct PhotoPickerWell: View {
    let title: String
    let image: UIImage?
    @Binding var pickerItem: PhotosPickerItem?

    var body: some View {
        PhotosPicker(selection: $pickerItem, matching: .images) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.surface)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.text.opacity(0.16), lineWidth: 1)
                    }

                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 28))
                        Text(title)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundStyle(Color.brand)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 220)
            .clipped()
        }
        .accessibilityLabel(title)
    }
}

extension View {
    func prismaFieldSurface() -> some View {
        foregroundStyle(Color.text)
            .padding(12)
            .background(Color.surface, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(Color.text.opacity(0.16), lineWidth: 1)
            }
    }
}

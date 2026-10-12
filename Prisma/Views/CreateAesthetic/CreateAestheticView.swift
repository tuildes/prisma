import PhotosUI
import SwiftData
import SwiftUI

struct CreateAestheticView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel = CreateAestheticViewModel()
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                Text("Both sections are required to create an aesthetic.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.text.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)

                FormSection(title: "Cover", required: true) {
                    PhotoPickerWell(
                        title: "Choose Photo",
                        image: viewModel.image,
                        pickerItem: $pickerItem
                    )
                }

                FormSection(title: "About this aesthetic", required: true) {
                    VStack(alignment: .leading, spacing: 16) {
                        PrismaFormField(
                            title: "Name",
                            text: $viewModel.aestheticName,
                            prompt: "e.g. Soft Film",
                            caption: "Up to 30 characters",
                            capitalization: .words
                        )
                        PrismaFormField(
                            title: "Description",
                            text: $viewModel.imageDescription,
                            prompt: "What does this aesthetic feel like?"
                        )
                    }
                }

                Button("Create Aesthetic") {
                    viewModel.createAesthetic()
                }
                .buttonStyle(PrismaPrimaryButtonStyle())
            }
            .padding(20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.background.ignoresSafeArea())
        .navigationTitle("New Aesthetic")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.configure(modelContext: modelContext)
        }
        .onChange(of: pickerItem) { _, item in
            Task {
                await loadImage(from: item)
            }
        }
        .alert("Form Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .alert("Success", isPresented: $viewModel.didSucceed) {
            Button("OK") {
                router.pop()
            }
        } message: {
            Text("Aesthetic created successfully!")
        }
    }

    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item else { return }
        if let data = try? await item.loadTransferable(type: Data.self),
            let image = UIImage(data: data)
        {
            viewModel.image = image
        }
    }
}

struct PrismaPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.brand.opacity(configuration.isPressed ? 0.85 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

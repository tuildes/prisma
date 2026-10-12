import PhotosUI
import SwiftData
import SwiftUI

struct CreateImageView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel: CreateImageViewModel
    @State private var pickerItem: PhotosPickerItem?

    init(preselectedAestheticID: UUID? = nil) {
        _viewModel = State(
            initialValue: CreateImageViewModel(preselectedAestheticID: preselectedAestheticID)
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                Text("Fill in every required section. Optional details can be left blank.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.text.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)

                FormSection(title: "Photo", required: true) {
                    PhotoPickerWell(
                        title: "Choose Photo",
                        image: viewModel.image,
                        pickerItem: $pickerItem
                    )
                }

                FormSection(title: "About this reference", required: true) {
                    VStack(alignment: .leading, spacing: 16) {
                        PrismaFormField(
                            title: "Title",
                            text: $viewModel.title,
                            prompt: "Image title",
                            capitalization: .words
                        )
                        PrismaFormField(
                            title: "Author",
                            text: $viewModel.author,
                            prompt: "Author name",
                            capitalization: .words
                        )
                        PrismaFormField(
                            title: "Description",
                            text: $viewModel.imageDescription,
                            prompt: "What is in this image?"
                        )
                    }
                }

                FormSection(title: "Aesthetic", required: true) {
                    aestheticPicker
                }

                FormSection(title: "Extra details", required: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        PrismaFormField(
                            title: "Source URL",
                            text: $viewModel.sourceURL,
                            prompt: "https://…",
                            keyboard: .URL,
                            capitalization: .never,
                            autocorrectionDisabled: true
                        )

                        VStack(alignment: .leading, spacing: 4) {
                            Toggle("Light image (dark HUD)", isOn: $viewModel.isLightMode)
                                .tint(Color.brand)
                                .foregroundStyle(Color.text)
                            Text("Use a dark title when the photo is bright.")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.text.opacity(0.6))
                        }
                    }
                }

                Button("Create Image") {
                    viewModel.createImage()
                }
                .buttonStyle(PrismaPrimaryButtonStyle())
            }
            .padding(20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.background.ignoresSafeArea())
        .navigationTitle("New Image")
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
            Text("Image created successfully!")
        }
    }

    @ViewBuilder
    private var aestheticPicker: some View {
        if viewModel.aesthetics.isEmpty {
            Text("Create an aesthetic on the home screen before saving a reference.")
                .font(.system(size: 14))
                .foregroundStyle(Color.text.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)
        } else {
            Menu {
                ForEach(viewModel.aesthetics) { aesthetic in
                    Button(aesthetic.name) {
                        viewModel.selectedAestheticID = aesthetic.id
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedAestheticName)
                        .foregroundStyle(Color.text)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(Color.highlight)
                }
                .prismaFieldSurface()
            }
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

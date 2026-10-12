import SwiftData
import SwiftUI

struct ImageDetailView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel: ImageDetailViewModel
    @State private var showDeleteConfirmation = false

    init(imageID: UUID) {
        _viewModel = State(initialValue: ImageDetailViewModel(imageID: imageID))
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let model = viewModel.imageModel {
                FullBleedBackground(
                    data: model.image,
                    accessibilityLabel: model.imageDescription
                )

                hud(for: model)
                    .opacity(viewModel.isHUDHidden ? 0.2 : 1)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.isHUDHidden)
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
            } else {
                Color.background
                ProgressView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .confirmationDialog(
            "Delete Image",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                viewModel.deleteImage()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Delete this reference image?")
        }
        .fullScreenCover(isPresented: $viewModel.showFullscreen) {
            if let model = viewModel.imageModel {
                FullscreenImageView(imageData: model.image) {
                    viewModel.showFullscreen = false
                }
            }
        }
        .task {
            viewModel.configure(modelContext: modelContext)
        }
        .onChange(of: viewModel.didDelete) { _, deleted in
            if deleted {
                router.pop()
            }
        }
        .statusBarHidden(false)
    }

    private func hud(for model: ImageModel) -> some View {
        VStack(alignment: .trailing, spacing: 12) {
            PrismaTitle(
                text: model.title,
                size: 48,
                stroked: true,
                lightMode: model.isLightMode,
                alignment: .trailing
            )

            PrismaTitle(
                text: "By \(model.author)",
                size: 20,
                stroked: true,
                lightMode: model.isLightMode,
                alignment: .trailing
            )

            HStack(spacing: 0) {
                LabelledActionButton(
                    systemImage: "arrow.up.right.square",
                    title: "Open",
                    lightMode: model.isLightMode,
                    enabled: viewModel.hasSourceURL
                ) {
                    viewModel.openURL()
                }

                LabelledActionButton(
                    systemImage: "photo",
                    title: "View",
                    lightMode: model.isLightMode
                ) {
                    viewModel.showFullscreen = true
                }

                LabelledActionButton(
                    systemImage: "eye.slash",
                    title: "Hide HUD",
                    lightMode: model.isLightMode
                ) {
                    viewModel.toggleHUD()
                }
            }
        }
    }
}

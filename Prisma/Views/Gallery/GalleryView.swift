import SwiftData
import SwiftUI

struct GalleryView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel: GalleryViewModel
    @State private var showDeleteConfirmation = false

    init(aestheticID: UUID) {
        _viewModel = State(initialValue: GalleryViewModel(aestheticID: aestheticID))
    }

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]

    var body: some View {
        VStack(spacing: 8) {
            if let aesthetic = viewModel.aesthetic {
                WaveBanner(
                    imageData: aesthetic.coverImage,
                    title: aesthetic.name,
                    subtitle: "\(aesthetic.totalReferences) references",
                    accessibilityImageLabel: aesthetic.imageDescription
                )
            }

            if viewModel.isEmpty {
                Spacer()
                PrismaTitle(
                    text: "No Images Available\nTap + on Home to add images.",
                    size: 20,
                    alignment: .center
                )
                .padding(.horizontal, 24)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(viewModel.references) { image in
                            Button {
                                router.push(.imageDetail(imageID: image.id))
                            } label: {
                                imageTile(image)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 16)
                }
            }
        }
        .background(Color.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
                .accessibilityLabel("Delete aesthetic")
            }
        }
        .confirmationDialog(
            "Delete Aesthetic",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                viewModel.deleteAesthetic()
                router.pop()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this aesthetic? This action cannot be undone.")
        }
        .task {
            viewModel.configure(modelContext: modelContext)
        }
        .onAppear {
            viewModel.reload()
        }
    }

    @ViewBuilder
    private func imageTile(_ image: ImageModel) -> some View {
        Group {
            if let uiImage = UIImage(data: image.image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.surface
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
        .contentShape(Rectangle())
        .accessibilityLabel(image.title)
    }
}

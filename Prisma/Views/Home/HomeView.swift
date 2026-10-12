import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HomeViewModel()
    @State private var dragOffset: CGFloat = 0
    @State private var isCommittingSwipe = false

    var body: some View {
        Group {
            if viewModel.isEmptyState {
                EmptyStateView()
            } else {
                deck
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top) {
            header
        }
        .background(Color.background.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .task {
            viewModel.configure(modelContext: modelContext)
        }
        .onAppear {
            viewModel.reload()
        }
    }

    private var header: some View {
        HStack {
            PrismaTitle(text: "Prisma", size: 40)

            Spacer()

            Menu {
                Button("New Aesthetic", systemImage: "paintpalette") {
                    router.push(.createAesthetic)
                }
                Button("New Image", systemImage: "photo") {
                    let preselected = viewModel.currentAesthetic?.id
                    router.push(.createImage(preselectedAestheticID: preselected))
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.text)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Create")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private var deck: some View {
        VStack(spacing: 16) {
            polaroidStack
            if viewModel.totalAesthetics > 1 {
                aestheticNavigator
            }
        }
    }

    private var polaroidStack: some View {
        GeometryReader { proxy in
            // Cap width here — a maxWidth inside PolaroidCard is overridden by
            // the explicit `.frame(width:)` below.
            let cardWidth = min(proxy.size.width * 0.9, 600)

            ZStack {
                if let bottom = cardUnderneath {
                    PolaroidCard(aesthetic: bottom, rotation: 0)
                        .frame(width: cardWidth)
                        .scaleEffect(0.96)
                        .opacity(0.92)
                }

                if let top = viewModel.currentAesthetic {
                    PolaroidCard(aesthetic: top, rotation: 0) {
                        guard abs(dragOffset) < 8, !isCommittingSwipe else { return }
                        router.push(.gallery(aestheticID: top.id))
                    }
                    .frame(width: cardWidth)
                    .id(top.id)
                    .offset(x: dragOffset, y: abs(dragOffset) * 0.05)
                    .rotationEffect(.radians(.pi / 40 + Double(dragOffset) / 900))
                    .zIndex(1)
                    .accessibilityHint(
                        viewModel.totalAesthetics > 1
                            ? "Opens this aesthetic. Swipe left or right, or use the arrows, to browse."
                            : top.imageDescription
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .simultaneousGesture(swipeGesture)
        }
        .padding(.horizontal, 16)
        .aspectRatio(1 / 1.5, contentMode: .fit)
        .frame(maxWidth: 600 + 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var cardUnderneath: AestheticModel? {
        guard viewModel.totalAesthetics > 1 else { return nil }
        if dragOffset < -12 {
            return viewModel.previousAesthetic
        }
        return viewModel.nextAesthetic
    }

    private var aestheticNavigator: some View {
        VStack(spacing: 6) {
            HStack(spacing: 16) {
                navigatorButton(
                    systemName: "chevron.left",
                    label: "Previous aesthetic",
                    direction: -1
                )

                VStack(spacing: 2) {
                    Text(viewModel.currentAesthetic?.name ?? "")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.text)
                        .lineLimit(1)

                    Text("\(viewModel.currentIndex + 1) of \(viewModel.totalAesthetics)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.text.opacity(0.65))
                        .monospacedDigit()
                }
                .frame(maxWidth: .infinity)

                navigatorButton(
                    systemName: "chevron.right",
                    label: "Next aesthetic",
                    direction: 1
                )
            }

            Text("Swipe the polaroid left or right")
                .font(.system(size: 13))
                .foregroundStyle(Color.text.opacity(0.55))
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
        .accessibilityElement(children: .contain)
    }

    private func navigatorButton(systemName: String, label: String, direction: CGFloat) -> some View {
        Button {
            commitSwipe(direction: direction)
        } label: {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.text)
                .frame(width: 44, height: 44)
                .background(Color.surface, in: Circle())
                .overlay {
                    Circle().strokeBorder(Color.text.opacity(0.16), lineWidth: 1)
                }
        }
        .accessibilityLabel(label)
        .disabled(isCommittingSwipe)
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 18)
            .onChanged { value in
                guard viewModel.totalAesthetics > 1, !isCommittingSwipe else { return }
                dragOffset = value.translation.width
            }
            .onEnded { value in
                guard viewModel.totalAesthetics > 1, !isCommittingSwipe else { return }
                if value.translation.width > 72 {
                    commitSwipe(direction: 1)
                } else if value.translation.width < -72 {
                    commitSwipe(direction: -1)
                } else {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                        dragOffset = 0
                    }
                }
            }
    }

    private func commitSwipe(direction: CGFloat) {
        guard viewModel.totalAesthetics > 1, !isCommittingSwipe else { return }
        isCommittingSwipe = true
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
            dragOffset = direction * 460
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                if direction > 0 {
                    viewModel.nextIndex()
                } else {
                    viewModel.previousIndex()
                }
                dragOffset = 0
            }
            isCommittingSwipe = false
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(AppRouter())
    .modelContainer(SwiftDataContainer.previewContainer)
}

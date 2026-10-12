import SwiftData
import SwiftUI

struct AppView: View {
    @State private var router = AppRouter()
    private let quickActions = QuickActionRouter.shared

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: Screen.self) { screen in
                    router.build(screen: screen)
                }
        }
        .environment(router)
        .tint(Color.brand)
        .onAppear(perform: consumeQuickAction)
        .onChange(of: quickActions.pendingScreen) { _, _ in
            consumeQuickAction()
        }
    }

    private func consumeQuickAction() {
        guard let screen = quickActions.consume() else { return }
        router.popToRoot()
        router.push(screen)
    }
}

#Preview {
    AppView()
        .modelContainer(SwiftDataContainer.previewContainer)
}

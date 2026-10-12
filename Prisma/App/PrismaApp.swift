import SwiftData
import SwiftUI

@main
struct PrismaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    private let container = SwiftDataContainer.container

    var body: some Scene {
        WindowGroup {
            AppView()
                .modelContainer(container)
        }
    }
}

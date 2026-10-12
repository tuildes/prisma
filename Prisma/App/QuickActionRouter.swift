import SwiftUI

/// Bridges home-screen quick actions into the SwiftUI router.
@Observable
@MainActor
final class QuickActionRouter {
    static let shared = QuickActionRouter()

    var pendingScreen: Screen?

    func consume() -> Screen? {
        defer { pendingScreen = nil }
        return pendingScreen
    }

    func handle(shortcutType: String) {
        switch shortcutType {
        case "AddAesthetic":
            pendingScreen = .createAesthetic
        case "AddImage":
            pendingScreen = .createImage(preselectedAestheticID: nil)
        default:
            break
        }
    }
}

import SwiftUI

@MainActor
protocol Router {
    var path: NavigationPath { get set }

    func push(_ screen: Screen)
    func pop()
    func popToRoot()
    func build(screen: Screen) -> AnyView
}

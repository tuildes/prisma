import SwiftUI

@Observable
@MainActor
final class AppRouter: Router {
    var path = NavigationPath()

    func push(_ screen: Screen) {
        path.append(screen)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func build(screen: Screen) -> AnyView {
        switch screen {
        case .gallery(let aestheticID):
            return AnyView(GalleryView(aestheticID: aestheticID))
        case .createAesthetic:
            return AnyView(CreateAestheticView())
        case .createImage(let preselectedAestheticID):
            return AnyView(CreateImageView(preselectedAestheticID: preselectedAestheticID))
        case .imageDetail(let imageID):
            return AnyView(ImageDetailView(imageID: imageID))
        }
    }
}

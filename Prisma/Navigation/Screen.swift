import Foundation

enum Screen: Hashable {
    case gallery(aestheticID: UUID)
    case createAesthetic
    case createImage(preselectedAestheticID: UUID?)
    case imageDetail(imageID: UUID)
}

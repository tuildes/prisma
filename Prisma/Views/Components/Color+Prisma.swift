import SwiftUI

extension Color {
    static let brand = Color("brand")
    static let highlight = Color("highlight")
    /// Explicit `Color.tint` — clashes with SwiftUI `ShapeStyle.tint`.
    static let tint = Color("tint")
    /// Explicit `Color.background` — clashes with SwiftUI `ShapeStyle.background`.
    static let background = Color("background")
    static let surface = Color("surface")
    static let text = Color("text")
}

import Foundation

struct AestheticModel: Identifiable {
    var id: UUID
    var name: String
    var image: String

    var totalReferences: Int {
        return 0
    }

    init(name: String, image: String) {
        self.id = UUID()
        self.name = name
        self.image = image
    }
}

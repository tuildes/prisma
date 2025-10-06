import Foundation

struct AestheticModel: Identifiable {
    var id: UUID
    var name: String
    var image: String
    var allReferences: [ImageModel]

    var totalReferences: Int {
        return allReferences.count
    }

    init(name: String, image: String, allReferences: [ImageModel] = []) {
        self.id = UUID()
        self.name = name
        self.image = image
        self.allReferences = allReferences
    }
}

extension AestheticModel {
    static let placeholder = AestheticModel(
        name: "Placeholder", image: "nostalgia",
        allReferences: [ImageModel.placeholder, ImageModel.placeholder, ImageModel.placeholder])

    static let sampleData: [AestheticModel] = [
        AestheticModel(
            name: "Prisma",
            image: "logo_quadrada",
            allReferences: []
        ),
        AestheticModel(
            name: "Nostalgia",
            image: "nostalgia",
            allReferences: [
                ImageModel(title: "Window", author: "???", imageURL: "seila"),
                ImageModel(title: "Ghosts", author: "???", imageURL: "yung"),
                ImageModel(title: "Cinematic 01", author: "Monad", imageURL: "cinema_01"),
                ImageModel(title: "Cinematic 02", author: "Monad", imageURL: "cinema_02"),
            ]
        ),
        AestheticModel(
            name: "Low Poly",
            image: "low_poly",
            allReferences: [
                ImageModel(
                    title: "Save/load", author: "Monad", imageURL: "save_load",
                    sourceURL: "https://x.com/monad_of_eirye/status/1743041919951700087"),
                ImageModel(title: "Músicas de amor nunca mais", author: "BK", imageURL: "bk"),
                ImageModel(title: "Ghosts", author: "???", imageURL: "yung"),
            ]
        ),
        // AestheticModel(
        //     name: "Learning",
        //     image: "figma",
        //     allReferences: [
        //         ImageModel(title: "Figma 01", author: "me", imageURL: "app_01"),
        //         ImageModel(title: "Figma 02", author: "me", imageURL: "app_02"),
        //         ImageModel(title: "Figma 03", author: "me", imageURL: "app_03"),
        //     ]
        // ),
        AestheticModel(
            name: "Cinematic",
            image: "seila",
            allReferences: [
                ImageModel(title: "Cinematic 01", author: "Monad", imageURL: "cinema_01"),
                ImageModel(title: "Cinematic 02", author: "Monad", imageURL: "cinema_02"),
            ]
        ),
    ]
}

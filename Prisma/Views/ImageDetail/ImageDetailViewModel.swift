import Foundation
import SwiftData
import UIKit

@Observable
@MainActor
final class ImageDetailViewModel {
    let imageID: UUID

    private(set) var imageModel: ImageModel?
    var isHUDHidden = false
    var showFullscreen = false
    var didDelete = false

    private var modelContext: ModelContext?

    init(imageID: UUID) {
        self.imageID = imageID
    }

    var hasSourceURL: Bool {
        guard let url = imageModel?.sourceURL?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return false
        }
        return !url.isEmpty
    }

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
        reload()
    }

    func reload() {
        guard let modelContext else { return }

        do {
            var descriptor = FetchDescriptor<ImageModel>(
                predicate: #Predicate { $0.id == imageID }
            )
            descriptor.fetchLimit = 1
            imageModel = try modelContext.fetch(descriptor).first
        } catch {
            print("Failed to load image detail: \(error)")
        }
    }

    func openURL() {
        guard let urlString = imageModel?.sourceURL,
            let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url)
        else {
            return
        }
        UIApplication.shared.open(url)
    }

    func deleteImage() {
        guard let modelContext, let imageModel else { return }

        if let aesthetic = imageModel.aesthetic {
            var references = aesthetic.allReferences ?? []
            references.removeAll { $0.id == imageModel.id }
            aesthetic.allReferences = references
        }
        modelContext.delete(imageModel)

        do {
            try modelContext.save()
            didDelete = true
        } catch {
            print("Failed to delete image: \(error)")
        }
    }

    func toggleHUD() {
        isHUDHidden.toggle()
    }
}

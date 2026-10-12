import Foundation
import SwiftData

@Observable
@MainActor
final class GalleryViewModel {
    let aestheticID: UUID

    private(set) var aesthetic: AestheticModel?
    private(set) var references: [ImageModel] = []

    private var modelContext: ModelContext?

    init(aestheticID: UUID) {
        self.aestheticID = aestheticID
    }

    var isEmpty: Bool { references.isEmpty }

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
        reload()
    }

    func reload() {
        guard let modelContext else { return }

        do {
            var descriptor = FetchDescriptor<AestheticModel>(
                predicate: #Predicate { $0.id == aestheticID }
            )
            descriptor.fetchLimit = 1
            aesthetic = try modelContext.fetch(descriptor).first
            references = aesthetic?.allReferences ?? []
        } catch {
            print("Failed to load gallery: \(error)")
        }
    }

    func deleteAesthetic() {
        guard let modelContext, let aesthetic else { return }
        modelContext.delete(aesthetic)

        do {
            try modelContext.save()
        } catch {
            print("Failed to delete aesthetic: \(error)")
        }
    }
}

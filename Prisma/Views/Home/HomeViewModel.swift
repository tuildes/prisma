import Foundation
import SwiftData

@Observable
@MainActor
final class HomeViewModel {
    private(set) var aesthetics: [AestheticModel] = []
    var currentIndex: Int = 0

    var isEmptyState: Bool { aesthetics.isEmpty }
    var totalAesthetics: Int { aesthetics.count }

    var canNavigateToGallery: Bool {
        totalAesthetics > 0 && currentAesthetic != nil
    }

    var currentAesthetic: AestheticModel? {
        guard totalAesthetics > 0 else { return nil }
        let index = min(max(currentIndex, 0), totalAesthetics - 1)
        return aesthetics[index]
    }

    var nextAesthetic: AestheticModel? {
        guard totalAesthetics > 1 else { return nil }
        let index = (currentIndex + 1) % totalAesthetics
        return aesthetics[index]
    }

    var previousAesthetic: AestheticModel? {
        guard totalAesthetics > 1 else { return nil }
        let index = currentIndex == 0 ? totalAesthetics - 1 : currentIndex - 1
        return aesthetics[index]
    }

    private var modelContext: ModelContext?

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
        reload()
    }

    func reload() {
        guard let modelContext else { return }

        do {
            let descriptor = FetchDescriptor<AestheticModel>(
                sortBy: [SortDescriptor(\.name)]
            )
            aesthetics = try modelContext.fetch(descriptor)
            if currentIndex >= aesthetics.count {
                currentIndex = max(0, aesthetics.count - 1)
            }
        } catch {
            print("Error fetching aesthetics: \(error)")
        }
    }

    func nextIndex() {
        guard totalAesthetics > 0 else { return }
        currentIndex = (currentIndex + 1) % totalAesthetics
    }

    func previousIndex() {
        guard totalAesthetics > 0 else { return }
        currentIndex = currentIndex == 0 ? totalAesthetics - 1 : currentIndex - 1
    }
}

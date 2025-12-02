import Foundation
import Combine

protocol HomeViewModelProtocol {
    var aesthetics: [AestheticModel] { get }
    var currentIndex: Int { get }
    var totalAesthetics: Int { get }

    var isEmptyState: Bool { get }
    var canNavigateToGallery: Bool { get }

    func nextIndex()
    func previousIndex()
    func getCurrentAesthetic() -> AestheticModel?
    func getNextAesthetic() -> AestheticModel?
}

final class HomeViewModel: HomeViewModelProtocol {
    @Published
    var aesthetics: [AestheticModel] = []

    @Published
    var currentIndex: Int = 0

    public var isEmptyState: Bool {
        return aesthetics.isEmpty
    }

    public var totalAesthetics: Int {
        return aesthetics.count
    }

    public var canNavigateToGallery: Bool {
        return totalAesthetics > 0 && getCurrentAesthetic() != nil
    }

    // MARK: - Private Properties

    // MARK: - Initializers
    init() {
        loadAesthetics()
    }

    // MARK: - Functions
    private func loadAesthetics() {
        self.aesthetics = AestheticModel.sampleData
    }

    public func nextIndex() {
        guard totalAesthetics > 0 else { return }

        self.currentIndex = (currentIndex + 1) % totalAesthetics
    }

    public func previousIndex() {
        guard totalAesthetics > 0 else { return }

        if currentIndex == 0 {
            self.currentIndex = totalAesthetics - 1
            return
        }

        self.currentIndex = (currentIndex - 1)
    }

    public func getCurrentAesthetic() -> AestheticModel? {
        guard totalAesthetics > 0 else { return nil }
        return aesthetics[currentIndex]
    }

    public func getNextAesthetic() -> AestheticModel? {
        guard totalAesthetics > 1 else { return nil }
        let nextIndex = (currentIndex + 1) % totalAesthetics
        return aesthetics[nextIndex]
    }
}

import Combine
import UIKit

class ImageDetailViewModel: ObservableObject {
    @Published
    private(set) var imageModel: ImageModel?

    init() {
        self.imageModel = nil
    }

    public func configure(with model: ImageModel) {
        self.imageModel = model
    }

    public func openURL() {
        guard let urlString = imageModel?.sourceURL,
            !urlString.isEmpty,
            let url = URL(string: urlString)
        else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

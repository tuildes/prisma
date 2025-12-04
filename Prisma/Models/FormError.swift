import Foundation

enum FormError: LocalizedError {
    case emptyField(fieldName: String)
    case invalidImage

    var errorDescription: String? {
        switch self {
            case .emptyField(let fieldName):
                return "\(fieldName) cannot be empty."
            case .invalidImage:
                return "The selected image is invalid."
        }
    }
}

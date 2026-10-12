import Foundation

enum FormError: LocalizedError {
    case emptyField(fieldName: String)
    case maxLengthExceeded(fieldName: String, maxLength: Int)
    case invalidImage

    var errorDescription: String? {
        switch self {
        case .emptyField(let fieldName):
            return "\(fieldName) is required."
        case .maxLengthExceeded(let fieldName, let maxLength):
            return "\(fieldName) cannot exceed \(maxLength) characters."
        case .invalidImage:
            return "The selected image is invalid."
        }
    }
}

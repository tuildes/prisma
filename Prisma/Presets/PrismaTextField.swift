import UIKit

final class PrismaTextField: UITextField {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupTextField()
    }

    // MARK: - Setup
    private func setupTextField() {
        borderStyle = .roundedRect
        backgroundColor = .prismaBackground
        textColor = .prismaText
        font = UIFont.systemFont(ofSize: 16)
        layer.borderColor = UIColor.prismaText.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 8.0
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}

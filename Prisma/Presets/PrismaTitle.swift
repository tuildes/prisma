import UIKit

class PrismaTitleLabel: UILabel {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }

    // MARK: - Setup
    private func setupLabel() {
        guard let _ = UIFont(name: "Staatliches", size: 24) else {
            fatalError("Failed to load the 'Staatliches' font.")
        }

        self.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont(name: "Staatliches", size: 24)!
        )
        self.adjustsFontForContentSizeCategory = true
        self.textColor = .prismaText
    }

    public func setSize(size: CGFloat, style: UIFont.TextStyle = .body) {
        guard let _ = UIFont(name: "Staatliches", size: size) else {
            return
        }

        self.font = UIFontMetrics(forTextStyle: style).scaledFont(
            for: UIFont(name: "Staatliches", size: size)!
        )
    }

    public func setText(_ text: String) {
        self.text = text
        self.accessibilityLabel = text
        self.accessibilityIdentifier = text.replacingOccurrences(of: " ", with: "_").lowercased()
    }
}

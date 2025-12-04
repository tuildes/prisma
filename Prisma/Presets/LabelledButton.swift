import UIKit

class LabelledButton: UIButton {

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    // MARK: - Configuration
    public func configure(imageName: String, title: String) {
        let config = createLabelledConfiguration(imageName: imageName, title: title)
        self.configuration = config
    }

    public func isEnabledToggle(_ enabled: Bool) {
        self.isEnabled = enabled
        self.alpha = self.isEnabled ? 1.0 : 0
    }

    private func setupButton() {
        self.setTitleColor(.prismaPrimary, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Functions
    private func createLabelledConfiguration(imageName: String, title: String)
        -> UIButton.Configuration
    {
        var config = UIButton.Configuration.plain()

        config.image = UIImage(
            systemName: imageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        )
        config.imagePlacement = .top
        config.imagePadding = 8
        config.baseForegroundColor = .white

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 12, weight: .semibold)

        config.attributedTitle = AttributedString(title, attributes: titleContainer)

        return config
    }

    // MARK: - Methods
    public func setLabel(text: String, icon: String) {
        self.setTitle(text, for: .normal)
        self.accessibilityLabel = text
        self.accessibilityIdentifier = text.replacingOccurrences(of: " ", with: "_").lowercased()
    }

    public func setTheme(whiteMode: Bool) {
        if whiteMode {
            self.configuration?.baseBackgroundColor = .white
            self.configuration?.baseForegroundColor = .black
        } else {
            self.configuration?.baseBackgroundColor = .black
            self.configuration?.baseForegroundColor = .white
        }
    }
}

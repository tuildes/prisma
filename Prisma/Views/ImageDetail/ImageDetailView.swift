import UIKit

class ImageDetailView: UIView {

    // MARK: - Properties
    var isHiddenHUD: Bool = false {
        didSet {
            let newAlpha: CGFloat = isHiddenHUD ? 0.2 : 1.0
            UIView.animate(withDuration: 0.3) {
                self.titleLabel.alpha = newAlpha
                self.authorLabel.alpha = newAlpha
                self.buttonsStackView.alpha = newAlpha
                self.hideHUDButton.alpha = newAlpha
            }
        }
    }

    // MARK: - Subviews
    private(set) lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true

        return imageView
    }()

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Staatliches", size: 64)
        label.textColor = .prismaBackground
        label.numberOfLines = 0

        return label
    }()

    private(set) lazy var authorLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Staatliches", size: 24)
        label.textColor = .prismaBackground
        label.layer.opacity = 0.7

        return label
    }()

    private(set) lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0

        return stackView
    }()

    private(set) lazy var openButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.plain()

        config.image = UIImage(
            systemName: "arrow.up.right.square",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .black)
        )
        config.imagePlacement = .top
        config.imagePadding = 8

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 12)
        config.attributedTitle = AttributedString("Open", attributes: titleContainer)

        config.baseForegroundColor = .prismaBackground
        button.configuration = config

        return button
    }()

    private(set) lazy var hideHUDButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.plain()

        config.image = UIImage(
            systemName: "eye.slash",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .black)
        )
        config.imagePlacement = .top
        config.imagePadding = 8

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 12)
        config.attributedTitle = AttributedString("Hide HUD", attributes: titleContainer)

        config.baseForegroundColor = .prismaBackground
        button.configuration = config

        button.addTarget(
            self,
            action: #selector(hideHUD),
            for: .touchUpInside
        )

        return button
    }()

    private(set) var openImageViewButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.plain()

        config.image = UIImage(
            systemName: "photo",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .black)
        )
        config.imagePlacement = .top
        config.imagePadding = 8

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 12)
        config.attributedTitle = AttributedString("View", attributes: titleContainer)

        config.baseForegroundColor = .prismaBackground
        button.configuration = config

        return button
    }()

    // MARK: - Properties
    var imageModel: ImageModel = ImageModel.placeholder
    private let paddingBackground: CGFloat = 2

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .prismaBackground

        backgroundImageView.image = UIImage(named: imageModel.imageURL)
        titleLabel.text = imageModel.title
        authorLabel.text = "By: \(imageModel.author)"

        setupSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubViews() {
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(authorLabel)

        addSubview(buttonsStackView)
        // buttonsStackView.addArrangedSubview(openButton)
        // buttonsStackView.addArrangedSubview(openImageViewButton)
        buttonsStackView.addArrangedSubview(hideHUDButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor),
            titleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),

            authorLabel.bottomAnchor.constraint(
                equalTo: buttonsStackView.topAnchor,
                constant: -24
            ),
            authorLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),

            buttonsStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    // MARK: - Actions
    @objc
    private func openLink() {
        // Handle open link action
    }

    @objc
    private func openImageView() {
        // Handle open image view action
    }

    @objc
    private func hideHUD() {
        isHiddenHUD = !isHiddenHUD
    }
}

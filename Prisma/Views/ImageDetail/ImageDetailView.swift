import UIKit

class ImageDetailView: UIView {

    // MARK: - Properties
    var onOpenImageViewTapped: ((UIImage?) -> Void)?
    var isHiddenHUD: Bool = false {
        didSet {
            let newAlpha: CGFloat = isHiddenHUD ? 0.1 : 1.0
            UIView.animate(withDuration: 0.3) {
                self.titleLabel.alpha = newAlpha
                self.authorLabel.alpha = newAlpha
                self.buttonsStackView.alpha = newAlpha
                // O botão 'hideHUDButton' não deve desaparecer junto
                // self.hideHUDButton.alpha = newAlpha
            }
        }
    }

    // MARK: - Subviews
    private(set) lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Staatliches", size: 64)
        label.textColor = .prismaBackground
        label.numberOfLines = 0
        label.textAlignment = .right

        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 4.0
        label.layer.shadowOpacity = 0.8
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false

        return label
    }()

    private(set) lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Staatliches", size: 24)
        label.textColor = .prismaBackground
        label.alpha = 0.8

        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 0.9
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false

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

    private func createButton(imageName: String, title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        var config = UIButton.Configuration.plain()

        config.image = UIImage(
            systemName: imageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
        config.imagePlacement = .top
        config.imagePadding = 8
        config.baseForegroundColor = .white

        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.8)
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        shadow.shadowBlurRadius = 3

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleContainer.shadow = shadow

        config.attributedTitle = AttributedString(title, attributes: titleContainer)

        button.configuration = config
        return button
    }

    private(set) lazy var openButton: UIButton = {
        let button = createButton(imageName: "arrow.up.right.square", title: "Open")
        button.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        return button
    }()

    private(set) lazy var hideHUDButton: UIButton = {
        let button = createButton(imageName: "eye.slash", title: "Hide HUD")
        button.addTarget(self, action: #selector(hideHUD), for: .touchUpInside)
        return button
    }()

    private(set) lazy var openImageViewButton: UIButton = {
        let button = createButton(imageName: "photo", title: "View")
        button.addTarget(self, action: #selector(openImageView), for: .touchUpInside)
        return button
    }()

    var imageModel: ImageModel?
    private let paddingBackground: CGFloat = 2

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .prismaBackground
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
        buttonsStackView.addArrangedSubview(openButton)
        buttonsStackView.addArrangedSubview(openImageViewButton)
        buttonsStackView.addArrangedSubview(hideHUDButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),

            authorLabel.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            buttonsStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    func configure(with model: ImageModel) {
        self.imageModel = model

        self.backgroundImageView.image = UIImage(named: model.imageURL)
        self.titleLabel.text = model.title
        self.authorLabel.text = "By \(model.author)"

        // Se não houver URL, desabilita o botão de abrir link
        if model.sourceURL == nil || model.sourceURL?.isEmpty == true {
            openButton.isEnabled = false
            openButton.alpha = 0.5
        } else {
            openButton.isEnabled = true
            openButton.alpha = 1.0
        }
    }

    // MARK: - Actions
    @objc private func openLink() {
        guard let urlString = imageModel?.sourceURL, !urlString.isEmpty,
            let url = URL(string: urlString)
        else { return }
        if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url) }
    }

    @objc private func openImageView() {
        onOpenImageViewTapped?(backgroundImageView.image)
    }

    @objc private func hideHUD() {
        isHiddenHUD = !isHiddenHUD
    }
}

import UIKit

class ImageDetailView: UIView {

    // MARK: - Properties
    var onOpenImageViewTapped: ((UIImage?) -> Void)?
    var onURLButtonTapped: (() -> Void)?
    var whiteMode: Bool = false

    var isHiddenHUD: Bool = false {
        didSet {
            let newAlpha: CGFloat = isHiddenHUD ? 0.2 : 1.0
            UIView.animate(withDuration: 0.3) {
                self.titleLabel.alpha = newAlpha
                self.authorLabel.alpha = newAlpha
                self.buttonsStackView.alpha = newAlpha
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

    private(set) lazy var titleLabel: PrismaTitleLabel = {
        let label = PrismaTitleLabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.setSize(size: 64, style: .title1)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.setStroke()

        return label
    }()

    private(set) lazy var authorLabel: PrismaTitleLabel = {
        let label = PrismaTitleLabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.setStroke()
        label.numberOfLines = 1
        label.textAlignment = .right
        label.setSize(size: 24, style: .body)

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

    private(set) lazy var openButton: LabelledButton = {
        let button = LabelledButton()
        button.configure(imageName: "arrow.up.right.square", title: "Open")
        button.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        button.setTheme(whiteMode: whiteMode)
        return button
    }()

    private(set) lazy var hideHUDButton: LabelledButton = {
        let button = LabelledButton()
        button.configure(imageName: "eye.slash", title: "Hide HUD")
        button.addTarget(self, action: #selector(hideHUD), for: .touchUpInside)
        button.setTheme(whiteMode: whiteMode)
        return button
    }()

    private(set) lazy var openImageViewButton: LabelledButton = {
        let button = LabelledButton()
        button.configure(imageName: "photo", title: "View")
        button.addTarget(self, action: #selector(openImageView), for: .touchUpInside)
        button.setTheme(whiteMode: whiteMode)
        return button
    }()

    var imageModel: ImageModel = .placeholder
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
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    func configure(with model: ImageModel) {
        self.imageModel = model

        self.backgroundImageView.image = UIImage(data: model.image)
        self.titleLabel.setText(model.title)
        self.authorLabel.setText("By \(model.author)")

        self.whiteMode = model.isLightMode
        openButton.setTheme(whiteMode: whiteMode)
        hideHUDButton.setTheme(whiteMode: whiteMode)
        openImageViewButton.setTheme(whiteMode: whiteMode)
        titleLabel.setTheme(whiteMode: whiteMode)
        authorLabel.setTheme(whiteMode: whiteMode)

        // Se não houver URL, desabilita o botão de abrir link
        if model.sourceURL == nil || model.sourceURL?.isEmpty == true {
            openButton.isEnabledToggle(false)
        }
    }

    // MARK: - Actions
    @objc
    private func openLink() {
        onURLButtonTapped?()
    }

    @objc
    private func openImageView() {
        onOpenImageViewTapped?(backgroundImageView.image)
    }

    @objc
    private func hideHUD() {
        isHiddenHUD = !isHiddenHUD
    }
}

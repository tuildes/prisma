import UIKit

class ImageCardView: UIControl {
    // MARK: - Properties
    private var imageModel: ImageModel = ImageModel.placeholder

    // MARK: - Overrides properties
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                animateOnTouchDown()
            }
        }
    }

    // MARK: - Subviews
    private(set) var referenceImage: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12

        return imageView
    }()

    private(set) var contentStack: UIStackView = {
        let stackView = UIStackView()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = -8
        stackView.alignment = .leading
        stackView.distribution = .fillEqually

        return stackView
    }()

    private(set) lazy var titleName: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white

        return label
    }()

    private(set) lazy var authorLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.alpha = 0.5

        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black
        layer.cornerRadius = 12

        setupSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ImageModel) {
        self.imageModel = model

        self.referenceImage.image = UIImage(named: model.imageURL)
        self.titleName.text = model.title
        self.authorLabel.text = "By \(model.author)"
    }

    func setupSubViews() {
        addSubview(referenceImage)
        addSubview(contentStack)

        contentStack.addArrangedSubview(titleName)
        contentStack.addArrangedSubview(authorLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: heightAnchor),
            self.widthAnchor.constraint(equalTo: widthAnchor),
            self.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.centerYAnchor.constraint(equalTo: centerYAnchor),

            referenceImage.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            referenceImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            referenceImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            referenceImage.bottomAnchor.constraint(equalTo: contentStack.topAnchor, constant: -12),

            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            contentStack.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    // MARK - Functions
    func animateOnTouchDown() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }
}

import UIKit

class ImageCardCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "ImageCardCell"
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
    private(set) var backgroundImage: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "paper_texture")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8

        return imageView
    }()

    private(set) var referenceImage: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4

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
        label.textColor = .prismaText

        return label
    }()

    private(set) lazy var authorLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .prismaText
        label.alpha = 0.5

        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 2
        layer.masksToBounds = false

        setupSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with model: ImageModel) {
        self.imageModel = model

        self.referenceImage.image = UIImage(named: model.imageURL)
        self.titleName.text = model.title
        self.authorLabel.text = "By \(model.author)"
    }

    private func setupSubViews() {
        addSubview(referenceImage)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: widthAnchor),
            self.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.centerYAnchor.constraint(equalTo: centerYAnchor),

            referenceImage.topAnchor.constraint(equalTo: topAnchor),
            referenceImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            referenceImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            referenceImage.bottomAnchor.constraint(equalTo: bottomAnchor),
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

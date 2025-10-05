import UIKit

class ImageDetailView: UIView {

    // MARK: - Subviews
    private(set) var backgroundImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true

        return imageView
    }()

    private(set) var titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .white
        label.numberOfLines = 0

        return label
    }()

    private(set) var authorLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0

        return label
    }()

    // MARK: - Properties
    var imageModel: ImageModel = ImageModel.placeholder
    private let paddingBackground: CGFloat = 2

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

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
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: paddingBackground
            ),
            backgroundImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: paddingBackground
            ),
            backgroundImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -paddingBackground
            ),
            backgroundImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -paddingBackground
            ),

            titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            authorLabel.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            authorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}

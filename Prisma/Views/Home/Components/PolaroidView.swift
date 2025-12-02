import UIKit

class PolaroidView: UIControl {
    // MARK: - Properties
    private var padding: CGFloat = 12
    private var aestheticModel: AestheticModel = .placeholder

    // MARK: - Subviews
    private(set) var backgroundImage: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "paper_texture")
        imageView.clipsToBounds = true

        return imageView
    }()

    private(set) var contentStack: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.spacing = -12
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false

        return stackView
    }()

    private(set) var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4

        return imageView
    }()

    private(set) lazy var titleName: PrismaTitleLabel = {
        let label = PrismaTitleLabel()

        label.setSize(size: 36, style: .largeTitle)
        label.setText("Aesthetic Name")

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private(set) lazy var totalReferencesLabel: PrismaTitleLabel = {
        let label = PrismaTitleLabel()

        label.setSize(size: 16, style: .title1)
        label.setText("0 references")

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 8

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

    func configure(with model: AestheticModel) {
        self.aestheticModel = model
        imageView.image = UIImage(named: model.image)
        titleName.setText(model.name)
        totalReferencesLabel.setText("\(model.totalReferences) references")
    }

    func setupSubViews() {
        addSubview(backgroundImage)
        addSubview(contentStack)
        addSubview(imageView)

        contentStack.addArrangedSubview(titleName)
        contentStack.addArrangedSubview(totalReferencesLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1),

            contentStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            contentStack.leadingAnchor.constraint(
                greaterThanOrEqualTo: leadingAnchor,
                constant: padding
            ),
        ])
    }
}

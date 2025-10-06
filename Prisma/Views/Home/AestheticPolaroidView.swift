import UIKit

class AestheticPolaroidView: UIControl {
    // MARK: - Properties
    private var padding: CGFloat = 12
    private var aestheticModel: AestheticModel = .placeholder

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

    private(set) lazy var titleName: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Staatliches", size: 48)
        label.textColor = .prismaText

        return label
    }()

    private(set) lazy var totalReferencesLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Staatliches", size: 20)
        label.textColor = .prismaText

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
        titleName.text = model.name
        imageView.image = UIImage(named: model.image)
        totalReferencesLabel.text = "\(model.totalReferences) references"
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
            self.heightAnchor.constraint(equalTo: heightAnchor),
            self.widthAnchor.constraint(equalTo: widthAnchor),
            self.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.centerYAnchor.constraint(equalTo: centerYAnchor),

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
        ])
    }

    // MARK - Functions
    func animateOnTouchDown() {
        // TODO: Add animation
    }
}

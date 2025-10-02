import UIKit

class AestheticCardView: UIControl {
    // MARK: - Properties
    private var aestheticModel: AestheticModel = AestheticModel(
        name: "", image: "", description: "", allReferences: []
    )

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
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12

        return imageView
    }()

    private(set) var contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false

        return stackView
    }()

    private(set) lazy var titleName: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .white

        return label
    }()

    private(set) lazy var totalReferencesLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.alpha = 0.75

        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: AestheticModel) {
        self.aestheticModel = model
        titleName.text = model.name
        backgroundImage.image = UIImage(named: model.image)
        totalReferencesLabel.text = "\(model.totalReferences) referências"
    }

    func setupSubViews() {
        addSubview(backgroundImage)
        addSubview(contentStack)
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

            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),
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

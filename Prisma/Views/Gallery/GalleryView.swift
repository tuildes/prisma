import UIKit

class GalleryView: UIView {

    // MARK: - Properties
    var onImageCardTapped: (() -> Void) = {}
    var aesthetic: AestheticModel? {
        didSet {
            setupUI()
        }
    }

    // MARK: - Subviews
    private(set) lazy var bannerBackground: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private(set) lazy var stackOverlay: UIStackView = {
        let stack = UIStackView()

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = -16

        return stack
    }()

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Staatliches", size: 64)
        label.textColor = .white
        label.textAlignment = .center

        label.layer.masksToBounds = false
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.2
        label.layer.shadowOffset = CGSize(width: 0, height: 0)

        return label
    }()

    private(set) lazy var totalReferences: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Staatliches", size: 24)
        label.textColor = .white
        label.textAlignment = .center

        label.layer.masksToBounds = false
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.2
        label.layer.shadowOffset = CGSize(width: 0, height: 0)

        return label
    }()

    private(set) lazy var imageCard: ImageCardView = {
        let card = ImageCardView()

        card.translatesAutoresizingMaskIntoConstraints = false
        card.configure(with: aesthetic?.allReferences.first ?? .placeholder)
        card.addTarget(self, action: #selector(imageCardTapped), for: .touchUpInside)

        return card
    }()

    // TODO: TAGS/CHIPS

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

    func setupUI() {
        guard let aesthetic else { return }

        titleLabel.text = aesthetic.name
        bannerBackground.image = UIImage(named: aesthetic.image)
        totalReferences.text = "\(aesthetic.allReferences.count) references"
        imageCard.configure(with: aesthetic.allReferences.first ?? .placeholder)
    }

    func setupSubViews() {
        addSubview(imageCard)
        addSubview(bannerBackground)
        addSubview(stackOverlay)

        stackOverlay.addArrangedSubview(titleLabel)
        stackOverlay.addArrangedSubview(totalReferences)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            bannerBackground.topAnchor.constraint(equalTo: topAnchor),
            bannerBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerBackground.heightAnchor.constraint(equalToConstant: 240),

            stackOverlay.centerXAnchor.constraint(equalTo: bannerBackground.centerXAnchor),
            stackOverlay.centerYAnchor.constraint(equalTo: bannerBackground.centerYAnchor),

            imageCard.topAnchor.constraint(equalTo: bannerBackground.bottomAnchor, constant: 16),
            imageCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            imageCard.heightAnchor.constraint(equalToConstant: 360),
        ])
    }

    // MARK: - Actions
    @objc
    func imageCardTapped() {
        onImageCardTapped()
    }
}

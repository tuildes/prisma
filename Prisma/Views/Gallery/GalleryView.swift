import UIKit

class GalleryView: UIView {

    // MARK: - Properties
    var onImageCardTapped: (() -> Void) = {}
    let aesthetic = AestheticModel(
        name: "Nostalgia", image: "bk",
        allReferences: [.placeholder, .placeholder, .placeholder]
    )

    // MARK: - Subviews
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center

        return label
    }()

    private(set) lazy var totalReferences: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center

        return label
    }()

    private(set) lazy var imageCard: ImageCardView = {
        let card = ImageCardView()

        card.translatesAutoresizingMaskIntoConstraints = false
        card.configure(with: aesthetic.allReferences.first ?? .placeholder)
        card.addTarget(self, action: #selector(imageCardTapped), for: .touchUpInside)

        return card
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        titleLabel.text = aesthetic.name
        totalReferences.text = "\(aesthetic.allReferences.count) referências"

        setupSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubViews() {
        addSubview(titleLabel)
        addSubview(totalReferences)
        addSubview(imageCard)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            totalReferences.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            totalReferences.centerXAnchor.constraint(equalTo: centerXAnchor),

            imageCard.topAnchor.constraint(equalTo: totalReferences.bottomAnchor, constant: 24),
            imageCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            imageCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            imageCard.heightAnchor.constraint(equalToConstant: 300),
        ])
    }

    // MARK: - Actions
    @objc
    func imageCardTapped() {
        onImageCardTapped()
    }
}

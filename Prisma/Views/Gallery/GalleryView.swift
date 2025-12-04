import UIKit

class GalleryView: UIView {

    // MARK: - Properties
    private lazy var waveMaskLayer = CAShapeLayer()
    var aesthetic: AestheticModel? {
        didSet {
            setupUI()
        }
    }

    // MARK: - Subviews
    private(set) lazy var emptyStateLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "blank")
        return imageView
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let spacing: CGFloat = 4
        let itemWidth = (UIScreen.main.bounds.width / 2) - (spacing * 3)
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear

        return collectionView
    }()

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

    override func layoutSubviews() {
        super.layoutSubviews()
        applyWaveMask()
    }

    func setupUI() {
        guard let aesthetic else { return }

        titleLabel.text = aesthetic.name
        bannerBackground.image = UIImage(data: aesthetic.coverImage)
        totalReferences.text = "\(aesthetic.totalReferences) references"
    }

    func setupSubViews() {
        addSubview(bannerBackground)
        addSubview(stackOverlay)
        addSubview(collectionView)
        addSubview(emptyStateLabel)

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

            collectionView.topAnchor.constraint(
                equalTo: bannerBackground.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            emptyStateLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(
                equalTo: collectionView.leadingAnchor, constant: 16),
            emptyStateLabel.trailingAnchor.constraint(
                equalTo: collectionView.trailingAnchor, constant: -16),
            emptyStateLabel.heightAnchor.constraint(equalToConstant: 360),
            emptyStateLabel.widthAnchor.constraint(equalToConstant: 360),
        ])
    }

    // MARK: - Action
    func showEmptyState(message: String) {
        emptyStateLabel.isHidden = false
        collectionView.isHidden = true
    }

    func hideEmptyState() {
        emptyStateLabel.isHidden = true
        collectionView.isHidden = false
    }

    private func applyWaveMask() {
        bannerBackground.layer.mask = waveMaskLayer

        let path = UIBezierPath()
        let width = bannerBackground.bounds.width
        let height = bannerBackground.bounds.height
        let waveHeight: CGFloat = 14

        path.move(to: .zero)
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height - waveHeight))

        path.addQuadCurve(
            to: CGPoint(x: width / 2, y: height - waveHeight),
            controlPoint: CGPoint(x: width * 0.75, y: height)
        )

        path.addQuadCurve(
            to: CGPoint(x: 0, y: height),
            controlPoint: CGPoint(x: width * 0.25, y: height - (waveHeight * 2))  // Ponto de controle para cima
        )

        path.close()

        waveMaskLayer.path = path.cgPath
    }

}

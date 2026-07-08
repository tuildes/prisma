import UIKit

class FullScreenImageView: UIView {

    // MARK: - Properties
    var onDismissFullScreen: (() -> Void)?

    // MARK: - Subviews
    private(set) lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true

        return view
    }()

    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = false

        return imageView
    }()


    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        setupSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubViews() {
        addSubview(blurEffectView)
        addSubview(imageView)
    }

    func configure(with image: UIImage?, imageDescription: String?) {
        imageView.image = image
        imageView.accessibilityLabel = imageDescription
        addGestureRecognizers()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    // MARK: - Actions
    private func addGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreen))
        blurEffectView.addGestureRecognizer(tapGesture)
    }

    @objc
    private func dismissFullScreen() {
        onDismissFullScreen?()
    }
}

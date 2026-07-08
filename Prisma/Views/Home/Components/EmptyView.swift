import UIKit

class EmptyView: UIView {

    // MARK: - Subviews
    private(set) lazy var titleLabel: PrismaTitleLabel = {
        let label = PrismaTitleLabel()

        label.setSize(size: 32, style: .largeTitle)
        label.setText("No Aesthetics Yet")
        label.accessibilityHint = "Title indicating there are no aesthetics"

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private(set) lazy var descriptionLabel: PrismaTitleLabel = {
        let label = PrismaTitleLabel()

        label.setSize(size: 16, style: .body)
        label.setText("Tap the + button to create your first aesthetic.")
        label.accessibilityHint = "Description guiding the user to create an aesthetic"

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private(set) lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        imageView.accessibilityLabel = "App Logo"
        imageView.accessibilityHint = "Prisma App Logo"

        return imageView
    }()

    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
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

    private func setupSubViews() {
        addSubview(stackView)

        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}

import UIKit

class StartView: UIView {

    // MARK: - Properties
    var onStartButtonTapped: (() -> Void) = {}

    // MARK: - Subviews
    private(set) lazy var logoImage: UIImageView = {
        let logo = UIImageView()

        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit
        logo.image = UIImage(named: "logo")

        return logo
    }()

    private(set) lazy var button: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle("INICIAR", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        button.layer.opacity = 0.4

        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

        return button
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

    func setupSubViews() {
        addSubview(logoImage)
        addSubview(button)

    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 200),
            logoImage.heightAnchor.constraint(equalToConstant: 200),

            button.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 240),
            button.heightAnchor.constraint(equalToConstant: 36),
        ])
    }

    // MARK: - Actions
    @objc
    private func startButtonTapped() {
        onStartButtonTapped()
    }
}

import UIKit

class HeaderView: UIView {
    // MARK: - Properties
    private let padding: CGFloat = 16
    var onCreationButtonAction: (() -> Void) = {}

    // MARK: - Subviews
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Prisma"
        label.font = UIFont(name: "Staatliches", size: 32)
        label.textColor = .prismaText

        return label
    }()

    private(set) lazy var creationButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(
            UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(weight: .black)
            ), for: .normal
        )
        button.tintColor = .prismaBackground
        button.backgroundColor = .prismaText
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(creationButtonTapped), for: .touchUpInside)
        button.layer.opacity = 0.2

        return button
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

    func setupSubViews() {
        addSubview(titleLabel)
        addSubview(creationButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            creationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            creationButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            creationButton.widthAnchor.constraint(equalToConstant: 32),
            creationButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }

    // MARK: - Functions
    @objc
    private func creationButtonTapped() {
        onCreationButtonAction()
        print("TODO: Creation Button Tapped")
    }
}

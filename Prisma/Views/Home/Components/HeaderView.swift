import UIKit

class HeaderView: UIView {
    // MARK: - Properties
    private let padding: CGFloat = 16

    var isImageCreationEnabled: Bool = false
    var onCreateAesthetic: (() -> Void)?
    var onCreateImage: (() -> Void)?

    // MARK: - Subviews
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()

        if let font = UIFont(name: "Staatliches", size: 32) {
            label.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: font)
        } else {
            label.font = .systemFont(ofSize: 32, weight: .bold)
        }

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Prisma"
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .prismaText
        label.accessibilityLabel = "App Title"
        label.accessibilityIdentifier = "header_title_label"
        label.accessibilityHint = "Title of the Prisma application"

        return label
    }()

    private(set) lazy var creationButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(
            UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(weight: .black)
            ),
            for: .normal
        )
        button.tintColor = .prismaText
        button.backgroundColor = .clear
        button.layer.cornerRadius = 4
        button.layer.opacity = 1
        button.showsMenuAsPrimaryAction = true

        button.accessibilityHint = "Create a new aesthetic or image"
        button.accessibilityLabel = "Create Button"

        return button
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubViews()
        setupConstraints()
        setupMenu()
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
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),

            creationButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -padding
            ),
            creationButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            creationButton.widthAnchor.constraint(equalToConstant: 32),
            creationButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }

    // MARK: - Menu Configuration
    private func setupMenu() {
        let aestheticAction = UIAction(
            title: "Nova Estética",
            image: UIImage(systemName: "sparkles")
        ) { [weak self] _ in
            self?.onCreateAesthetic?()
        }

        let imageAction = UIAction(
            title: "Nova Imagem",
            image: UIImage(systemName: "photo")
        ) { [weak self] _ in
            self?.onCreateImage?()
        }

        let menu = UIMenu(
            title: "O que você deseja criar?",
            options: .displayInline,
            children: [aestheticAction, imageAction]
        )

        creationButton.menu = menu
    }
}

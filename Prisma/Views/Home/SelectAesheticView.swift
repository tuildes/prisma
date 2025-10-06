import UIKit

class SelectAestheticView: UIView {
    // MARK: - Properties
    var onNextButtonAction: (() -> Void) = {}
    var onPreviousButtonAction: (() -> Void) = {}
    var onSelectButtonAction: (() -> Void) = {}

    // MARK: - Subviews
    private(set) lazy var previousButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(
            UIImage(
                systemName: "chevron.left",
                withConfiguration: UIImage.SymbolConfiguration(weight: .black)
            ), for: .normal
        )
        button.tintColor = .prismaText
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)

        return button
    }()

    private(set) lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(
            UIImage(
                systemName: "chevron.right",
                withConfiguration: UIImage.SymbolConfiguration(weight: .black)
            ), for: .normal
        )
        button.tintColor = .prismaText
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        return button
    }()

    private(set) lazy var selectButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Visualize", for: .normal)
        button.titleLabel?.font = UIFont(name: "Staatliches", size: 32)
        button.setTitleColor(.prismaText, for: .normal)
        button.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)

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
        addSubview(previousButton)
        addSubview(nextButton)
        addSubview(selectButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            previousButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            previousButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            previousButton.widthAnchor.constraint(equalToConstant: 44),
            previousButton.heightAnchor.constraint(equalToConstant: 44),

            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            nextButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 44),
            nextButton.heightAnchor.constraint(equalToConstant: 44),

            selectButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectButton.widthAnchor.constraint(equalToConstant: 120),
            selectButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    // MARK: - Functions
    @objc
    func previousButtonTapped() {
        onPreviousButtonAction()
    }

    @objc
    func nextButtonTapped() {
        onNextButtonAction()
    }

    @objc
    func selectButtonTapped() {
        onSelectButtonAction()
    }
}

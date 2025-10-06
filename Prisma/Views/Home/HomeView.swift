import UIKit

class HomeView: UIView {

    // MARK: - Properties
    var onAestheticButtonTapped: (() -> Void) = {}

    // MARK: - Subviews
    private(set) lazy var headerView: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var stackView: UIStackView = {
        let stack = UIStackView()

        stack.axis = .vertical
        stack.spacing = 60
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    private(set) lazy var firstPolaroidView: AestheticPolaroidView = {
        let view = AestheticPolaroidView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.configure(with: .placeholder)
        view.addTarget(self, action: #selector(aestheticButtonTapped), for: .touchUpInside)

        view.transform = CGAffineTransform(rotationAngle: .pi / 40)

        return view
    }()

    private(set) lazy var secondPolaroidView: AestheticPolaroidView = {
        let view = AestheticPolaroidView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.configure(with: .placeholder)
        view.addTarget(self, action: #selector(aestheticButtonTapped), for: .touchUpInside)

        return view
    }()

    private(set) lazy var selectSection: SelectAestheticView = {
        let view = SelectAestheticView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.onNextButtonAction = { [weak self] in
            self?.onNextTapped()
        }
        view.onPreviousButtonAction = { [weak self] in
            self?.onPreviousTapped()
        }
        view.onSelectButtonAction = { [weak self] in
            self?.onSelectTapped()
        }

        view.previousButton.layer.opacity = 0.5

        return view
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
        addSubview(headerView)
        addSubview(stackView)

        stackView.addArrangedSubview(secondPolaroidView)
        secondPolaroidView.addSubview(firstPolaroidView)
        stackView.addArrangedSubview(selectSection)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            firstPolaroidView.widthAnchor.constraint(
                equalTo: stackView.widthAnchor, multiplier: 0.9),
            firstPolaroidView.heightAnchor.constraint(
                equalTo: firstPolaroidView.widthAnchor, multiplier: 1.4),
            firstPolaroidView.centerXAnchor.constraint(equalTo: centerXAnchor),

            secondPolaroidView.widthAnchor.constraint(
                equalTo: stackView.widthAnchor, multiplier: 0.9),
            secondPolaroidView.heightAnchor.constraint(
                equalTo: secondPolaroidView.widthAnchor, multiplier: 1.4),
            secondPolaroidView.centerXAnchor.constraint(equalTo: centerXAnchor),

        ])
    }

    // MARK: - Actions
    @objc
    func aestheticButtonTapped() {
        onAestheticButtonTapped()
    }

    func onNextTapped() {
        print("Next button tapped")
    }

    func onPreviousTapped() {
        print("Previous button tapped")
    }

    func onSelectTapped() {
        print("Select button tapped")
    }
}

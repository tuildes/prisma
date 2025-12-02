import UIKit

class HomeView: UIView {

    // MARK: - Actions
    var tappedAestheticAction: () -> Void = {}
    var nextAestheticAction: () -> Void = {}
    var previousAestheticAction: () -> Void = {}


    // MARK: - Private Properties
    private var polaroidViews: [PolaroidView] = []
    private let topCardTransform = CGAffineTransform(rotationAngle: .pi / 40)
    private let bottomCardTransform = CGAffineTransform.identity


    // MARK: - Subviews
    private(set) lazy var headerView: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var polaroidContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var firstPolaroidView: PolaroidView = {
        let view = PolaroidView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.configure(with: .placeholder)
        view.addTarget(self, action: #selector(aestheticButtonTapped), for: .touchUpInside)
        view.transform = topCardTransform

        return view
    }()

    private(set) lazy var secondPolaroidView: PolaroidView = {
        let view = PolaroidView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.configure(with: .placeholder)
        view.addTarget(self, action: #selector(aestheticButtonTapped), for: .touchUpInside)
        view.transform = bottomCardTransform

        return view
    }()

    private(set) lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .prismaBackground

        setupSubViews()
        setupConstraints()
        setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupEmptyState(isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        polaroidContainerView.isHidden = isEmpty
    }

    func setupSubViews() {
        addSubview(headerView)
        addSubview(polaroidContainerView)
        addSubview(emptyView)

        polaroidContainerView.addSubview(secondPolaroidView)
        polaroidContainerView.addSubview(firstPolaroidView)

        polaroidViews = [firstPolaroidView, secondPolaroidView]
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),

            polaroidContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            polaroidContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            polaroidContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),

            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emptyView.centerYAnchor.constraint(equalTo: centerYAnchor),

            polaroidContainerView.heightAnchor.constraint(
                equalTo: polaroidContainerView.widthAnchor, multiplier: 1.5),

        ])

        [firstPolaroidView, secondPolaroidView].forEach { card in
            NSLayoutConstraint.activate([
                card.widthAnchor.constraint(
                    equalTo: polaroidContainerView.widthAnchor, multiplier: 0.9),
                card.heightAnchor.constraint(equalTo: card.widthAnchor, multiplier: 1.4),
                card.centerXAnchor.constraint(equalTo: polaroidContainerView.centerXAnchor),
                card.centerYAnchor.constraint(equalTo: polaroidContainerView.centerYAnchor),
            ])
        }
    }


    // MARK: - Gestures
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        polaroidContainerView.addGestureRecognizer(swipeRight)
    }

    @objc
    private func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        guard polaroidViews.count > 1 else { return }

        if sender.direction == .right {
            handleNext()
        }
    }

    private func handleNext() {
        guard let topCard = polaroidViews.first else { return }
        let nextCard = polaroidViews[1]

        UIView.animate(
            withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1,
            options: .curveEaseInOut,
            animations: {
                let translation = CGAffineTransform(translationX: self.bounds.width + 10, y: 40)
                let rotation = CGAffineTransform(rotationAngle: .pi / 16)
                topCard.transform = translation.concatenating(rotation)
                nextCard.transform = self.topCardTransform
            },
            completion: { _ in
                self.polaroidContainerView.sendSubviewToBack(topCard)
                topCard.alpha = 0
                topCard.transform = self.bottomCardTransform
                let swipedCard = self.polaroidViews.removeFirst()
                self.polaroidViews.append(swipedCard)
                self.nextAestheticAction()
                UIView.animate(withDuration: 0.2) {
                    topCard.alpha = 1
                }
            })
    }

    // MARK: - Actions
    @objc
    func aestheticButtonTapped() {
        tappedAestheticAction()
    }

    public func configureCards(topAesthetic: AestheticModel, bottomAesthetic: AestheticModel) {
        guard polaroidViews.count >= 2 else { return }

        polaroidViews[0].configure(with: topAesthetic)
        polaroidViews[1].configure(with: bottomAesthetic)
    }
}

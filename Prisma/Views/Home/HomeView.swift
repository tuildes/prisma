import UIKit

class HomeView: UIView {

    // MARK: - Subviews
    private(set) lazy var label: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Todas as Aesthetics e TAGs"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black

        return label
    }()

    private(set) lazy var aestheticCardView: AestheticCardView = {
        let view = AestheticCardView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.configure(with: AestheticModel(name: "Nostalgia", image: "bk"))

        return view
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        setupSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubViews() {
        addSubview(label)
        addSubview(aestheticCardView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),

            aestheticCardView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            aestheticCardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            aestheticCardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            aestheticCardView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}

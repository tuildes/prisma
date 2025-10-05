import UIKit

class HeaderView: UIView {
    // MARK: - Properties

    // MARK: - Overrides properties

    // MARK: - Subviews

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
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([])
    }

    // MARK - Functions
}

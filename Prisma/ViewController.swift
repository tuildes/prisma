import UIKit

class ViewController: UIViewController {

    private let uiView: ViewControllerView = ViewControllerView()

    override func loadView() {
        super.loadView()
        self.view = uiView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

class ViewControllerView: UIView {
    private(set) lazy var text: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Hello, World!"
        text.textColor = .black
        return text
    }()

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
        addSubview(text)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            text.centerXAnchor.constraint(equalTo: centerXAnchor),
            text.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

}

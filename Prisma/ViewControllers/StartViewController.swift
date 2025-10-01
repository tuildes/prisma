import UIKit

class StartViewController: UIViewController {

    // MARK: - Properties
    private let startView: StartView = StartView()

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.view = startView

        startView.onStartButtonTapped = { [weak self] in
            self?.navigateToHomeScreen()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    func navigateToHomeScreen() {
        let homeViewController = HomeViewController()
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
}

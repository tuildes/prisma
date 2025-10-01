import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    private let homeView: HomeView = HomeView()

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

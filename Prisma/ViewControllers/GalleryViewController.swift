import UIKit

class GalleryViewController: UIViewController {

    // MARK: - Properties
    private let galleryView: GalleryView = GalleryView()
    var aesthetic: AestheticModel = .placeholder

    // ✨ 1. Propriedades para gerenciar o estado do filtro
    private var allReferences: [ImageModel] = []
    private var filteredReferences: [ImageModel] = []
    private var currentFilter: ImageType? = nil  // nil significa "Todos"

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.view = galleryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        allReferences = aesthetic.allReferences
        filteredReferences = allReferences

        galleryView.aesthetic = aesthetic
        prepareCollectionView()
        prepareFilters()

        // Verifica o estado inicial
        updateEmptyState()
    }

    func prepareCollectionView() {
        galleryView.collectionView.register(
            ImageCardCell.self, forCellWithReuseIdentifier: ImageCardCell.identifier)
        galleryView.collectionView.dataSource = self
        galleryView.collectionView.delegate = self
    }

    // ✨ 3. Conecta a ação de toque no chip com a lógica de filtro
    func prepareFilters() {
        galleryView.onFilterTapped = { [weak self] filterType in
            self?.applyFilter(type: filterType)
        }
    }

    // ✨ 4. A função principal que aplica o filtro
    private func applyFilter(type: ImageType?) {
        currentFilter = type

        if let filter = currentFilter {
            // Filtra a lista original
            filteredReferences = allReferences.filter { $0.type == filter }
        } else {
            // Se o filtro for nil (botão "Todos"), mostra tudo
            filteredReferences = allReferences
        }

        // Atualiza a collection view e o estado de vazio
        galleryView.collectionView.reloadData()
        updateEmptyState()
    }

    // ✨ 5. Mostra ou esconde a mensagem de estado vazio
    private func updateEmptyState() {
        if filteredReferences.isEmpty {
            let message = "Nenhum item encontrado para este filtro."
            galleryView.showEmptyState(message: message)
        } else {
            galleryView.hideEmptyState()
        }
    }

    // MARK: - Actions
    func navigateToImageDetail(with imageModel: ImageModel) {  // Removido opcional
        let imageDetailVC = ImageDetailViewController()
        imageDetailVC.imageModel = imageModel
        navigationController?.pushViewController(imageDetailVC, animated: true)
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
        -> Int
    {
        // ✨ Usa a lista filtrada
        return filteredReferences.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCardCell.identifier, for: indexPath) as! ImageCardCell
        // ✨ Usa a lista filtrada
        let dataItem = filteredReferences[indexPath.row]
        cell.configure(with: dataItem)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // ✨ Usa a lista filtrada
        let selectedItem = filteredReferences[indexPath.row]
        navigateToImageDetail(with: selectedItem)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

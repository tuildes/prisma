import UIKit
import Combine

class CreateAestheticView: UIView {

    // MARK: - Properties
    private var viewModel: CreateAestheticViewModel?
    private var cancellables = Set<AnyCancellable>()

    // Actions
    public var onSelectImageTapped: (() -> Void)?
    public var onCloseCreation: (() -> Void)?

    // MARK: - Subviews
    private(set) lazy var titleLabel: PrismaTitleLabel = {
        let label = PrismaTitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setSize(size: 32, style: .title2)
        label.text = "Create New Aesthetic"
        label.textAlignment = .center
        return label
    }()

    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 12  // Aumentei um pouco o espaçamento para respirar
        return stackView
    }()

    // --- Inputs Section ---

    private(set) lazy var sectionTitleLabel: PrismaTitleLabel = {
        let label = PrismaTitleLabel()
        label.setSize(size: 16, style: .title3)
        label.text = "Aesthetic Name"
        return label
    }()

    private(set) lazy var aestheticNameTextField: PrismaTextField = {
        let textField = PrismaTextField()
        textField.placeholder = "Aesthetic Name"
        textField.autocapitalizationType = .words

        return textField
    }()

    private(set) lazy var sectionImageLabel: PrismaTitleLabel = {
        let label = PrismaTitleLabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.setSize(size: 16, style: .title3)
        label.text = "Cover Image"
        label.textAlignment = .left

        return label
    }()

    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .prismaSecondary
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(systemName: "photo")

        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImageTapped))
        imageView.addGestureRecognizer(tap)

        return imageView
    }()

    private(set) lazy var selectImageButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select Image", for: .normal)
        button.setTitleColor(.prismaPrimary, for: .normal)
        button.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)

        button.backgroundColor = .clear

        return button
    }()

    private(set) lazy var sectionDescriptionLabel: PrismaTitleLabel = {
        let label = PrismaTitleLabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.setSize(size: 16, style: .title3)
        label.text = "Description of image"
        label.textAlignment = .left

        return label
    }()

    private(set) lazy var imageDescriptionTextField: PrismaTextField = {
        let textField = PrismaTextField()

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Image Description"
        textField.autocapitalizationType = .sentences

        return textField
    }()

    private(set) lazy var createButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Aesthetic", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .prismaPrimary
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)

        return button
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

    func configure(with viewModel: CreateAestheticViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }

    func bindViewModel() {
        guard let viewModel = viewModel else { return }

        NotificationCenter.default
            .publisher(
                for: UITextField.textDidChangeNotification, object: imageDescriptionTextField
            )
            .compactMap({ ($0.object as? UITextField)?.text })
            .sink { [weak self] description in
                self?.viewModel?.imageDescription = description
            }
            .store(in: &cancellables)

        viewModel.$image
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                self?.imageView.image = image
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(
                for: UITextField.textDidChangeNotification, object: aestheticNameTextField
            )
            .compactMap({ ($0.object as? UITextField)?.text })
            .sink { [weak self] name in
                self?.viewModel?.aestheticName = name
            }
            .store(in: &cancellables)
    }

    func setupSubViews() {
        addSubview(titleLabel)
        addSubview(stackView)
        addSubview(createButton)

        stackView.addArrangedSubview(sectionTitleLabel)
        stackView.addArrangedSubview(aestheticNameTextField)

        stackView.addArrangedSubview(sectionImageLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(selectImageButton)

        stackView.addArrangedSubview(sectionDescriptionLabel)
        stackView.addArrangedSubview(imageDescriptionTextField)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            selectImageButton.heightAnchor.constraint(equalToConstant: 44),

            createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            createButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            ),
            createButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    // MARK: - Actions
    @objc
    private func selectImageTapped() {
        onSelectImageTapped?()
    }

    @objc
    private func createButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.createAesthetic()
    }

    private func closeCreation() {
        onCloseCreation?()
    }
}

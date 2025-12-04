import UIKit
import Combine

class CreateImageView: UIView {

    // MARK: - Properties
    private var viewModel: CreateImageViewModel?
    private var cancellables = Set<AnyCancellable>()

    // Actions
    public var onSelectImageTapped: (() -> Void)?
    public var onCloseCreation: (() -> Void)?

    // MARK: - UI Components (ScrollView Container)

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Subviews

    private(set) lazy var titleLabel: PrismaTitleLabel = {
        let label = PrismaTitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setSize(size: 32, style: .title2)
        label.text = "Create New Image"
        label.textAlignment = .center
        return label
    }()

    // StackView Principal
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        return stackView
    }()

    // --- Image Section ---
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .prismaSecondary
        imageView.layer.cornerRadius = 8
        imageView.tintColor = .systemGray3
        imageView.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImageTapped))
        imageView.addGestureRecognizer(tap)

        return imageView
    }()

    private(set) lazy var selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Cover Image", for: .normal)
        button.setTitleColor(.prismaPrimary, for: .normal)
        button.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        return button
    }()

    // --- Aesthetic Selector (Relationship) ---
    private(set) lazy var aestheticLabel: PrismaTitleLabel = {
        let label = PrismaTitleLabel()
        label.setSize(size: 14, style: .caption1)
        label.text = "AESTHETIC"
        label.textColor = .secondaryLabel
        return label
    }()

    private(set) lazy var aestheticSelectorButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Select an Aesthetic...", for: .normal)

        let arrow = UIImageView(image: UIImage(systemName: "chevron.up.chevron.down"))
        arrow.tintColor = .systemGray3
        arrow.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(arrow)

        NSLayoutConstraint.activate([
            arrow.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -12),
            arrow.heightAnchor.constraint(equalToConstant: 14),
            arrow.widthAnchor.constraint(equalToConstant: 10),
        ])

        button.showsMenuAsPrimaryAction = true  // iOS 14+ behavior
        return button
    }()

    // --- Info Fields ---
    private(set) lazy var titleTextField: PrismaTextField = {
        let tf = PrismaTextField()
        tf.placeholder = "Image Title"
        tf.autocapitalizationType = .words
        tf.delegate = self
        return tf
    }()

    private(set) lazy var authorTextField: PrismaTextField = {
        let tf = PrismaTextField()
        tf.placeholder = "Author Name"
        tf.autocapitalizationType = .words
        tf.delegate = self
        return tf
    }()

    private(set) lazy var descriptionTextField: PrismaTextField = {
        let tf = PrismaTextField()
        tf.placeholder = "Image Description"
        tf.autocapitalizationType = .sentences
        tf.delegate = self
        return tf
    }()

    private(set) lazy var sourceTextField: PrismaTextField = {
        let tf = PrismaTextField()
        tf.placeholder = "Source URL (Optional)"
        tf.keyboardType = .URL
        tf.autocapitalizationType = .none
        tf.delegate = self
        return tf
    }()

    // --- Light Mode Switch ---
    private(set) lazy var lightModeStack: UIStackView = {
        let label = PrismaTitleLabel()
        label.setSize(size: 16, style: .body)
        label.text = "Is Light Mode?"

        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)

        let stack = UIStackView(arrangedSubviews: [label, toggle])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    // --- Button ---
    private(set) lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Image", for: .normal)
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
        setupKeyboardDismiss()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration & Binding
    func configure(with viewModel: CreateImageViewModel) {
        self.viewModel = viewModel
        viewModel.fetchAesthetics()
        bindViewModel()
    }

    func bindViewModel() {
        guard let viewModel = viewModel else { return }

        bindTextField(titleTextField, to: \.title)
        bindTextField(authorTextField, to: \.author)
        bindTextField(descriptionTextField, to: \.imageDescription)
        bindTextField(sourceTextField, to: \.sourceURL)

        viewModel.$aesthetics
            .receive(on: RunLoop.main)
            .sink { [weak self] aesthetics in
                self?.updateAestheticMenu(with: aesthetics)
            }
            .store(in: &cancellables)

        viewModel.$selectedAestheticID
            .combineLatest(viewModel.$aesthetics)
            .receive(on: RunLoop.main)
            .sink { [weak self] (id, list) in
                if let match = list.first(where: { $0.id == id }) {
                    self?.aestheticSelectorButton.setTitle(match.name, for: .normal)
                } else {
                    if list.isEmpty {
                        self?.aestheticSelectorButton.setTitle(
                            "No Aesthetics Available", for: .normal)
                    } else {
                        self?.aestheticSelectorButton.setTitle(
                            "Select an Aesthetic...", for: .normal)
                    }
                }
            }
            .store(in: &cancellables)

        viewModel.$image
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                self?.imageView.image = image ?? UIImage()
                self?.imageView.layer.borderWidth = image != nil ? 0 : 1
            }
            .store(in: &cancellables)
    }

    // Helper para bindar textFields (evita repetição de código)
    private func bindTextField<T>(
        _ textField: UITextField, to keyPath: ReferenceWritableKeyPath<CreateImageViewModel, T>
    ) {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textField)
            .compactMap { ($0.object as? UITextField)?.text as? T }
            .assign(to: keyPath, on: viewModel!)
            .store(in: &cancellables)
    }

    private func updateAestheticMenu(with aesthetics: [AestheticModel]) {
        let actions = aesthetics.map { aesthetic in
            UIAction(title: aesthetic.name) { [weak self] _ in
                self?.viewModel?.selectedAestheticID = aesthetic.id
            }
        }

        let menu = UIMenu(title: "Select Aesthetic", children: actions)
        aestheticSelectorButton.menu = menu
    }

    // MARK: - Setup UI
    func setupSubViews() {
        addSubview(titleLabel)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        addSubview(createButton)

        let views = [
            imageView,
            selectImageButton,

            sectionLabel(text: "Title"),
            titleTextField,

            sectionLabel(text: "Author"),
            authorTextField,

            aestheticLabel,
            aestheticSelectorButton,

            sectionLabel(text: "Image Description"),
            descriptionTextField,

            sectionLabel(text: "Source URL"),
            sourceTextField,

            lightModeStack,
        ]

        views.forEach { stackView.addArrangedSubview($0) }

        stackView.setCustomSpacing(24, after: selectImageButton)
        stackView.setCustomSpacing(24, after: aestheticSelectorButton)
    }

    private func sectionLabel(text: String) -> UILabel {
        let l = PrismaTitleLabel()
        l.setSize(size: 14, style: .caption1)
        l.text = text.uppercased()
        l.textColor = .secondaryLabel
        return l
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            // Create Button (Fixo no rodapé)
            createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            createButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            createButton.heightAnchor.constraint(equalToConstant: 50),

            // ScrollView (Ocupa o espaço entre titulo e botão)
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -20),

            // Content View (Dentro do Scroll)
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),  // Impede scroll horizontal

            // StackView
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            // Tamanhos fixos específicos
            imageView.heightAnchor.constraint(equalToConstant: 200),
            selectImageButton.heightAnchor.constraint(equalToConstant: 30),
            aestheticSelectorButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    // MARK: - Actions & UX
    @objc
    private func toggleChanged(_ sender: UISwitch) {
        viewModel?.isLightMode = sender.isOn
    }

    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }

    @objc
    private func dismissKeyboard() {
        endEditing(true)
    }

    @objc
    private func selectImageTapped() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        onSelectImageTapped?()
    }

    @objc
    private func createButtonTapped() {
        guard let viewModel = viewModel else { return }
        guard viewModel.checkValidForm() else { return }

        viewModel.createImage()

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        closeCreation()
    }

    private func closeCreation() {
        onCloseCreation?()
    }
}

// MARK: - UITextFieldDelegate
extension CreateImageView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Lógica simples de navegação (Tab index)
        switch textField {
            case titleTextField: authorTextField.becomeFirstResponder()
            case authorTextField: descriptionTextField.becomeFirstResponder()
            case descriptionTextField: sourceTextField.becomeFirstResponder()
            case sourceTextField: textField.resignFirstResponder()
            default: textField.resignFirstResponder()
        }
        return true
    }
}

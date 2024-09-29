//
//  NavigationBarDelegate.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 23.09.2024.
//


import Common
import UIKit

public protocol NavigationBarDelegate: AnyObject {
    func didReceiveBackAction(_ navigationBar: NavigationBar)
    func didReceiveCloseAction(_ navigationBar: NavigationBar)
}

public extension NavigationBarDelegate {
    func didReceiveBackAction(_ navigationBar: NavigationBar) { }
    func didReceiveCloseAction(_ navigationBar: NavigationBar) { }
}

open class NavigationBar: BaseNavigationBar {
    // MARK: - Public Properties

    public var isHiddenRightButton: Bool {
        get {
            rightButton.isHidden
        }
        set {
            rightButton.isHidden = newValue
        }
    }

    public var isEnabledRightButton: Bool {
        get {
            rightButton.isEnabled
        }
        set {
            rightButton.isEnabled = newValue
        }
    }

    public var isEnabledBackButton: Bool {
        get {
            backButton.isEnabled
        }
        set {
            backButton.isEnabled = newValue
        }
    }

    public var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
            setNeedsLayout()
        }
    }

    public weak var delegate: NavigationBarDelegate?

    public var prefersCloseButton: Bool = false {
        didSet {
            setupCloseButton()
        }
    }

    public var prefersBackCloseButton: Bool = false {
        didSet {
            setupBackCloseButton()
        }
    }

    public var isBackButtonHidden: Bool = false {
        didSet {
            backButton.isHidden = isBackButtonHidden
        }
    }

    // MARK: - Private Properties

    private var backButtonHeight: NSLayoutConstraint!
    private var backButtonWidth: NSLayoutConstraint!
    private var rightButtonHeight: NSLayoutConstraint!
    private var rightButtonWidth: NSLayoutConstraint!

    private lazy var backButton: UIButton = {
        let resources = AppResources.images
        let colors = AppResources.colors
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        return button
    }()

    private let rightButton: UIButton = {
        let colors = AppResources.colors
        let button = UIButton(type: .system)
        button.tintColor = colors.elements
        button.isHidden = true
        button.titleLabel?.font = AppResources.fonts.styles.mainText
        button.setTitleColor(colors.elements, for: .normal)
        button.setTitleColor(colors.gray, for: .disabled)
        return button
    }()

    private let titleLabel: UILabel = {
        let colors = Design.AppResources.colors
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.font = AppResources.fonts.styles.titleH2
        label.textColor = colors.elements
        label.backgroundColor = .clear
        label.text = ""
        return label
    }()

    // MARK: - Lifecycle

    override public init() {
        super.init()
        addSubviews()
        setupConstraints()
        configure()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) { nil }

    // MARK: - Internal Methods

    override func updateContentConstraints(newValue: CGFloat) {
        super.updateContentConstraints(newValue: newValue)
        backButtonHeight.constant = newValue
        backButtonWidth.constant = newValue
        rightButtonHeight.constant = newValue
        rightButtonWidth.constant = newValue
    }

    // MARK: - Public Methods

    /// Добавляет кнопку справа от заголовка, если свойство `prefersCloseButton` не установлено
    public func addRightButton(iconImage: UIImage, actionHandler: @escaping () -> Void) {
        guard prefersCloseButton == false else { return }

        setRightButton(image: iconImage)
        rightButton.isHidden = false
        rightButton.addActionHandler(actionHandler)
    }

    /// Добавляет кнопку справа от заголовка, если свойство `prefersCloseButton` не установлено
    public func addRightButton(title: String, actionHandler: @escaping () -> Void) {
        guard prefersCloseButton == false else { return }

        rightButton.setTitle(title, for: [])
        rightButton.isHidden = false
        rightButton.addActionHandler(actionHandler)
        setNeedsLayout()
    }

    public func setRightButton(image: UIImage?) {
        rightButton.setImage(image, for: [])
    }
}

// MARK: - Private Methods

private extension NavigationBar {
    func addSubviews() {
        contentView.addSubviews(backButton, rightButton, titleLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.useAndActivateConstraints([
            backButton.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightButton.leadingAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            rightButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            rightButton.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
        ])

        backButtonHeight = backButton.heightAnchor.constraint(equalToConstant: contentSize)
        backButtonWidth = backButton.widthAnchor.constraint(equalToConstant: contentSize)

        rightButtonHeight = rightButton.heightAnchor.constraint(equalToConstant: contentSize)
        rightButtonWidth = rightButton.widthAnchor.constraint(greaterThanOrEqualToConstant: contentSize)

        NSLayoutConstraint.useAndActivateConstraints([
            backButtonHeight,
            backButtonWidth,
            rightButtonHeight,
            rightButtonWidth
        ])
    }

    func configure() {
        setupBackButton()
    }

    func setupBackButton() {
        backButton.setImage(
            AppResources.images.backArrow.get().withRenderingMode(.alwaysTemplate),
            for: []
        )
        backButton.tintColor = AppResources.colors.elements
    }

    func setupCloseButton() {
        guard prefersCloseButton else {
            backButton.isHidden = false
            rightButton.isHidden = true
            return
        }

        let closeIconImage = AppResources.images.close.get().withRenderingMode(.alwaysTemplate)
        backButton.isHidden = true
        rightButton.isHidden = false
        rightButton.addActionHandler { [weak self] in
            self?.handleCloseTap()
        }
        setRightButton(image: closeIconImage)
    }

    func setupBackCloseButton() {
        guard prefersBackCloseButton else {
            setupBackButton()
            return
        }

        let closeIconImage = AppResources.images.close.get().withRenderingMode(.alwaysTemplate)
        backButton.isHidden = false
        backButton.setImage(closeIconImage, for: [])
    }

    @objc
    func handleBackTap() {
        delegate?.didReceiveBackAction(self)
    }

    func handleCloseTap() {
        delegate?.didReceiveCloseAction(self)
    }
}

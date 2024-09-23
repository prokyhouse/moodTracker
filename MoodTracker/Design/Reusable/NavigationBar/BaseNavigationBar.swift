//
//  BaseNavigationBar.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 23.09.2024.
//


import Common
import UIKit

open class BaseNavigationBar: UIView {
    // MARK: - Public Properties

    public var contentSize: CGFloat = Constants.contentSize {
        didSet {
            updateContentConstraints(newValue: contentSize)
        }
    }

    public var innerMargins = Constants.innerMargins {
        didSet {
            layoutMargins = innerMargins
        }
    }

    public var contentMargins = Constants.contentMargins {
        didSet {
            contentView.layoutMargins = contentMargins
        }
    }

    public var isContentHidden: Bool {
        get {
            contentView.alpha == 0.01
        }
        set {
            contentView.alpha = newValue ? 0.01 : 1.0
        }
    }

    // MARK: - Internal Properties

    internal let contentView = UIView()
    internal let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 20.0
        return stackView
    }()

    // MARK: - Private Properties

    private var contentViewHeight: NSLayoutConstraint?
    private let blurView = BlurView()

    // MARK: - Lifecycle

    public init() {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        configure()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) { nil }

    // MARK: - Internal Methods

    func updateContentConstraints(newValue: CGFloat) {
        contentViewHeight?.constant = newValue
    }
}

// MARK: - Private Methods

private extension BaseNavigationBar {
    func addSubviews() {
        addSubview(blurView)
        addSubview(stackView)
        stackView.addArrangedSubview(contentView)
    }

    func setupConstraints() {
        layoutMargins = innerMargins
        contentView.layoutMargins = contentMargins
        NSLayoutConstraint.useAndActivateConstraints([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        let contentViewHeight = contentView.heightAnchor.constraint(equalToConstant: contentSize)
        self.contentViewHeight = contentViewHeight

        NSLayoutConstraint.useAndActivateConstraints([
            contentViewHeight
        ])
    }

    func configure() {
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 32.0
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }
}

// MARK: - Constants

extension BaseNavigationBar {
    enum Constants {
        static let contentSize: CGFloat = 36.0
        static let innerMargins = UIEdgeInsets(top: 12.0, left: .zero, bottom: 20.0, right: .zero)
        static let contentMargins = UIEdgeInsets(top: .zero, left: 10.0, bottom: .zero, right: 10.0)
    }
}

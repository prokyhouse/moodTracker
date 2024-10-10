//
//  Section.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 10.10.2024.
//


import Common
import UIKit

open class Section<ContentType: UIView>: UIView {
    // MARK: - Nested

    public struct SectionInset {
        public var contentInset: UIEdgeInsets
        public var innerInset: UIEdgeInsets
        public var contentSpacing: CGFloat

        public init(contentInset: UIEdgeInsets, innerInset: UIEdgeInsets, contentSpacing: CGFloat) {
            self.contentInset = contentInset
            self.innerInset = innerInset
            self.contentSpacing = contentSpacing
        }

        public static var standart: SectionInset {
            .init(
                contentInset: Constants.contentMargins,
                innerInset: Constants.innerMargins,
                contentSpacing: 20.0
            )
        }

        public static var shrink: SectionInset {
            .init(
                contentInset: .zero,
                innerInset: .init(horizontal: 16.0, vertical: 24.0),
                contentSpacing: 8.0
            )
        }
    }

    // MARK: - Public Properties

    public let contentView: ContentType

    public var maskedCorners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner] {
        didSet {
            layer.maskedCorners = maskedCorners
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

    public var accessoryButton: UIButton? {
        didSet {
            if let oldValue {
                dismissAccessoryButton(oldValue)
            }
            if let accessoryButton {
                displayAccessoryButton(accessoryButton)
            }
            setNeedsLayout()
        }
    }

    public var contentInsets: UIEdgeInsets {
        get {
            contentContainerView.layoutMargins
        }
        set {
            contentContainerView.layoutMargins = newValue
            setNeedsLayout()
        }
    }

    // MARK: - Private Properties

    private let titleLabel: UILabel = {
        let colors = AppResources.colors
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.font = AppResources.fonts.styles.title
        label.textColor = colors.elements
        label.backgroundColor = colors.background
        return label
    }()

    /// Хранит в себе `titleLabel` и `accessoryButton`
    private let horizontalTopLineStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .equalCentering
        stackView.spacing = .zero
        return stackView
    }()

    private let contentContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()

    private let insets: SectionInset

    // MARK: - Lifecycle

    public init(contentView: ContentType = .init(), insets: SectionInset = .standart) {
        self.insets = insets
        self.contentView = contentView
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        setupViews()
    }

    @available(*, unavailable)
    override public init(frame: CGRect) {
        fatalError("Метод не определён")
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) { nil }
}

// MARK: - Private Methods

private extension Section {
    func addSubviews() {
        contentContainerView.addSubview(contentView)
        addSubviews(horizontalTopLineStackView, contentContainerView)
        horizontalTopLineStackView.addArrangedSubviews(titleLabel)
    }

    func setupConstraints() {
        layoutMargins = insets.innerInset
        contentContainerView.layoutMargins = insets.contentInset
        NSLayoutConstraint.useAndActivateConstraints([
            horizontalTopLineStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            horizontalTopLineStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            horizontalTopLineStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            contentContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainerView.topAnchor.constraint(equalTo: horizontalTopLineStackView.bottomAnchor, constant: insets.contentSpacing),
            contentContainerView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            contentView.leadingAnchor.constraint(equalTo: contentContainerView.layoutMarginsGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentContainerView.layoutMarginsGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: contentContainerView.layoutMarginsGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentContainerView.layoutMarginsGuide.bottomAnchor, constant: -8.0)
        ])
    }

    func setupViews() {
        backgroundColor = AppResources.colors.background
        layer.maskedCorners = maskedCorners
        layer.cornerRadius = 32.0
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
    }

    func displayAccessoryButton(_ button: UIButton) {
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        horizontalTopLineStackView.addArrangedSubview(button)
    }

    func dismissAccessoryButton(_ button: UIButton) {
        horizontalTopLineStackView.removeArrangedSubview(button)
    }
}

// MARK: - Constants

private extension Section {
    enum Constants {
        static var innerMargins: UIEdgeInsets { UIEdgeInsets(top: 40.0, left: 16.0, bottom: 24.0, right: 16.0) }
        static var contentMargins: UIEdgeInsets { UIEdgeInsets(top: .zero, left: 16.0, bottom: .zero, right: 16.0) }
    }
}

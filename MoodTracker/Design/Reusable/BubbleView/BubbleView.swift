//
//  BubbleView.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 07.10.2024.
//

import UIKit

// MARK: - Props

public extension BubbleView {
    struct Props {
        public let type: AlignmentType
        public let text: NSAttributedString
        public let icon: UIImage?

        public init(type: AlignmentType, text: NSAttributedString, icon: UIImage?) {
            self.type = type
            self.text = text
            self.icon = icon
        }
    }

    enum AlignmentType {
        case left
        case right
    }
}

// MARK: - View

public final class BubbleView: UIView {
    // MARK: - Private Properties

    private var leadingIconConstraint: NSLayoutConstraint!
    private var trailingIconConstraint: NSLayoutConstraint!

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let blurView: BlurView = {
        let view = BlurView()
        view.layer.cornerRadius = 20.0
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppResources.colors.elements
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setupViews()
        configure()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }

    // MARK: - Configuration

    public func render(with props: Props) {

        if let icon = props.icon {
            imageView.image = icon
            imageView.isHidden = false
        } else {
            imageView.image = nil
            imageView.isHidden = true
        }

        textLabel.attributedText = props.text

        setupIcon(alignment: props.type)

        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - Private methods

private extension BubbleView {
    func addSubviews() {
        addSubviews(blurView, textLabel, imageView)

        bringSubviewToFront(textLabel)
        bringSubviewToFront(imageView)
    }

    func setupViews() {
        leadingIconConstraint = imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        trailingIconConstraint = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.useAndActivateConstraints([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.iconSize),
            imageView.widthAnchor.constraint(equalToConstant: Constants.iconSize)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.iconSize / 2),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.iconSize / 2),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.iconSize / 2),
            blurView.topAnchor.constraint(equalTo: topAnchor)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            textLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: Constants.spacing),
            textLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -Constants.spacing),
            textLabel.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -Constants.spacing),
            textLabel.topAnchor.constraint(equalTo: blurView.topAnchor, constant: Constants.spacing),
        ])
    }

    func setupIcon(alignment: AlignmentType) {
        switch alignment {
            case .left:
                leadingIconConstraint.isActive = true
                trailingIconConstraint.isActive = false
                blurView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            case .right:
                leadingIconConstraint.isActive = false
                trailingIconConstraint.isActive = true
                blurView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
    }

    func configure() {
        clipsToBounds = true
        backgroundColor = .clear
    }
}

private extension BubbleView {
    enum Constants {
        static let iconSize: CGFloat = 48.0
        static let spacing: CGFloat = 16.0
    }
}

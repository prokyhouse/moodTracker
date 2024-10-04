//
//  FactCell.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 03.10.2024.
//

import Common
import UIKit

// MARK: - Props

public extension FactCell {
    struct Props {
        public let title: String?
        public let description: String?

        public init(title: String?, description: String?) {
            self.title = title
            self.description = description
        }
    }
}

// MARK: - Cell

public final class FactCell: UICollectionViewCell {
    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.styles.headline
        label.textColor = AppResources.colors.elements
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.styles.text
        label.textColor = AppResources.colors.elements
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.0
        return stackView
    }()

    private lazy var dashLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.lineDashPattern = [2, 2]
        layer.frame = contentView.bounds
        layer.fillColor = nil
        layer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: Constants.cornerRadius).cgPath

        return layer
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

    override public func prepareForReuse() {
        super.prepareForReuse()

        resetCell()
    }

    // MARK: - Configuration

    public func render(with props: Props) {
        titleLabel.text = props.title
        descriptionLabel.text = props.description
    }
}

// MARK: - Private methods

private extension FactCell {
    func addSubviews() {
        contentView.addSubviews(contentStackView)
        contentStackView.addArrangedSubviews(titleLabel, descriptionLabel)
        contentView.layer.addSublayer(dashLayer)
    }

    func setupViews() {
        NSLayoutConstraint.useAndActivateConstraints([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.spacing),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.spacing),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacing)
        ])
    }

    func configure() {
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.clipsToBounds = true

        contentView.layer.borderColor = AppResources.colors.elements.cgColor
    }

    func resetCell() {
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
}

public extension FactCell {
    enum Constants {
        public static let height: CGFloat = 80
        static let cornerRadius: CGFloat = 16.0
        static let spacing: CGFloat = 16.0
    }
}

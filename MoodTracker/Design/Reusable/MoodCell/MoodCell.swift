//
//  MoodCell.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 03.10.2024.
//

import Common
import UIKit

// MARK: - Props

public extension MoodCell {
    struct Props {
        public let id: UUID
        public let title: String?
        public let caption: String?
        public let moodImage: UIImage?
        public let color: UIColor?

        public init(
            id: UUID,
            title: String?,
            caption: String?,
            moodImage: UIImage?,
            color: UIColor?
        ) {
            self.id = id
            self.title = title
            self.caption = caption
            self.moodImage = moodImage
            self.color = color
        }
    }
}

// MARK: - Cell

public final class MoodCell: UICollectionViewCell {
    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.styles.title
        label.textColor = AppResources.colors.background
        return label
    }()

    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.styles.caption
        label.textColor = AppResources.colors.background
        return label
    }()

    private lazy var captionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        return stackView
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = AppResources.images.nextArrow.get().withRenderingMode(.alwaysTemplate)
        imageView.tintColor = AppResources.colors.background

        return imageView
    }()

    private lazy var moodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        captionLabel.text = props.caption
        moodImageView.image = props.moodImage
        contentView.backgroundColor = props.color
    }
}

// MARK: - Private methods

private extension MoodCell {
    func addSubviews() {
        contentView.addSubviews(titleLabel, captionStackView, moodImageView)
        captionStackView.addArrangedSubviews(captionLabel, arrowImageView)
    }

    func setupViews() {
        NSLayoutConstraint.useAndActivateConstraints([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: moodImageView.leadingAnchor, constant: -Constants.spacing),
            titleLabel.bottomAnchor.constraint(equalTo: captionStackView.topAnchor, constant: -2.0),
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            captionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.spacing),
            captionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacing),
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            moodImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
            moodImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.spacing),
            moodImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacing),
            moodImageView.widthAnchor.constraint(equalTo: moodImageView.heightAnchor),
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            contentView.heightAnchor.constraint(equalToConstant: Constants.height),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }

    func configure() {
        contentView.layer.cornerRadius = 16.0
        contentView.clipsToBounds = true
    }

    func resetCell() {
        titleLabel.text = nil
        captionLabel.text = nil
        moodImageView.image = nil
        contentView.backgroundColor = .clear
    }
}

public extension MoodCell {
    enum Constants {
        public static let height: CGFloat = 80
        static let spacing: CGFloat = 16.0
    }
}

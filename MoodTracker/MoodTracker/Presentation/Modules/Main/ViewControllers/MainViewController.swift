//
//  MainView.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Design
import UIKit

protocol MainView: AnyObject {
    func setTitle(_ title: String)

    func displayMoodReports(_ listOfProps: [Design.MoodCell.Props])

    func displayFact(_ props: Design.FactCell.Props)

    func setAddButton(title: String?, image: UIImage?)

    func setTip(
        title: String?,
        description: String?,
        emoji: UIImage?
    )
}

final class MainViewController: UIViewController {
    // MARK: - Internal properties

    var presenter: MainPresenter?

    // MARK: - Private properties

    private var moodCellsProps: [MoodCell.Props] = []
    private var factCellProps: FactCell.Props?

    // MARK: - Views

    private lazy var navBar: NavigationBar = {
        let navBar = NavigationBar()
        navBar.delegate = self
        navBar.isBackButtonHidden = true
        return navBar
    }()

    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        return flowLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = IntrinsicCollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = AppResources.colors.background
        collectionView.contentInset = UIEdgeInsets(horizontal: Constants.spacing)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCellClass(Design.MoodCell.self)
        collectionView.registerCellClass(Design.FactCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = Constants.addButtonHeight / 2
        button.backgroundColor = AppResources.colors.accent
        button.tintColor = AppResources.colors.background
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = AppResources.fonts.styles.subtitle
        button.contentEdgeInsets = UIEdgeInsets(
            top: 4,
            left: 4,
            bottom: 4,
            right: 26
        )
        button.titleEdgeInsets = UIEdgeInsets(
            top: 4,
            left: 26,
            bottom: 4,
            right: 4
        )
        return button
    }()

    private lazy var tipView: UIView = UIView()

    private lazy var tipTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.styles.text
        label.textColor = AppResources.colors.elements
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()

    private lazy var tipDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.styles.subtitle
        label.textColor = AppResources.colors.elements
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    private lazy var tipEmojiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupConstraints()
        setupViews()

        presenter?.onViewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.onViewDidAppear()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.onViewWillAppear()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        adjustScrollViewInsetIfNeeded()
    }
}

// MARK: - Private methods

private extension MainViewController {
    func addSubviews() {
        view.addSubviews(navBar, collectionView, addButton, tipView)
        tipView.addSubviews(tipTitleLabel, tipDescriptionLabel, tipEmojiImageView)

        view.bringSubviewToFront(navBar)
        view.bringSubviewToFront(addButton)
    }

    func setupConstraints() {
        extendedLayoutIncludesOpaqueBars = true
        view.layoutMargins = Constants.innerMargins
        collectionView.layoutMargins = Constants.contentMargins

        NSLayoutConstraint.useAndActivateConstraints([
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            addButton.heightAnchor.constraint(equalToConstant: Constants.addButtonHeight),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -23 - (tabBarBottomInset())),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: Constants.addButtonWidth)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            tipView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            tipView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            tipView.heightAnchor.constraint(equalTo: tipView.widthAnchor),
            tipView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            tipTitleLabel.leadingAnchor.constraint(equalTo: tipView.leadingAnchor, constant: Constants.horizontalSpacing),
            tipTitleLabel.bottomAnchor.constraint(equalTo: tipDescriptionLabel.topAnchor, constant: -8),
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            tipEmojiImageView.leadingAnchor.constraint(equalTo: tipTitleLabel.trailingAnchor, constant: 4),
            tipEmojiImageView.heightAnchor.constraint(equalToConstant: 18),
            tipEmojiImageView.widthAnchor.constraint(equalToConstant: 18),
            tipEmojiImageView.centerYAnchor.constraint(equalTo: tipTitleLabel.centerYAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            tipDescriptionLabel.leadingAnchor.constraint(equalTo: tipView.leadingAnchor, constant: Constants.horizontalSpacing),
            tipDescriptionLabel.trailingAnchor.constraint(equalTo: tipView.trailingAnchor, constant: -Constants.horizontalSpacing),
            tipDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: tipView.bottomAnchor, constant: -Constants.horizontalSpacing),
            tipDescriptionLabel.centerYAnchor.constraint(equalTo: tipView.centerYAnchor)
        ])
    }

    func setupViews() {
        view.backgroundColor = AppResources.colors.background

        tipView.layer.cornerRadius = Constants.cornerRadius
        tipView.layer.borderColor = AppResources.colors.gray.cgColor
        tipView.layer.borderWidth = 1
        tipView.clipsToBounds = true
    }

    func adjustScrollViewInsetIfNeeded() {
        let topInset = navBar.bounds.height - navBar.safeAreaInsets.top
        let bottomInset = tabBarBottomInset()

        let currentTopInset = collectionView.contentInset.top
        let currentBottomInset = collectionView.contentInset.bottom

        if currentTopInset != topInset {
            collectionView.contentInset.top = topInset
        }
        if currentBottomInset != bottomInset {
            collectionView.contentInset.bottom = bottomInset
        }
    }

    func configureContextMenu(id: UUID) -> UIContextMenuConfiguration{
        UIContextMenuConfiguration(
            actionProvider: { [weak self] _ -> UIMenu? in
                guard let self else { return nil }

                let delete = UIAction(
                    title: "Удалить",
                    image: UIImage(systemName: "trash.fill")?.withTintColor(AppResources.colors.red),
                    identifier: nil,
                    discoverabilityTitle: nil,
                    attributes: .destructive,
                    state: .off
                ) { [weak self] (_) in
                    guard let self else { return }
                    presenter?.onDeleteActionTap(moodId: id)
                }

                return UIMenu(
                    options: .displayInline,
                    children: [delete]
                )
            }
        )
    }

    @objc
    func onAddButtonTap() {
        presenter?.onAddButtonTap()
    }
}

// MARK: - MainView

extension MainViewController: MainView {
    func setTitle(_ title: String) {
        navBar.title = title
    }

    func displayMoodReports(_ listOfProps: [Design.MoodCell.Props]) {
        moodCellsProps = listOfProps
        collectionView.isHidden = listOfProps.isEmpty
        tipView.isHidden = !listOfProps.isEmpty
        collectionView.reloadData()
    }

    func displayFact(_ props: FactCell.Props) {
        factCellProps = props
        collectionView.reloadData()
    }

    func setAddButton(
        title: String?,
        image: UIImage?
    ) {
        addButton.isHidden = title == nil || image == nil
        addButton.setTitle(title, for: .normal)
        addButton.setImage(image, for: .normal)
        addButton.addTarget(self, action: #selector(onAddButtonTap), for: .touchUpInside)

        addButton.layoutIfNeeded()
    }

    func setTip(
        title: String?,
        description: String?,
        emoji: UIImage?
    ) {
        tipView.isHidden = title == nil || description == nil
        tipTitleLabel.text = title
        tipDescriptionLabel.text = description
        tipEmojiImageView.image = emoji
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if factCellProps != nil, indexPath.item == moodCellsProps.count / 2 {
            let height = FactCell.Constants.height
            let width = UIScreen.main.bounds.width - Constants.spacing * 2
            return CGSize(width: width, height: height)
        }

        let height = MoodCell.Constants.height
        let width = UIScreen.main.bounds.width - Constants.spacing * 2
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }

    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        if factCellProps != nil, indexPath.item == moodCellsProps.count / 2 {
            return nil
        }

        let adjustedIndex: Int
        if factCellProps != nil && indexPath.item > moodCellsProps.count / 2 {
            adjustedIndex = indexPath.item - 1
        } else {
            adjustedIndex = indexPath.item
        }

        let props = moodCellsProps[adjustedIndex]
        return configureContextMenu(id: props.id)
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard factCellProps != nil else {
            return moodCellsProps.count
        }
        return moodCellsProps.count + 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if let factCellProps = factCellProps, indexPath.item == moodCellsProps.count / 2 {
            let cell = collectionView.dequeueReusableCell(
                ofType: Design.FactCell.self,
                at: indexPath
            )
            cell.render(with: factCellProps)
            return cell
        }

        let adjustedIndex: Int
        if factCellProps != nil && indexPath.item > moodCellsProps.count / 2 {
            adjustedIndex = indexPath.item - 1
        } else {
            adjustedIndex = indexPath.item
        }

        let props = moodCellsProps[adjustedIndex]
        let cell = collectionView.dequeueReusableCell(
            ofType: Design.MoodCell.self,
            at: indexPath
        )
        cell.render(with: props)
        return cell
    }
}

// MARK: - NavigationBarDelegate

extension MainViewController: NavigationBarDelegate {
    func didReceiveBackAction(_ navigationBar: NavigationBar) {
        // В других экранах должен быть leave, но мы находимся на главном экране
        // presenter?.leave()
    }
}

// MARK: - Constants

private extension MainViewController {
    enum Constants {
        static let spacing: CGFloat = 8.0
        static let cornerRadius: CGFloat = 24.0
        static let horizontalSpacing: CGFloat = 16.0
        static let innerMargins: UIEdgeInsets = .zero
        static let contentMargins: UIEdgeInsets = .zero
        static let addButtonHeight: CGFloat = 40.0
        static let addButtonWidth: CGFloat = 220.0
    }
}

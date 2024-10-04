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
        view.addSubviews(navBar, collectionView)

        view.bringSubviewToFront(navBar)
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
    }

    func setupViews() {
        view.backgroundColor = AppResources.colors.background
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
}

// MARK: - MainView

extension MainViewController: MainView {
    func setTitle(_ title: String) {
        navBar.title = title
    }

    func displayMoodReports(_ listOfProps: [Design.MoodCell.Props]) {
        moodCellsProps = listOfProps
        collectionView.isHidden = listOfProps.isEmpty
        collectionView.reloadData()
    }

    func displayFact(_ props: FactCell.Props) {
        factCellProps = props
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height = MoodCell.Constants.height
        let width = UIScreen.main.bounds.width - Constants.spacing * 2
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.onMoodCellTap(withId: moodCellsProps[indexPath.item].id)
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
    }
}

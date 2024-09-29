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

    func displaySomething()
}

final class MainViewController: UIViewController {
    // MARK: - Internal properties

    var presenter: MainPresenter?

    // MARK: - Private properties

    private lazy var navBar: NavigationBar = {
        let navBar = NavigationBar()
        navBar.delegate = self
        navBar.isBackButtonHidden = true
        return navBar
    }()

    private let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()

    private let sectionsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4.0
        return stackView
    }()

    // TODO: - Пример. убрать.
    private lazy var example1SectionView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = AppResources.colors.red
        view.alpha = 0.1
        return view
    }()

    // TODO: - Пример. убрать.
    private lazy var example2SectionView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = AppResources.colors.orange
        view.alpha = 0.1
        return view
    }()

    // TODO: - Пример. убрать.
    private lazy var example3SectionView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = AppResources.colors.indigo
        view.alpha = 0.1
        return view
    }()

    // MARK: - Views

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
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
        view.addSubviews(navBar, scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(sectionsStackView)
        sectionsStackView.addArrangedSubviews(
            example1SectionView,
            example2SectionView,
            example3SectionView
        )

        view.bringSubviewToFront(navBar)
    }

    func setupConstraints() {
        extendedLayoutIncludesOpaqueBars = true
        view.layoutMargins = Constants.innerMargins
        contentView.layoutMargins = Constants.contentMargins

        NSLayoutConstraint.useAndActivateConstraints([
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            sectionsStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            sectionsStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            sectionsStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            sectionsStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
        // TODO: - Пример. убрать.
        NSLayoutConstraint.useAndActivateConstraints([
            example1SectionView.heightAnchor.constraint(equalToConstant: 150),
            example2SectionView.heightAnchor.constraint(equalToConstant: 400),
            example3SectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    func setupViews() {
        view.backgroundColor = AppResources.colors.background
    }

    func adjustScrollViewInsetIfNeeded() {
        let topInset = navBar.bounds.height - navBar.safeAreaInsets.top
        let bottomInset = tabBarBottomInset()

        let currentTopInset = scrollView.contentInset.top
        let currentBottomInset = scrollView.contentInset.bottom

        if currentTopInset != topInset {
            scrollView.contentInset.top = topInset
        }
        if currentBottomInset != bottomInset {
            scrollView.contentInset.bottom = bottomInset
        }
    }
}

// MARK: - MainView

extension MainViewController: MainView {
    func setTitle(_ title: String) {
        navBar.title = title
    }
    func displaySomething() { }
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
        static let cornerRadius: CGFloat = 24.0
        static let horizontalSpacing: CGFloat = 16.0
        static let innerMargins: UIEdgeInsets = .zero
        static let contentMargins: UIEdgeInsets = .zero
    }
}

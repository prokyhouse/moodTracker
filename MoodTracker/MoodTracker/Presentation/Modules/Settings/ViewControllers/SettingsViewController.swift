//
//  SettingsView.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 10.10.2024.
//

import Design
import UIKit

protocol SettingsView: AnyObject {
    func setTitle(_ title: String)

    func setAppVersion(string: String)
}

final class SettingsViewController: UIViewController {
    // MARK: - Internal Properties

    var presenter: SettingsPresenter?

    // MARK: - Private Properties

    private lazy var navBar: NavigationBar = {
        let navBar = NavigationBar()
        navBar.delegate = self
        navBar.isBackButtonHidden = true
        return navBar
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let sectionsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Constants.verticalSpacing
        return stackView
    }()

    private let sectionView: Design.Section<UIStackView> = {
        let section = Design.Section<UIStackView>(
            insets: .init(
                contentInset: UIEdgeInsets(horizontal: Constants.horizontalSpacing),
                innerInset: UIEdgeInsets(all: Constants.horizontalSpacing),
                contentSpacing: Constants.verticalSpacing
            )
        )
        section.contentView.axis = .vertical
        section.contentView.spacing = Constants.horizontalSpacing
        return section
    }()

    private let appearanceSubsectionView = AppearanceView()

    private lazy var appVersionLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.bgProFonts.regular.ofSize(10)
        label.textColor = AppResources.colors.elements.withAlphaComponent(0.6)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.bgProFonts.bold.ofSize(10)
        label.textColor = AppResources.colors.accent
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Developed by ITMO master students. 2024"
        return label
    }()

    private let captionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.onViewDidLoad()

        addSubviews()
        setupConstraints()
        setupViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustScrollViewInsetIfNeeded()
    }
}

// MARK: - Private methods

private extension SettingsViewController {
    func addSubviews() {
        view.addSubviews(scrollView, navBar)
        scrollView.addSubviews(sectionsStackView)
        sectionsStackView.addArrangedSubview(sectionView)
        sectionView.contentView.addArrangedSubviews(appearanceSubsectionView, captionsStackView)
        captionsStackView.addArrangedSubviews(appVersionLabel, captionLabel)
    }

    func setupConstraints() {
        extendedLayoutIncludesOpaqueBars = true
        NSLayoutConstraint.useAndActivateConstraints([
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            sectionsStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            sectionsStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            sectionsStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            sectionsStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            sectionsStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    func setupViews() {
        view.backgroundColor = AppResources.colors.background

        setupAppearanceSection()
    }

    func setupAppearanceSection() {
        appearanceSubsectionView.delegate = self

        guard let presenter = self.presenter else { return }

        appearanceSubsectionView.isSystemAppearance = presenter.isSystemAppearance
        appearanceSubsectionView.appearance = presenter.neededAppearance
    }

    func adjustScrollViewInsetIfNeeded() {
        let topInset = navBar.bounds.height - navBar.safeAreaInsets.top + Constants.verticalSpacing
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

// MARK: - SettingsView

extension SettingsViewController: SettingsView {
    func setTitle(_ title: String) {
        navBar.title = title
    }

    func setAppVersion(string: String) {
        appVersionLabel.text = string
    }
}

// MARK: - NavigationBarDelegate

extension SettingsViewController: NavigationBarDelegate {
    func didReceiveBackAction(_ navigationBar: NavigationBar) {
        presenter?.leave()
    }
}

// MARK: - AppearanceViewDelegate

extension SettingsViewController: AppearanceViewDelegate {
    func appearanceWasSelected(appearance: UIUserInterfaceStyle) {
        presenter?.changeAppearanceTo(appearance)
    }
}

// MARK: - Constants

private extension SettingsViewController {
    enum Constants {
        static let horizontalSpacing: CGFloat = 16.0
        static let verticalSpacing: CGFloat = 4.0
        static let separatorHeight: CGFloat = 1.0
    }
}

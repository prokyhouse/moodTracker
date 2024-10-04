//
//  RoundedTabbar.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Design
import UIKit

final class RoundedTabbar: UITabBar {
    // MARK: Properties

    var style: Style = .rounded {
        didSet {
            guard style != oldValue else { return }

            switch style {
            case .simple:
                containerBackgroundView.layer.cornerRadius = .zero

            case .rounded:
                containerBackgroundView.layer.cornerRadius = Constants.cornerRadius
                containerBackgroundView.setNeedsLayout()
                containerBackgroundView.layoutIfNeeded()
            }
        }
    }

    // MARK: UI components

    fileprivate let containerView = UIView()

    fileprivate let containerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()

    fileprivate let itemsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())

    fileprivate let blurView = BlurView()

    // MARK: Life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
        setupAppearance()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let sizeThatFits = super.sizeThatFits(size)
        let height = self.calculateHeight()
        return CGSize(width: sizeThatFits.width, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if style == .rounded {
            containerBackgroundView.layer.cornerRadius = Constants.cornerRadius
        }

        containerView.frame = bounds.inset(by: safeAreaInsets)
        updateAppearance()
    }

    @available(*, unavailable, message: "Use: `setItems(_ items: [RoundedTabItem])`")
    override func setItems(_: [UITabBarItem]?, animated _: Bool) {}
}

// MARK: - Public

extension RoundedTabbar {
    func setItems(_ items: [RoundedTabItem]) {
        let stackView = itemsStackView

        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for item in items {
            let page = TabBarPage(rawValue: item.index) ?? .main
            stackView.addArrangedSubview(RoundedTabbarItemView(tabBarPage: page))
        }

        guard let itemViews = stackView.arrangedSubviews as? [RoundedTabbarItemView] else { return }

        items.enumerated().forEach { index, item in
            itemViews[index].render(item)
        }
    }
}

// MARK: - Private

extension RoundedTabbar {
    private func updateAppearance() {
        self.subviews.forEach {
            $0.isHidden = $0 !== self.containerView
        }
    }

    func calculateHeight() -> CGFloat {
        let mainWindowBottomInset = UIApplication.shared.mainWindow?.safeAreaInsets.bottom ?? safeAreaInsets.bottom
        return mainWindowBottomInset + Constants.height
    }
}

// MARK: - Setup

private extension RoundedTabbar {
    func setupViews() {
        containerBackgroundView.addSubview(blurView)
        containerView.addSubview(containerBackgroundView)
        containerView.addSubview(itemsStackView)
        addSubview(containerView)
    }

    func setupConstraints() {
        NSLayoutConstraint.useAndActivateConstraints([
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor),

            containerBackgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            containerBackgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            containerBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            containerBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            blurView.leftAnchor.constraint(equalTo: containerBackgroundView.leftAnchor),
            blurView.rightAnchor.constraint(equalTo: containerBackgroundView.rightAnchor),
            blurView.topAnchor.constraint(equalTo: containerBackgroundView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: containerBackgroundView.bottomAnchor),

            itemsStackView.leftAnchor.constraint(equalTo: leftAnchor),
            itemsStackView.rightAnchor.constraint(equalTo: rightAnchor),
            itemsStackView.topAnchor.constraint(equalTo: topAnchor),
            itemsStackView.heightAnchor.constraint(equalToConstant: Constants.height)
        ])
    }

    func setupAppearance() {
        isTranslucent = false
        tintColor = AppResources.colors.elements
        tintAdjustmentMode = .normal
        shadowImage = nil
        backgroundImage = nil
        clipsToBounds = false
        unselectedItemTintColor = AppResources.colors.elements

        let appearance = UITabBarAppearance()
        appearance.backgroundColor = AppResources.colors.background
        appearance.shadowImage = self.shadowImage
        appearance.shadowColor = nil

        standardAppearance = appearance

        scrollEdgeAppearance = standardAppearance
        containerBackgroundView.layer.cornerCurve = .continuous

        updateAppearance()
    }
}

// MARK: - Constants

extension RoundedTabbar {
    private enum Constants {
        static let height: CGFloat = 62.0
        static let cornerRadius: CGFloat = 20.0
    }

    enum Style: Equatable {
        case simple
        case rounded
    }
}

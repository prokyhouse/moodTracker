//
//  RoundedTabbarItemView.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Design
import UIKit

final class RoundedTabbarItemView: UIView {
    // MARK: Parameters

    internal let tabBarPage: TabBarPage

    private var action: ((TabBarPage) -> Void)?

    private var state: TabBarPageState?

    private var isPressed: Bool = false {
        didSet {
            let alpha: CGFloat = isPressed ? Constants.alpha : 1.0
            titleLabel.alpha = alpha
            iconView.alpha = alpha
        }
    }

    // MARK: UI components

    private let iconView = UIImageView()

    private let titleLabel: UILabel = {
        $0.font = AppResources.fonts.styles.ultraSmall
        $0.textColor = AppResources.colors.main
        $0.textAlignment = .center
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    // MARK: Life cycle

    init(tabBarPage: TabBarPage) {
        self.tabBarPage = tabBarPage
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(_ item: RoundedTabItem) {
        titleLabel.text = item.title
        iconView.image = item.icon.withRenderingMode(.alwaysTemplate)
        titleLabel.textColor = item.state.color
        iconView.tintColor = item.state.color
        action = item.action
        state = item.state
        isPressed = false
    }
}

// MARK: - Actions

@objc
extension RoundedTabbarItemView {
    func tapHandler(_: UITapGestureRecognizer) {
        action?(tabBarPage)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isPressed = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isPressed = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isPressed = false
    }
}

// MARK: - Setup

private extension RoundedTabbarItemView {
    func setupViews() {
        self.addSubview(iconView)
        self.addSubview(titleLabel)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        self.addGestureRecognizer(tapRecognizer)
    }

    func setupConstraints() {
        NSLayoutConstraint.useAndActivateConstraints([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(
                equalTo: titleLabel.topAnchor,
                constant: -Constants.iconHeight / 2 - (Constants.titleTopInset / 2.0)
            ),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
            iconView.heightAnchor.constraint(equalToConstant: Constants.iconHeight),

            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 2.0),
            titleLabel.rightAnchor.constraint(greaterThanOrEqualTo: rightAnchor),
            titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor)
        ])

        let constraint = iconView.heightAnchor.constraint(equalToConstant: Constants.iconHeight)
        constraint.priority = .init(rawValue: 999)
    }
}

// MARK: - Constants

private extension RoundedTabbarItemView {
    enum Constants {
        static let titleTopInset: CGFloat = 4.0
        static let titleBottomInset: CGFloat = 4.0
        static let iconHeight: CGFloat = 24.0
        static let alpha: CGFloat = 0.75
    }
}

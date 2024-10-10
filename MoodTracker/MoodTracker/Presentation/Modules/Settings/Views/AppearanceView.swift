//
//  AppearanceView.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 10.10.2024.
//

import Design
import UIKit

// MARK: - AppearanceViewDelegate

protocol AppearanceViewDelegate: AnyObject {
    func appearanceWasSelected(appearance: UIUserInterfaceStyle)
}

final class AppearanceView: UIView {
    // MARK: - Private properties

    var isSystemAppearance: Bool = true {
        didSet {
            appearanceSwitch.isOn = isSystemAppearance
            updateThemeViewsVisibility()
        }
    }

    var appearance: UIUserInterfaceStyle = .unspecified {
        didSet {
            updateThemeViewsSelection()
        }
    }

    weak var delegate: AppearanceViewDelegate?

    // MARK: - Views

    private lazy var sectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.bgProFonts.medium.ofSize(13)
        label.textColor = AppResources.colors.elements.withAlphaComponent(0.8)
        label.text = "Оформление"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.bgProFonts.medium.ofSize(18)
        label.textColor = AppResources.colors.elements
        label.text = "Как в системе"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.bgProFonts.medium.ofSize(13)
        label.textColor = AppResources.colors.elements.withAlphaComponent(0.8)
        label.text = "тема будет меняться в зависимости от выбранной в системе"
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private lazy var appearanceSwitch: UISwitch = {
        let customSwitch = UISwitch()
        customSwitch.onTintColor = AppResources.colors.elements
        customSwitch.tintColor = AppResources.colors.background
        customSwitch.thumbTintColor = AppResources.colors.background
        customSwitch.isOn = isSystemAppearance
        return customSwitch
    }()

    private lazy var lightThemeView: Design.CheckBox = {
        let view = CheckBox(
            text: "Светлая тема",
            isOn: appearance == .light
        )
        return view
    }()

    private lazy var darkThemeView: Design.CheckBox = {
        let view = CheckBox(
            text: "Темная тема",
            isOn: appearance == .dark
        )
        return view
    }()

    private let themesView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 24.0
        return stackView
    }()

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)

        addSubviews()
        setupConstraints()
        setupViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension AppearanceView {
    func addSubviews() {
        addSubviews(sectionNameLabel, titleLabel, subtitleLabel, appearanceSwitch, themesView)
        themesView.addArrangedSubviews(lightThemeView, darkThemeView)
    }

    func setupConstraints() {
        NSLayoutConstraint.useAndActivateConstraints([
            sectionNameLabel.topAnchor.constraint(equalTo: topAnchor),
            sectionNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            titleLabel.topAnchor.constraint(equalTo: sectionNameLabel.bottomAnchor, constant: Constants.spacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: appearanceSwitch.leadingAnchor, constant: -Constants.spacing)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: appearanceSwitch.leadingAnchor, constant: -Constants.spacing)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            appearanceSwitch.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            appearanceSwitch.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.spacing),
            appearanceSwitch.trailingAnchor.constraint(equalTo: trailingAnchor),
            appearanceSwitch.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            themesView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: Constants.spacing),
            themesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            themesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            themesView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupViews() {
        backgroundColor = .clear

        appearanceSwitch.addTarget(self, action: #selector(onAppearanceSwitchToggle), for: .valueChanged)

        lightThemeView.delegate = self
        darkThemeView.delegate = self
    }

    func updateThemeViewsSelection() {
        lightThemeView.isOn = appearance == .light
        darkThemeView.isOn = appearance == .dark
    }

    func updateThemeViewsVisibility() {
        isSystemAppearance ? animateThemeViewsHide() : animateThemeViewsAppear()
    }

    func animateThemeViewsAppear() {
        UIView.animateKeyframes(
            withDuration: Constants.animationDuration,
            delay: 0.0,
            options: [],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 1.0
                ) { [weak self] in
                    self?.darkThemeView.isHidden = false
                    self?.lightThemeView.isHidden = false
                }
            },
            completion: { [weak self] _ in
                self?.darkThemeView.alpha = 1.0
                self?.lightThemeView.alpha = 1.0
            }
        )
    }

    func animateThemeViewsHide() {
        darkThemeView.alpha = 0.0
        lightThemeView.alpha = 0.0

        UIView.animateKeyframes(
            withDuration: Constants.animationDuration,
            delay: 0.0,
            options: [],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 1.0
                ) { [weak self] in
                    self?.darkThemeView.isHidden = true
                    self?.lightThemeView.isHidden = true
                }
            },
            completion: nil
        )
    }

    @objc
    func onAppearanceSwitchToggle(sender: UISwitch) {
        isSystemAppearance = sender.isOn
        let neededAppearance: UIUserInterfaceStyle = isSystemAppearance ? .unspecified : .light
        appearance = neededAppearance
        delegate?.appearanceWasSelected(appearance: neededAppearance)
    }
}

extension AppearanceView: Design.CheckBoxDelegate {
    func radioButtonWasSelected(sender: Design.CheckBox) {
        switch sender {
            case lightThemeView:
                darkThemeView.isOn = false
                appearance = .light

            case darkThemeView:
                lightThemeView.isOn = false
                appearance = .dark

            default:
                break
        }
        delegate?.appearanceWasSelected(appearance: appearance)
    }
}

private extension AppearanceView {
    enum Constants {
        static let spacing: CGFloat = 16.0
        static let buttonHeight: CGFloat = 32.0
        static let animationDuration: CGFloat = 0.3
    }
}

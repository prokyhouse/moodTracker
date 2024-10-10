//
//  CheckBox.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 10.10.2024.
//

import UIKit

public protocol CheckBoxDelegate: AnyObject {
    func radioButtonWasSelected(sender: CheckBox)
}

// MARK: - CheckBox

public final class CheckBox: UIView {
    // MARK: - Private properties

    public var text: String? {
        didSet {
            titleLabel.text = text
        }
    }

    public var isOn: Bool {
        didSet {
            radioButton.isSelected = isOn
        }
    }

    public weak var delegate: CheckBoxDelegate?

    // MARK: - Views

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.bgProFonts.medium.ofSize(18)
        label.textColor = AppResources.colors.elements
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    private let radioButton: RadioButton = {
        let button = RadioButton.button()
        return button
    }()

    // MARK: - Lifecycle

    public init(text: String, isOn: Bool) {
        self.titleLabel.text = text
        self.isOn = isOn

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

private extension CheckBox {
    func addSubviews() {
        addSubviews(titleLabel, radioButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.useAndActivateConstraints([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: radioButton.leadingAnchor)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            radioButton.topAnchor.constraint(equalTo: topAnchor),
            radioButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            radioButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            radioButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            radioButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
            radioButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize)
        ])
    }

    func setupViews() {
        backgroundColor = .clear

        // Перехватываем нажатие на всю строку
        radioButton.isUserInteractionEnabled = false
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapHandler)))
    }

    @objc
    func onTapHandler(sender: RadioButton) {
        isOn = true
        delegate?.radioButtonWasSelected(sender: self)
    }
}

private extension CheckBox {
    enum Constants {
        static let buttonSize: CGFloat = 24.0
    }
}

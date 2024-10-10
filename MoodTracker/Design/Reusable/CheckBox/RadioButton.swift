//
//  RadioButton.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 10.10.2024.
//

import UIKit

public final class RadioButton: UIButton {
    // MARK: - Public Properties

    override public var intrinsicContentSize: CGSize {
        CGSize(width: 24.0, height: 24.0)
    }

    // MARK: - Lifecycle

    public static func button() -> RadioButton {
        let images = AppResources.images
        let button = RadioButton(type: .custom)
        button.setImage(images.deselectedRadioButton.get(), for: .normal)
        button.setImage(images.selectedRadioButton.get(), for: .selected)
        button.tintColor = AppResources.colors.elements
        return button
    }
}

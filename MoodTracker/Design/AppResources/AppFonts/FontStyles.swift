//
//  FontStyles.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 07.06.2023.
//

import UIKit

public struct FontStyles {
    /// **Medium / 24.0**
    public let title: UIFont
    /// **Medium / 16.0**
    public let subtitle: UIFont
    /// **Medium / 14.0**
    public let headline: UIFont
    /// **Light / 14.0**
    public let text: UIFont
    /// **Regular / 12.0**
    public let caption: UIFont
    /// **Light / 12.0**
    public let ultraSmall: UIFont

    internal init(fontFamily: BasisGrotesqueProFonts) {
        self.title = fontFamily.medium.ofSize(24.0)
        self.subtitle = fontFamily.medium.ofSize(16.0)
        self.headline = fontFamily.medium.ofSize(14.0)
        self.text = fontFamily.light.ofSize(14.0)
        self.caption = fontFamily.regular.ofSize(12.0)
        self.ultraSmall = fontFamily.light.ofSize(12.0)
    }
}

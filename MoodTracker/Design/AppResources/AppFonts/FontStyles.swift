//
//  FontStyles.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 07.06.2023.
//

import UIKit

public struct FontStyles {
    /// **Medium / 30.0**
    public let titleH1: UIFont
    /// **Medium / 24.0**
    public let titleH2: UIFont
    /// **Regular / 19.0**
    public let mainText: UIFont
    /// **Medium / 13.0**
    public let caption: UIFont
    /// **Medium / 10.0**
    public let ultraSmall: UIFont

    internal init(fontFamily: BasisGrotesqueProFonts) {
        self.titleH1 = fontFamily.medium.ofSize(30.0)
        self.titleH2 = fontFamily.medium.ofSize(24.0)
        self.mainText = fontFamily.medium.ofSize(18.0)
        self.caption = fontFamily.medium.ofSize(13.0)
        self.ultraSmall = fontFamily.medium.ofSize(10.0)
    }
}

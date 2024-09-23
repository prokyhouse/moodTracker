//
//  AppFonts.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 16.02.2023.
//

import CoreText
import Foundation
import UIKit

/// Менеджер шрифтов.
public class AppFonts: NSObject {
    // MARK: - Properties

    /// Basis Grotesque Pro
    public let bgProFonts: BasisGrotesqueProFonts = .init()
    /// Default font styles
    public let styles: FontStyles

    // MARK: - Initialization

    override internal init() {
        [
            "BasisGrotesquePro-Black",
            "BasisGrotesquePro-BlackItalic",
            "BasisGrotesquePro-Bold",
            "BasisGrotesquePro-BoldItalic",
            "BasisGrotesquePro-Medium",
            "BasisGrotesquePro-MediumItalic",
            "BasisGrotesquePro-Regular",
            "BasisGrotesquePro-RegularItalic",
            "BasisGrotesquePro-Light",
            "BasisGrotesquePro-LightItalic"
        ]
            .forEach { appFont in
                AppFonts.loadFont(withName: appFont)
            }

        styles = .init(fontFamily: bgProFonts)

        super.init()
    }

    // MARK: - Methods

    private static func loadFont(withName fontName: String) {
        let bundle = Bundle(for: AppFonts.self)
        let fontExtension = "ttf"
        guard
            let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension)
        else {
            return
        }
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
    }
}

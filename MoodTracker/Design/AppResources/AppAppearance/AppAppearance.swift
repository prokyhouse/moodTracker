//
//  AppAppearance.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 17.02.2023.
//

import Foundation
import UIKit

public final class AppAppearance {
    private let defaults = UserDefaults.standard
    private let defaultsKey: String = "AppAppearance"

    public init() { }

    public func updateAppearance() {
        let appearance = getNeededAppearance()
        change(to: appearance)
    }

    public func change(to appearance: UIUserInterfaceStyle) {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .forEach { windowScene in
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = appearance
                }
            }

        defaults.setValue(appearance.rawValue, forKeyPath: defaultsKey)
    }

    public func getNeededAppearance() -> UIUserInterfaceStyle {
        if
            let storagedAppearanceAsInt = defaults.object(forKey: defaultsKey) as? Int,
            let storagedAppearance = UIUserInterfaceStyle(rawValue: storagedAppearanceAsInt)
        {
            return storagedAppearance
        } else {
            return UIUserInterfaceStyle.unspecified
        }
    }

    public func getCurrentAppearance() -> UIUserInterfaceStyle {
        UITraitCollection.current.userInterfaceStyle
    }
}

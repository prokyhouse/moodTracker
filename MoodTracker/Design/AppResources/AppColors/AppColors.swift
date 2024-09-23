//
//  AppColors.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 16.02.2023.
//

import Common
import UIKit

public final class AppColors {
    // MARK: Public Properties

    /// Background and surface (day: #FFFFFF 100%, night: #1D1D21 100%)
    public private(set) lazy var backgroundAndSurface: UIColor = .dynamicColor(light: white, dark: satinDeepBlack)

    /// Transparent surface (day: #FFFFFF 80%, night: #1D1D21 80%)
    public private(set) lazy var transparentSurface: UIColor = .dynamicColor(
        light: white.withAlphaComponent(0.8),
        dark: satinDeepBlack.withAlphaComponent(0.8)
    )

    /// Background (day: #EEEDF1 100%, night: #302E36 100%)
    public private(set) lazy var background: UIColor = .dynamicColor(light: submarine, dark: submarine)

    /// Main (day: #2C2C33 100%, night: #FFFFFF 100%)
    public private(set) lazy var main: UIColor = .dynamicColor(light: bastille, dark: white)

    /// Input (day: #F5F5F5 100%, night: #2D2D2F 100%)
    public private(set) lazy var input: UIColor = .dynamicColor(light: lightGray, dark: midnightGray)

    /// Black on accent backgrounds (day: #2C2C33 100%, night: #2C2C33 100%)
    public private(set) lazy var blackOnAccentBackgrounds: UIColor = .dynamicColor(light: bastille, dark: bastille)

    /// White on accent backgrounds (day: #FFFFFF 100%, night: #FFFFFF 100%)
    public private(set) lazy var whiteOnAccentBackgrounds: UIColor = .dynamicColor(light: white, dark: white)

    /// Overlay color (day: #000000 80%, night: #000000 70%)
    public private(set) lazy var overlay: UIColor = .dynamicColor(
        light: black.withAlphaComponent(0.8),
        dark: black.withAlphaComponent(0.7)
    )

    /// Second (day: #808092 100%, night: #FFFFFF 100%)
    public private(set) lazy var second: UIColor = .dynamicColor(light: purpletone, dark: victorianPewter)

    /// Transparent progress (day: #000000 10%, night: #C3C3C3 10%)
    public private(set) lazy var transparentProgress: UIColor = .dynamicColor(
        light: black.withAlphaComponent(0.1),
        dark: weatheredStone.withAlphaComponent(0.1)
    )

    /// Disabled elements (day: #BFBFCD 100%, night: #595967 80%)
    public private(set) lazy var disabledElements: UIColor = .dynamicColor(
        light: gentlemansSuit,
        dark: gunmetal.withAlphaComponent(0.8)
    )

    /// Lemon (day: #EDFF40 100%, night: #EDFF40 100%)
    public private(set) lazy var lemon: UIColor = .dynamicColor(light: offYellow, dark: offYellow)

    /// Violet (day: #9D61FF 100%, night: #9D61FF 100%)
    public private(set) lazy var violet: UIColor = .dynamicColor(light: irrigoPurple, dark: irrigoPurple)

    /// Pink (day: #FF55D4 100%, night: #FF55D4 100%)
    public private(set) lazy var pink: UIColor = .dynamicColor(light: drunkenFlamingo, dark: drunkenFlamingo)

    /// Second (day: #8A88FF 100%, night: #8A88FF 100%)
    public private(set) lazy var error: UIColor = .dynamicColor(light: redMull, dark: redMull)

    /// Second (day: #FA8ADE 100%, night: #FA8ADE 100%)
    public private(set) lazy var success: UIColor = .dynamicColor(light: poisonousPesticide, dark: poisonousPesticide)

    /// Attention (day: #FFAF65 100%, night: #FFAF65 100%)
    public private(set) lazy var attention: UIColor = .dynamicColor(light: orange, dark: orange)

    /// Light / Gray / Gray 3 (day: #C7C7CC 100%, night: #C7C7CC 100%)
    public private(set) lazy var gray: UIColor = .dynamicColor(light: centreStage, dark: centreStage)

    public func custom(
        light lightKeyPath: KeyPath<AppColors, UIColor>,
        dark darkKeyPath: KeyPath<AppColors, UIColor>
    ) -> UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return self[keyPath: lightKeyPath].resolvedColor(with: traitCollection)

            case .dark:
                return self[keyPath: darkKeyPath].resolvedColor(with: traitCollection)

            case .unspecified:
                return self[keyPath: lightKeyPath].resolvedColor(with: traitCollection)

            @unknown default:
                return self[keyPath: lightKeyPath].resolvedColor(with: traitCollection)
            }
        }
    }

    // MARK: Private Properties

    // Имена цветов сгенерированы на сайте https://color-name-generator.com/

    /// #013133, 100%
    private let submarine: UIColor = AppColor(rawValue: "#013133").get()

    /// #FFFFFF, 100%
    private let white: UIColor = AppColor(rawValue: "#FFFFFF").get()

    /// #000000, 100%
    private let black: UIColor = AppColor(rawValue: "#000000").get()

    /// #FFAF65, 100%
    private let lightGray: UIColor = AppColor(rawValue: "#F5F5F5").get()

    /// #2D2D2F, 100%
    private let midnightGray: UIColor = AppColor(rawValue: "#2D2D2F").get()

    /// #1D1D21, 100%
    private let satinDeepBlack: UIColor = AppColor(rawValue: "#1D1D21").get()

    /// #EEEDF1, 100%
    private let crystalBell: UIColor = AppColor(rawValue: "#EEEDF1").get()

    /// #302E36, 100%
    private let nightBlack: UIColor = AppColor(rawValue: "#302E36").get()

    /// #2C2C33, 100%
    private let bastille: UIColor = AppColor(rawValue: "#2C2C33").get()

    /// #808092, 100%
    private let purpletone: UIColor = AppColor(rawValue: "#808092").get()

    /// #848389, 100%
    private let victorianPewter: UIColor = AppColor(rawValue: "#848389").get()

    /// #BFBFCD, 100%
    private let gentlemansSuit: UIColor = AppColor(rawValue: "#BFBFCD").get()

    /// #595967, 100%
    private let gunmetal: UIColor = AppColor(rawValue: "#595967").get()

    /// #EDFF40, 100%
    private let offYellow: UIColor = AppColor(rawValue: "#EDFF40").get()

    /// #9D61FF, 100%
    private let irrigoPurple: UIColor = AppColor(rawValue: "#9D61FF").get()

    /// #FF55D4, 100%
    private let drunkenFlamingo: UIColor = AppColor(rawValue: "#FF55D4").get()

    /// #FA8A8A, 100%
    private let redMull: UIColor = AppColor(rawValue: "#FA8A8A").get()

    /// #35D13B, 100%
    private let poisonousPesticide: UIColor = AppColor(rawValue: "#35D13B").get()

    /// #FFAF65, 100%
    private let orange: UIColor = AppColor(rawValue: "#FFAF65").get()

    /// #C7C7CC, 100%
    private let centreStage: UIColor = AppColor(rawValue: "#C7C7CC").get()

    /// #C3C3C3, 100%
    private let weatheredStone: UIColor = AppColor(rawValue: "#C3C3C3").get()
}

// MARK: Private Functions

private extension AppColors {
    static func colorWithAlpha(forHexString hexString: String, alpha: Double) -> AppColor {
        guard hexString.isEmpty == false else {
            return AppColor(rawValue: hexString)
        }

        let alphaPrefix = prefixString(forAlpha: alpha)

        var copy = hexString

        if copy.first == "#" {
            copy.removeFirst()
        }
        return AppColor(rawValue: "#\(alphaPrefix)\(copy)")
    }

    static func prefixString(forAlpha alpha: Double) -> String {
        let fixedAlpha = min(max(alpha, 0), 1)
        let byteValue = Int(255 * fixedAlpha)
        return String(format: "%02X", byteValue)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 15.0, *)
struct AppColors_Previews: PreviewProvider {
    typealias Pair = (String, UIColor)

    static let pairs: [Pair] = [
        ("Background And Surface", AppResources.colors.backgroundAndSurface),
        ("Transparent Surface", AppResources.colors.transparentSurface),
        ("Background", AppResources.colors.background),
        ("Main", AppResources.colors.main),
        ("Black On Accent Backgrounds", AppResources.colors.blackOnAccentBackgrounds),
        ("White On Accent Backgrounds", AppResources.colors.whiteOnAccentBackgrounds),
        ("Overlay", AppResources.colors.overlay),
        ("Second", AppResources.colors.second),
        ("Transparent Progress", AppResources.colors.transparentProgress),
        ("Disabled Elements", AppResources.colors.disabledElements),
        ("Lemon", AppResources.colors.lemon),
        ("Violet", AppResources.colors.violet),
        ("Pink", AppResources.colors.pink),
        ("Error", AppResources.colors.error),
        ("Success", AppResources.colors.success),
        ("Attention", AppResources.colors.attention)
    ]

    static var previews: some View {
        List {
            ForEach(pairs, id: \.0) { title, color in
                HStack {
                    Text(title)
                        .lineLimit(2)
                    Spacer()
                    Color(color)
                        .border(.black)
                        .frame(width: 32.0, height: 32.0)
                }
            }
        }
    }
}
#endif

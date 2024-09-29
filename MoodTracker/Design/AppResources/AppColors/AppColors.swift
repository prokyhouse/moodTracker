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

    public private(set) lazy var accent: UIColor = .dynamicColor(light: accentForLight, dark: accentForDark)

    public private(set) lazy var background: UIColor = .dynamicColor(light: backgroundForLight, dark: backgroundForDark)

    public private(set) lazy var elements: UIColor = .dynamicColor(light: elementsForLight, dark: elementsForDark)

    public private(set) lazy var red: UIColor = .dynamicColor(light: warmRed, dark: warmRed)

    public private(set) lazy var orange: UIColor = .dynamicColor(light: darkOrange, dark: darkOrange)

    public private(set) lazy var green: UIColor = .dynamicColor(light: avocadoGreen, dark: avocadoGreen)

    public private(set) lazy var indigo: UIColor = .dynamicColor(light: persianIndigo, dark: persianIndigo)

    public private(set) lazy var blue: UIColor = .dynamicColor(light: oceanBlue, dark: oceanBlue)

    public private(set) lazy var gray: UIColor = .dynamicColor(light: trafficGray, dark: trafficGray)

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

    /// #FF3333, 100%
    private let warmRed: UIColor = AppColor(rawValue: "#FF3333").get()

    /// #FF9900, 100%
    private let darkOrange: UIColor = AppColor(rawValue: "#FF9900").get()

    /// #4F9800, 100%
    private let avocadoGreen: UIColor = AppColor(rawValue: "#4F9800").get()

    /// #330066, 100%
    private let persianIndigo: UIColor = AppColor(rawValue: "#330066").get()

    /// #02293E, 100%
    private let oceanBlue: UIColor = AppColor(rawValue: "#02293E").get()

    /// #999999, 100%
    private let trafficGray: UIColor = AppColor(rawValue: "#999999").get()

    /// #00617F, 100%
    private let accentForLight: UIColor = AppColor(rawValue: "#00617F").get()

    /// #37789A, 100%
    private let accentForDark: UIColor = AppColor(rawValue: "#37789A").get()

    /// #FFFFFF, 100%
    private let backgroundForLight: UIColor = AppColor(rawValue: "#FFFFFF").get()

    /// #012F43, 100%
    private let backgroundForDark: UIColor = AppColor(rawValue: "#012F43").get()

    /// #000000, 100%
    private let elementsForLight: UIColor = AppColor(rawValue: "#000000").get()

    /// #FFFFFF, 100%
    private let elementsForDark: UIColor = AppColor(rawValue: "#FFFFFF").get()
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
        ("Red", AppResources.colors.red),
        ("Orange", AppResources.colors.orange),
        ("Green", AppResources.colors.green),
        ("Indigo", AppResources.colors.indigo),
        ("Blue", AppResources.colors.blue),
        ("Gray", AppResources.colors.gray),
        ("Accent", AppResources.colors.accent),
        ("Background", AppResources.colors.background),
        ("Elements", AppResources.colors.elements)
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

//
//  AppColor.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 16.02.2023.
//

import Foundation

public struct AppColor: ColorResourceConvertible {
    public var rawValue: String

    // MARK: - Initialization

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - ExpressibleByStringLiteral

extension AppColor: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

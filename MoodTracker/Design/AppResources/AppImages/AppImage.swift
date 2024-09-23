//
//  AppImage.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 21.02.2023.
//

import Foundation

public struct AppImage: ImageResourceConvertible {
    // MARK: - Properties

    public let rawValue: String
}

extension AppImage: ExpressibleByStringLiteral {
    // MARK: - Initialization

    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

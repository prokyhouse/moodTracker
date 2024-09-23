//
//  ColorResourceConvertible.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 16.02.2023.
//

import Common
import UIKit

public protocol ColorResourceConvertible: ResourceConvertible {}

public extension ColorResourceConvertible {
    func get() -> UIColor {
        return UIColor(hexString: rawValue)
    }
}

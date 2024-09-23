//
//  ImageResourceConvertible.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 21.02.2023.
//

import UIKit

public protocol ImageResourceConvertible: ResourceConvertible {}

public extension ImageResourceConvertible {
    // MARK: - Functions

    func get() -> UIImage {
        guard let image = UIImage(
            named: rawValue,
            in: AppResources.bundle,
            compatibleWith: nil
        ) else {
            assertionFailure("Unsuccessful attempt to create image. Image name - \"\(rawValue)\"")
            return UIImage()
        }
        return image
    }
}

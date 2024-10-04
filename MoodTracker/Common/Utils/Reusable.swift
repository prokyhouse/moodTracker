//
//  Reusable.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 03.10.2024.
//

import UIKit

public protocol Reusable {
    static var reuseId: String { get }
}

public extension Reusable {
    static var reuseId: String {
        String(describing: self)
    }
}

extension UITableViewCell: Reusable { }

extension UICollectionViewCell: Reusable { }

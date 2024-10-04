//
//  func.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import UIKit

public extension NSLayoutConstraint {
    class func useAndActivateConstraints(_ constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            if let view = constraint.firstItem as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        activate(constraints)
    }
}

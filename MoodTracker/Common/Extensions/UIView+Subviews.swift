//
//  UIView+Extensions.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 23.09.2024.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: UIView...) {
        addSubviews(views)
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}

public extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        addArrangedSubviews(views)
    }

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}

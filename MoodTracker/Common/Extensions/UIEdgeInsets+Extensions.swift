//
//  UIEdgeInsets+Extensions.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 03.10.2024.
//

import UIKit

public extension UIEdgeInsets {
    init(
        horizontal: CGFloat = .zero,
        vertical: CGFloat = .zero
    ) {
        self.init(
            top: vertical,
            left: horizontal,
            bottom: vertical,
            right: horizontal
        )
    }

    init(all: CGFloat = .zero) {
        self.init(
            top: all,
            left: all,
            bottom: all,
            right: all
        )
    }

    var verticalInsets: CGFloat {
        return top + bottom
    }

    var horizontalInsets: CGFloat {
        return left + right
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        return UIEdgeInsets(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right
        )
    }
}

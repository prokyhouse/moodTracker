//
//  IntrinsicCollectionView.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 03.10.2024.
//

import UIKit

open class IntrinsicCollectionView: UICollectionView {
    // MARK: - Lifecycle

    override public var intrinsicContentSize: CGSize {
        collectionViewLayout.collectionViewContentSize
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
}

//
//  MoodSlider.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 07.10.2024.
//

import UIKit

public final class MoodSlider: UISlider {
    public override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = Constants.trackHeight / 2
        layer.masksToBounds = true
        backgroundColor = AppResources.colors.background.withAlphaComponent(0.3)
        minimumTrackTintColor = .clear
        maximumTrackTintColor = .clear
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let track = super.trackRect(forBounds: bounds)

        return CGRect(
            x: track.origin.x,
            y: track.origin.y - Constants.trackHeight / 2 + Constants.thumbInset,
            width: track.width,
            height: Constants.trackHeight
        )
    }
}

// MARK: MoodSlider.Constants

private extension MoodSlider {
    enum Constants {
        static let trackHeight: CGFloat = 33
        static let thumbInset: CGFloat = 2
    }
}

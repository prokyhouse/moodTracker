//
//  MoodFormatter.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 09.10.2024.
//


import UIKit
import Domain

public protocol MoodUIFormatter: AnyObject {

    func getMoodColor(for type: MoodType) -> UIColor

    func getMoodEmoji(for type: MoodType) -> UIImage

    func getMoodDescription(for type: MoodType) -> String
}

public final class MoodUIFormatterImpl: MoodUIFormatter {

    public init() { }

    public func getMoodColor(for type: MoodType) -> UIColor {
        switch type {
            case .starStruck:
                AppResources.colors.red
            case .delighted:
                AppResources.colors.orange
            case .calm:
                AppResources.colors.green
            case .disappointed:
                AppResources.colors.indigo
            case .melancholic:
                AppResources.colors.blue
            @unknown default:
                AppResources.colors.green
        }
    }

    public func getMoodEmoji(for type: MoodType) -> UIImage {
        switch type {
            case .starStruck:
                return AppResources.images.starStruck.get()

            case .delighted:
                return AppResources.images.delighted.get()

            case .calm:
                return AppResources.images.calm.get()

            case .melancholic:
                return AppResources.images.melancholic.get()

            case .disappointed:
                return AppResources.images.disappointed.get()

            default:
                return AppResources.images.calm.get()
        }
    }

    public func getMoodDescription(for type: MoodType) -> String {
        switch type {
            case .starStruck:
                return "Очень приятный день"

            case .delighted:
                return "Приятный день"

            case .calm:
                return "Нейтральный день"

            case .melancholic:
                return "Неприятный день"

            case .disappointed:
                return "Грустный день"

            default:
                return "Просто день"
        }
    }
}

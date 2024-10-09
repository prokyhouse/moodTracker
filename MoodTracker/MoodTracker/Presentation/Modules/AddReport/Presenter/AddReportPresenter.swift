//
//  AddReportPresenter.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Design
import Domain
import Storage
import UIKit

protocol AddReportPresenter: AnyObject {
    /// Обработка входа на экран.
    func onViewDidLoad()

    /// Триггер загрузки данных
    func onViewDidAppear()

    /// События показа экрана
    func onViewWillAppear()

    func onSliderValueDidChange(value: Float)

    func onSaveButtonTapped()

    /// Закрытие экрана
    func leave(completion: (() -> Void)?)
}

final class AddReportViewPresenter {
    // MARK: - Private Properties

    private unowned let view: AddReportView
    private let coordinator: MainCoordinator
    private let coreDataService: CoreDataService
    private let moodFormatter: MoodUIFormatter

    private var moodType: MoodType = .calm

    // MARK: - Initialization

    init(
        view: AddReportView,
        coordinator: MainCoordinator,
        coreDataService: CoreDataService,
        moodFormatter: MoodUIFormatter
    ) {
        self.view = view
        self.coordinator = coordinator
        self.coreDataService = coreDataService
        self.moodFormatter = moodFormatter
    }
}

// MARK: - AddReportPresenter

extension AddReportViewPresenter: AddReportPresenter {
    func onViewDidLoad() {
        view.setTitle(Constants.L10n.title)

        displayMood(type: moodType, isAnimated: false)
    }

    func onViewWillAppear() { }

    func onViewDidAppear() { }

    func onSliderValueDidChange(value: Float) {
        let selectedMood = MoodType(rawValue: Int(value)) ?? moodType
        moodType = selectedMood

        displayMood(type: selectedMood, isAnimated: true)
    }

    func onSaveButtonTapped() {
        let moodLevel = moodType.rawValue
        coreDataService.addMoodNote(moodLevel: moodLevel)
    }

    func leave(completion: (() -> Void)?) {
        coordinator.goBack()
        completion?()
    }
}

// MARK: - Private Methods

private extension AddReportViewPresenter {
    func displayMood(type: MoodType, isAnimated: Bool) {
        view.displayMoodAppearance(
            backgroundColor: moodFormatter.getMoodColor(for: type),
            isAnimated: isAnimated
        )
        view.setQuestionBubbleText(getQuestion(), emoji: nil)
        view.setUserBubbleText(
            getAnswer(for: type),
            emoji: moodFormatter.getMoodEmoji(for: type),
            isAnimated: isAnimated
        )
        view.setMoodSliderValue(type.rawValue)
    }

    func getQuestion() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: AppResources.fonts.styles.title,
            .foregroundColor: AppResources.colors.elements
        ]
        return NSAttributedString(string: Constants.L10n.question, attributes: attributes)
    }

    func getAnswer(for type: MoodType) -> NSAttributedString {
        let answer = NSMutableAttributedString()

        let ending = moodFormatter.getMoodDescription(for: type)
        let startAttributes: [NSAttributedString.Key: Any] = [
            .font: AppResources.fonts.styles.title,
            .foregroundColor: AppResources.colors.elements
        ]
        let endAttributes: [NSAttributedString.Key: Any] = [
            .font: AppResources.fonts.bgProFonts.bold.ofSize(24),
            .foregroundColor: AppResources.colors.elements
        ]
        answer.append(NSAttributedString(string: Constants.L10n.answerBeginning, attributes: startAttributes))
        answer.append(NSAttributedString(string: ending, attributes: endAttributes))

        return answer
    }

    enum Constants {
        enum L10n {
            static let title: String = "Новая запись"
            static let question: String = "Как бы ты сейчас описал свои ощущения?"
            static let answerBeginning: String = "Это был \n"
        }
    }
}

//
//  MainPresenter.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//


import Common
import Design
import Domain
import UIKit

protocol MainPresenter: AnyObject {
    /// Обработка входа на экран.
    func onViewDidLoad()

    /// Триггер загрузки данных
    func onViewDidAppear()

    /// События показа экрана
    func onViewWillAppear()

    /// Обработка нажатия на что-то
    //func openSomething()
}

final class MainViewPresenter {
    // MARK: - Private Properties

    private unowned let view: MainView
    private let coordinator: MainCoordinator

    // MARK: - Initialization

    init(
        view: MainView,
        coordinator: MainCoordinator
    ) {
        self.view = view
        self.coordinator = coordinator
    }
}

// MARK: - MainPresenter

extension MainViewPresenter: MainPresenter {
    func onViewDidLoad() {
        view.setTitle("Как твоё настроение?")
    }

    func onViewWillAppear() { }

    func onViewDidAppear() { }
}

// MARK: - Private Methods

private extension MainViewPresenter { }

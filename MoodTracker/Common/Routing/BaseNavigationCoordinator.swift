//
//  BaseNavigationCoordinator.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 23.09.2024.
//

import UIKit

open class BaseNavigationCoordinator: BaseCoordinator<UINavigationController> {
    // MARK: - Public Properties

    public var navigationController: UINavigationController {
        root as UINavigationController
    }

    /// Завершать координатор при очищении стека навигации
    public var isCloseOnEmptyStack: Bool = true

    // MARK: - Private Properties

    /// Размер стэка навигации для текущего координатора (отличается от размера стэка `navigationController`).
    /// Координатор закрывается, когда размер становится равным 0.
    private var localStackSize: Int = .zero

    // MARK: - Lifecycle

    public init(navigationController: UINavigationController) {
        super.init(root: navigationController)
        navigationController.delegate = self
    }

    // MARK: - Back actions
    // 'goBack' - для полноэкранного отображения
    // 'close' - для Sheet-отображения

    open func goBack(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
}

// MARK: - UINavigationControllerDelegate

extension BaseNavigationCoordinator: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard isCloseOnEmptyStack else {
            return
        }
        guard let sourceViewController = viewController.transitionCoordinator?.viewController(forKey: .from) else {
            // При установке root-контроллера `transitionCoordinator` не содержит источника перехода — увеличиваем счётчик вручную.
            if navigationController.viewControllers.contains(viewController) {
                localStackSize += 1 // Root
            }
            return
        }

        if navigationController.viewControllers.contains(sourceViewController) {
            localStackSize += 1 // Push
        } else {
            localStackSize -= 1 // Pop
        }

        if localStackSize == .zero {
            didClosed() // Уведомляем о закрытии, когда локальный стэк обнуляется
        }
    }
}

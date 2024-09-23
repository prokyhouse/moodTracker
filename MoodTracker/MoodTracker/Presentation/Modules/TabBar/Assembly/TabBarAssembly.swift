//
//  TabBarAssembly.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Domain
import Foundation

final class TabBarAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var useCaseAssembly: UseCaseAssembly = self.context.assembly()
    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    // MARK: - Internal Methods

    func assembleModule() -> TabBarController {
        return define(scope: .prototype, init: TabBarController()) { view in
            view.presenter = self.assemblePresenter(view: view)
            return view
        }
    }
}

// MARK: Private Methods

private extension TabBarAssembly {
    func assemblePresenter(view: TabBarView) -> TabBarPresenter {
        return define(
            scope: .prototype,
            init: TabBarViewPresenter(view: view)
        )
    }
}

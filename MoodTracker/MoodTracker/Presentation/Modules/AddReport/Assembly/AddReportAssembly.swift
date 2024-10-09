//
//  AddReport.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 04.10.2024.
//

import Common
import Domain
import Foundation

final class AddReportAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var useCaseAssembly: UseCaseAssembly = self.context.assembly()
    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()
    private lazy var formatterAssembly: FormatterAssembly = self.context.assembly()

    // MARK: - Internal Methods

    func assembleModule(
        coordinator: MainCoordinator
    ) -> AddReportViewController {
        return define(scope: .prototype, init: AddReportViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

// MARK: Private Methods

private extension AddReportAssembly {
    func assemblePresenter(view: AddReportView, coordinator: MainCoordinator) -> AddReportPresenter {
        return define(
            scope: .prototype,
            init: AddReportViewPresenter(
                view: view,
                coordinator: coordinator,
                coreDataService: self.serviceAssembly.storageService,
                moodFormatter: self.formatterAssembly.moodUIFormatter
            )
        )
    }
}

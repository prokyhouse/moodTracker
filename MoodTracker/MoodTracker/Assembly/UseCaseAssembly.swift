//
//  UseCaseAssembly.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Foundation
import Domain

public final class UseCaseAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    // MARK: - Public Properties

    public var statisticsUseCase: StatisticsUseCase {
        define(
            scope: .lazySingleton,
            init: StatisticsUseCase(storageService: self.serviceAssembly.storageService)
        )
    }
}

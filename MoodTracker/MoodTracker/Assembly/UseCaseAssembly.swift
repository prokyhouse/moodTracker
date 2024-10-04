//
//  UseCaseAssembly.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Foundation

public final class UseCaseAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    // MARK: - Public Properties

//    public var sessionUseCase: Domain.SessionUseCase {
//        define(
//            scope: .lazySingleton,
//            init: SessionUseCaseImpl(
//                sessionService: self.serviceAssembly.sessionService
//            )
//        )
//    }

}

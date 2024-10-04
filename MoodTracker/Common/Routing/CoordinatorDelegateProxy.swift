//
//  CoordinatorDelegateProxy.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Foundation

final class CoordinatorDelegateProxy {
    weak var originalDelegate: CoordinatorDelegate?
}

// MARK: CoordinatorDelegate

extension CoordinatorDelegateProxy: CoordinatorDelegate {
    func coordinatorDidClose(_ coordinator: some Coordinator) {
        originalDelegate?.coordinatorDidClose(coordinator)
    }
}

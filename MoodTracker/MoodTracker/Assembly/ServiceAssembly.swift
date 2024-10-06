//
//  ServiceAssembly.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Common
import Foundation
import Storage

public final class ServiceAssembly: Assembly {
    // MARK: Public Properties

    public var storageService: CoreDataService {
        define(
            scope: .lazySingleton,
            init: CoreDataService()
        )
    }
}

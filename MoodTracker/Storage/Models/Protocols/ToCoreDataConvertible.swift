//
//  ToCoreDataConvertible.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import CoreData
import Foundation

public protocol ToCoreDataConvertible {
    associatedtype ConvertibleType

    func coreDataObject(in context: NSManagedObjectContext) -> ConvertibleType
}

public extension ToCoreDataConvertible {
    @discardableResult
    func storeEntity() -> ConvertibleType {
        let context = CoreDataService.shared.mainContext
        let expectedEntity = self.coreDataObject(in: context)
        return expectedEntity
    }
}

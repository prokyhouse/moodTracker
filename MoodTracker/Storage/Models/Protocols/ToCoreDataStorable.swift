//
//  ToCoreDataStorable.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import CoreData
import Foundation

public protocol ToCoreDataStorable: ToCoreDataConvertible {
    func createAndStoreDataObject(in context: NSManagedObjectContext) throws -> ConvertibleType
}

public extension ToCoreDataStorable {
    func createAndStoreDataObject(in context: NSManagedObjectContext) throws -> ConvertibleType {
        let result = self.coreDataObject(in: context)
        do {
            try context.save()
        } catch {
            debugPrint("🗄 Could not save '\(ConvertibleType.self)'")
            throw error
        }
        return result
    }
}

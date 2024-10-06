//
//  MoodNote+CoreDataProperties.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 05.10.2024.
//
//

import Foundation
import CoreData


extension MoodNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoodNote> {
        return NSFetchRequest<MoodNote>(entityName: "MoodNote")
    }

    @NSManaged public var id: UUID
    @NSManaged public var moodLevel: Int
    @NSManaged public var createDate: Date
    @NSManaged public var editDate: Date?
}

extension MoodNote : Identifiable {
}

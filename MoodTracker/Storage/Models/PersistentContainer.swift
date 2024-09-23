//
//  PersistentContainer.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import CoreData
import Foundation

class PersistentContainer: NSPersistentContainer {
    override class func defaultDirectoryURL() -> URL {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let url = urls[urls.count - 1]
        return url
    }
}

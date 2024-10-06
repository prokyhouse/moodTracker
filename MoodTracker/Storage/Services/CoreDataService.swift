//
//  CoreDataService.swift
//  MoodTracker
//
//  Created by Виталий Вишняков on 05.10.2024.
//

import CoreData

public final class CoreDataService {
    private enum Constants {
        static let PersistentContainerName = "MoodTracker"
        static let monthFilter = "createDate > %@"
        static let idFilter = "id == %@"
    }
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.PersistentContainerName)
        container.loadPersistentStores(completionHandler: { _, _ in })
        return container
    }()
    
    public init() {
        
    }
    
    // Стягиваем всегда последний месяц, забираем последние 7 записей если нужна неделя
    public func fetchLastMonthNotes() -> [MoodNote] {
        let request = MoodNote.fetchRequest()
        if let monthAgoDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) as? NSDate {
            request.predicate = NSPredicate(format: Constants.monthFilter, monthAgoDate)
        }
       
        if let notes = try? persistentContainer.viewContext.fetch(request) {
            return notes
        }
        
        return []
    }
    
    public func addMoodNote(moodLevel: Int) {
        let newMoodNote = MoodNote(context: persistentContainer.viewContext)
        newMoodNote.id = UUID()
        newMoodNote.createDate = Date()
        newMoodNote.moodLevel = moodLevel
        
        saveContext()
    }
    
    public func deleteMoodNote(id: UUID) {
        let request = MoodNote.fetchRequest()
        request.predicate = NSPredicate(format: Constants.idFilter, id as NSUUID)
        if let note = try? persistentContainer.viewContext.fetch(request).first {
            persistentContainer.viewContext.delete(note)
            saveContext()
        }
    }
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch { }
        }
    }
}

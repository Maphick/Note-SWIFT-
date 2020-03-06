//
//  SaveNoteDBOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation
import CoreData

class SaveNoteDBOperation: BaseDBOperation {
    
    // MARK: - Properties
    var result: Bool? = false
    private let note: Note
    var backgroundContext: NSManagedObjectContext!
    var fetchRequest: NSFetchRequest<NoteBD>?
    
    
    // MARK: - Methods
    init(note: Note, notebook: FileNotebook, modelName: String) {
        self.note = note
        super.init(notebook: notebook, modelName: modelName)
        self.backgroundContext = dataController.backgroundContext
    }
    
    override func main() {
        self.notebook.add(note)
        
        self.fetchRequest = NoteBD.fetchRequest()
        
        if let fetchRequest = self.fetchRequest {
            fetchRequest.predicate = NSPredicate(format: "uid == %@", self.note.uid)
            self.backgroundContext.performAndWait {
                let noteDB = try? self.backgroundContext.fetch(fetchRequest).first
                if noteDB == nil {
                    let newNoteDB = NoteBD(context: self.backgroundContext)
                    newNoteDB.uid = self.note.uid
                    newNoteDB.title = self.note.title
                    newNoteDB.content = self.note.content
                    newNoteDB.color = self.note.color.hexValue
                    newNoteDB.importance = self.note.importance.rawValue
                    newNoteDB.selfDestructionDate = self.note.selfDestructionDate
                    newNoteDB.lastEditedDate = self.note.lastEditedDate
                } else {
//                    let noteUpdate = noteDB! as NSManagedObject
                    noteDB!.setValue(self.note.uid, forKey: "uid") //.uid = self.note.uid
                    noteDB!.setValue(self.note.title, forKey: "title") //.title = self.note.title
                    noteDB!.setValue(self.note.content, forKey: "content") //.content = self.note.content
                    noteDB!.setValue(self.note.color.hexValue, forKey: "color") //.color = self.note.color.hexValue
                    noteDB!.setValue(self.note.importance.rawValue, forKey: "importance") //.importance = self.note.importance.rawValue
                    noteDB!.setValue(self.note.selfDestructionDate, forKey: "selfDestructionDate") //.selfDestructionDate = self.note.selfDestructionDate
                    noteDB!.setValue(self.note.lastEditedDate, forKey: "lastEditedDate") //.lastEditedDate = self.note.lastEditedDate
                }
                if self.backgroundContext.hasChanges {
                    do {
                        try self.backgroundContext.save()
                        self.result = true
                    } catch let error as NSError {
                        fatalError("Error: \(error.localizedDescription)\nCould not save Core Data context.")
                    }
                }
            }
        }
        
        finish()
    }
    
}

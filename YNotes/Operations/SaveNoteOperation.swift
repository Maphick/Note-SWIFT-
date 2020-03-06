//
//  SaveNoteOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

class SaveNoteOperation: AsyncOperation {
    
    // MARK: - Properties
    private let saveToDb: SaveNoteDBOperation
    private let dbQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    
    // MARK: - Methods
    init(note: Note,
         notebook: FileNotebook,
         modelName: String,
         dbQueue: OperationQueue,
         backendQueue: OperationQueue) {
        
        self.saveToDb = SaveNoteDBOperation(note: note, notebook: notebook, modelName: modelName)
        self.dbQueue = dbQueue
        
        super.init()
        
        self.saveToDb.completionBlock = {
            if self.saveToDb.result! {
                self.result = self.saveToDb.result
//                let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
//                saveToBackend.completionBlock = {
//                    switch saveToBackend.result! {
//                    case .success:
//                        self.result = true
//                    case .failure:
//                        self.result = false
//                    }
//                    
//                    self.finish()
//                }
//                backendQueue.addOperation(saveToBackend)
            }
            self.finish()
        }
    }
    
    override func main() {
        self.dbQueue.addOperation(saveToDb)
    }
}

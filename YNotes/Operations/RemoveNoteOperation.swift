//
//  RemoveNoteOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation {
    
    // MARK: - Properties
    private let removeNoteFromDB: RemoveNoteDBOperation
    private let dbQueue: OperationQueue
    private(set) var result: Bool? = false
    
    
    // MARK: - Methods
    init(uid: String,
         notebook: FileNotebook,
         modelName: String,
         dbQueue: OperationQueue,
         backendQueue: OperationQueue) {
        
        self.removeNoteFromDB = RemoveNoteDBOperation(uid: uid, notebook: notebook, modelName: modelName)
        self.dbQueue = dbQueue
        
        super.init()
        
        self.removeNoteFromDB.completionBlock = {
            self.result = self.removeNoteFromDB.result
//            let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
//            saveToBackend.completionBlock = {
//                switch saveToBackend.result! {
//                case .success:
//                    self.result = true
//                case .failure:
//                    self.result = false
//                }
                self.finish()
//            }
//            backendQueue.addOperation(saveToBackend)
        }
    }
    
    override func main() {
        self.dbQueue.addOperation(self.removeNoteFromDB)
    }
    
}

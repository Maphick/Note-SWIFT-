//
//  LoadNoteOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation {
    
    // MARK: - Properties
    private let loadFromDB: LoadNotesDBOperation
    private let loadFromBackend: LoadNotesBackendOperation
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    private let notebook: FileNotebook
//    var resultNotes: [String:Note]?
    private(set) var result: Bool? = false
    
    
    // MARK: - Methods
    init(notebook: FileNotebook,
         modelName: String,
         dbQueue: OperationQueue,
         backendQueue: OperationQueue) {
        
        self.notebook = notebook
        
        self.loadFromDB = LoadNotesDBOperation(notebook: notebook, modelName: modelName)
        self.dbQueue = dbQueue
        
        self.loadFromBackend = LoadNotesBackendOperation(notebook: notebook)
        self.backendQueue = backendQueue
        
        super.init()
        
//        self.addDependency(self.loadFromDB)
//        self.loadFromDB.addDependency(self.loadFromBackend)
        
//        self.dbQueue.addOperation(self.loadFromDB)
//        self.backendQueue.addOperation(self.loadFromBackend)
        
        self.loadFromDB.completionBlock =  {
            if self.loadFromDB.result! {
                self.result = self.loadFromDB.result
                //            switch self.loadFromBackend.result! {
                //                    case .success:
                //                        self.result = true
                //                    case .failure:
                //                        self.result = false
                //                    }
            }
            self.finish()
        }
    }
    
    override func main() {
        self.dbQueue.addOperation(self.loadFromDB)
    }

}


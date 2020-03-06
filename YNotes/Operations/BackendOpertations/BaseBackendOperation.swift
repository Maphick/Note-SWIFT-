//
//  BaseBackendOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case unreachable
    case badAuth
    
    static func message(funcName: String, info: String) {
        logError("Error preparing JSON notes ] [ func: \(funcName) ] [ Info: \(info)" )
    }
}

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

enum LoadNotesBackendResult {
    case success
    case failure(NetworkError)
}

enum AuthOperationResult {
    case success
    case failure(NetworkError)
}

class BaseBackendOperation: AsyncOperation {
    override init() {
        super.init()
    }
}

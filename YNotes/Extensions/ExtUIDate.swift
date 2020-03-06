//
//  ExtUIDate.swift
//  YNotes
//
//  Created by Dzhek on 19/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

extension Date {
    
    func asString(format: String = "EEEE, MMM d, yyyy HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

//
//  ExtUILabel.swift
//  HelloUser_4_1
//
//  Created by Dzhek on 15/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

extension UILabel {
    func setStyle(font: UIFont = UIFont.boldSystemFont(ofSize: 16),
                  lines: Int = 0) {
        self.textColor = UIColor.darkGray
        self.font = font
        self.numberOfLines = lines
    }
    
    func setTitleStyle(font: UIFont = UIFont.boldSystemFont(ofSize: 16),
                       lines: Int = 2) {
        self.textColor = UIColor.darkGray
        self.font = font
        self.numberOfLines = lines
    }
    
    func setContentStyle(font: UIFont = UIFont.systemFont(ofSize: 15),
                         lines: Int = 5) {
        self.textColor = UIColor.darkGray
        self.font = font
        self.numberOfLines = lines
    }
    
    func setInfoStyle(font: UIFont = UIFont.boldSystemFont(ofSize: 14),
                      lines: Int = 1) {
        self.font = font
        self.numberOfLines = lines
    }
    
    func setDestroyDateStyle(font: UIFont = UIFont.boldSystemFont(ofSize: 12),
                             lines: Int = 1) {
        self.textColor = UIColor(hex: "800000")
        self.font = font
        self.numberOfLines = lines
    }
    
}

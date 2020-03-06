//
//  ExtUITextField.swift
//  HelloUser_4_1
//
//  Created by Dzhek on 15/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

extension UITextField {
    
    func configure(color: UIColor = #colorLiteral(red: 0.1411764706, green: 0.1607843137, blue: 0.1803921569, alpha: 1),
                   font: UIFont = UIFont.boldSystemFont(ofSize: 16),
                   cornerRadius: CGFloat = 8,
                   borderColor: UIColor? = #colorLiteral(red: 0.2509803922, green: 0.2666666667, blue: 0.2823529412, alpha: 1),
                   backgroundColor: UIColor = .white,
                   borderWidth: CGFloat? = nil) {
        if let borderWidth = borderWidth {
            self.layer.borderWidth = borderWidth
        }
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        self.layer.cornerRadius = cornerRadius
        self.font = font
        self.textColor = color
        self.backgroundColor = backgroundColor
    }
}

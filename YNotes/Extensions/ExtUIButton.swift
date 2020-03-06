//
//  UIButton.swift
//  HelloUser_4_1
//
//  Created by Dzhek on 15/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

extension UIButton {

    func setStyle(color: UIColor = UIColor(hex: "1E90FF"),
                   font: UIFont = UIFont.boldSystemFont(ofSize: 16)) {
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 8.0
    }

}

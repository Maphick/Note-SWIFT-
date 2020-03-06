//
//  Check.swift
//  Notes
//
//  Created by Dzhek on 11/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

final class Check: UIView {

    override func draw(_ frame: CGRect) {
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 24, height: 24))
        UIColor.red.setFill()
        ovalPath.fill()

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 5.5, y: 10.5))
        bezierPath.addLine(to: CGPoint(x: 11.5, y: 17.5))
        bezierPath.addLine(to: CGPoint(x: 17.5, y: 4.5))
        UIColor.white.setStroke()
        bezierPath.lineWidth = 2
        bezierPath.stroke()
        
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

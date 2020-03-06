//
//  SquareView.swift
//  Notes
//
//  Created by Dzhek on 11/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

final class SquareView: UIView {

    private let bColor = UIColor(hex: "09101B").cgColor
    private let bWidth: CGFloat = 1.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = bWidth
        self.layer.borderColor = bColor
    }
    
    func setGradientBackground() {
        let rainbowLayer = CAGradientLayer()
        rainbowLayer.frame = bounds
        rainbowLayer.colors = [Rainbow.red.rawValue, Rainbow.orange.rawValue, Rainbow.yellow.rawValue, Rainbow.green.rawValue, Rainbow.cyan.rawValue, Rainbow.blue.rawValue, Rainbow.purple.rawValue]
        rainbowLayer.locations = [0.0, 0.2, 0.4, 0.5, 0.6, 0.8, 1.0]
        rainbowLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        rainbowLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        let bwLayer = CAGradientLayer()
        bwLayer.frame = bounds
        bwLayer.colors = [Rainbow.black, Rainbow.white]
        bwLayer.locations = [0.0, 1.0]
        bwLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        bwLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        bwLayer.compositingFilter = "multiplyBlendMode"
        
        layer.insertSublayer(rainbowLayer, at: 0)
        layer.insertSublayer(bwLayer, at: 1)
    }
    
}

enum Rainbow: CaseIterable {
    
    case red
    case orange
    case yellow
    case green
    case cyan
    case blue
    case purple
    
    static let black = UIColor(hex: "00", alpha: 0.8).cgColor
    static let white = UIColor(hex: "FF", alpha: 0.5).cgColor
}

extension Rainbow: RawRepresentable {
    typealias RawValue = CGColor
    
    var rawValue: RawValue {
        switch self {
        case .red: return UIColor.red.cgColor
        case .orange: return UIColor.orange.cgColor
        case .yellow: return UIColor.yellow.cgColor
        case .green: return UIColor.green.cgColor
        case .cyan: return UIColor.cyan.cgColor
        case .blue: return UIColor.blue.cgColor
        case .purple: return UIColor.purple.cgColor
        }
    }
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case UIColor.red.cgColor: self = .red
        case UIColor.orange.cgColor: self = .orange
        case UIColor.yellow.cgColor: self = .yellow
        case UIColor.green.cgColor: self = .green
        case UIColor.cyan.cgColor: self = .cyan
        case UIColor.blue.cgColor: self = .blue
        case UIColor.purple.cgColor: self = .purple
        default: return nil
        }
    }
}

//
//  UIColorExtension.swift
//  Notes
//
//  Created by Dzhek on 11/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

extension UIColor {
    
//    So here it is how to read the red, green blue slash hue saturation brightness and alpha components
//    from a UIColor. With this little neat extension you can simply get the component values and use them
//    hrough their proper names:
//    UIColor.yellow.rgba.red
//    UIColor.yellow.hsba.hue
    
    public var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
    public var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h, s, b, a)
    }
    
    
//    As you can see I've tried to replicate the behavior of the CSS rules,
//    so you will have the freedom of less characters if a hext string is like #ffffff
//    (you can use just f, because # is optional). Also you can provide integers as well,
//    that's just a simple "overloaded" convenience init method.
//    Here is how you can use it with multiple input variations:
//    let colors = [
//        UIColor(hex: "#cafe00"),
//        UIColor(hex: "cafe00"),
//        UIColor(hex: "c"),
//        UIColor(hex: "ca"),
//        UIColor(hex: "caf"),
//        UIColor(hex: 0xcafe00),
//    ]
//    let values = colors.map { $0.hexValue }
//    print(values) //["#CAFE00", "#CAFE00", "#CCCCCC", "#CACACA", "#CCAAFF", "#CAFE00"]
    
    public convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(hex string: String, alpha: CGFloat = 1.0) {
        var hex = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        
        if hex.count < 3 {
            hex = "\(hex)\(hex)\(hex)"
        }
        
        if hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil {
            if hex.count == 3 {
                
                let startIndex = hex.index(hex.startIndex, offsetBy: 1)
                let endIndex = hex.index(hex.startIndex, offsetBy: 2)
                
                let redHex = String(hex[..<startIndex])
                let greenHex = String(hex[startIndex..<endIndex])
                let blueHex = String(hex[endIndex...])
                
                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }
            
            let startIndex = hex.index(hex.startIndex, offsetBy: 2)
            let endIndex = hex.index(hex.startIndex, offsetBy: 4)
            let redHex = String(hex[..<startIndex])
            let greenHex = String(hex[startIndex..<endIndex])
            let blueHex = String(hex[endIndex...])
            
            var redInt: CUnsignedInt = 0
            var greenInt: CUnsignedInt = 0
            var blueInt: CUnsignedInt = 0
            
            Scanner(string: redHex).scanHexInt32(&redInt)
            Scanner(string: greenHex).scanHexInt32(&greenInt)
            Scanner(string: blueHex).scanHexInt32(&blueInt)
            
            self.init(red: CGFloat(redInt) / 255.0,
                      green: CGFloat(greenInt) / 255.0,
                      blue: CGFloat(blueInt) / 255.0,
                      alpha: CGFloat(alpha))
        }
        else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
    
    var hexValue: String {
        var color = self
        
        if color.cgColor.numberOfComponents < 4 {
            let c = color.cgColor.components!
            color = UIColor(red: c[0], green: c[0], blue: c[0], alpha: c[1])
        }
        if color.cgColor.colorSpace!.model != .rgb {
            return "#FFFFFF"
        }
        let c = color.cgColor.components!
        return String(format: "#%02X%02X%02X", Int(c[0]*255.0), Int(c[1]*255.0), Int(c[2]*255.0))
    }
    
    
//    generate a random UIColor
    
    public static var random: UIColor {
//        let red = CGFloat.random(in: 0...1)
//        let green = CGFloat.random(in: 0...1)
//        let blue = CGFloat.random(in: 0...1)
//        let alpha = CGFloat(1.0)
        
//        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        let color: [UIColor] = [UIColor.white, UIColor(hex: "4066ea"), UIColor(hex: "ffc71c"), UIColor(hex: "17d0bc")]
        let i: Int = Int.random(in: 0 ..< color.count)
        
        return color[i]
    }
}

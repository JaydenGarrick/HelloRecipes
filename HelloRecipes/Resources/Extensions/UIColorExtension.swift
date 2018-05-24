//
//  UIColorExtension.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 5/15/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

extension UIColor {
    
    typealias UIColorCombo = (primary: UIColor, secondary: UIColor)
    
    /// Function that allows your to avoid typing /255 each time you use RGB
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    /// Returns darkGreen from Assets
    static func darkGreen() -> UIColor {
        return UIColor(named: "DarkGreen") ?? .red
    }
    
    /// Returns lightGreen from Assets
    static func lightGreen() -> UIColor {
        return UIColor(named: "LightGreen") ?? .red
    }
    
    /// Returns offGreen from Assets
    static func offGreen() -> UIColor {
        return UIColor(named: "OffGreen") ?? .red
    }
    
    /// Returns darkYellow from Assets
    static func darkYellow() -> UIColor {
        return UIColor(named: "DarkYellow") ?? .red
    }
    
    /// Returns lightYellow from Assets
    static func lightYellow() -> UIColor {
        return UIColor(named: "LightYellow") ?? .red
    }
    
    /// Returns darkPeach from Assets
    static func darkPeach() -> UIColor {
        return UIColor(named: "DarkPeach") ?? .red
    }
    
    /// Returns lightPeach from Assets
    static func lightPeach() -> UIColor {
        return UIColor(named: "LightPeach") ?? .red
    }
    
    /// Returns offPeach from Assets
    static func offPeach() -> UIColor {
        return UIColor(named: "OffPeach") ?? .red
    }
    
    /// Returns darkBlue from Assets
    static func darkBlue() -> UIColor {
        return UIColor(named: "DarkBlue") ?? .red
    }
    
    /// Returns lightBlue color from Assets
    static func lightBlue() -> UIColor {
        return UIColor(named: "LightBlue") ?? .red
    }
    
    /// Function that will return a tuple of UI colors created in the Assets folder
    static func randomColorCombo() -> UIColorCombo {
        let colorArray = [
            UIColor.darkYellow(),
            UIColor.darkPeach(),
            UIColor.darkGreen(),
            UIColor.darkBlue()
        ]
        let randomIndex = Int(arc4random_uniform(UInt32(colorArray.count)))
        let randomPrimaryColor = colorArray[randomIndex]
        
        switch randomPrimaryColor {
        case UIColor.darkYellow():
            return (primary: UIColor.darkYellow(), secondary: UIColor.lightYellow())
        case UIColor.darkPeach():
            return (primary: UIColor.darkPeach(),secondary: UIColor.lightPeach())
        case UIColor.darkGreen():
            return (primary: UIColor.darkGreen(),secondary: UIColor.lightGreen())
        case UIColor.darkBlue():
            return (primary: UIColor.darkBlue(),secondary: UIColor.lightBlue())
        default:
            return (primary: UIColor.darkYellow(), secondary: UIColor.lightYellow())
        }
    }
    
    /// Variable on UIColor that holds a tuple of the 2 complimentary colors
    static var uiColors: (primary: UIColor, secondary: UIColor) = UIColor.randomColorCombo()
}

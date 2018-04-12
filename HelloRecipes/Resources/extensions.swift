//
//  extensions.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 3/24/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

extension Collection where Element == Ingredient {
    func toURLString() -> String {
        var urlString = ""
        for ingredient in self {
            let noSpaces = ingredient.ingredient
            urlString.append("\(noSpaces) ")
        }
        return urlString.replacingOccurrences(of: " ", with: "+").trimmingCharacters(in: CharacterSet.init(charactersIn: "+"))
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setupNavigationBarWith(viewController: UIViewController, primary: UIColor, secondary: UIColor) {
        viewController.navigationController?.navigationBar.barTintColor = secondary
        let shadow = NSShadow()
        shadow.shadowColor = primary
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        viewController.navigationController?.navigationItem.title = "Hello Recipes"
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,
                                                                   NSAttributedStringKey.shadow : shadow,
                                                                   NSAttributedStringKey.font : UIFont(name: "Devanagari Sangam MN", size: 25) as Any]
    }
}



extension UIColor {
    
    typealias UIColorCombo = (primary: UIColor, secondary: UIColor) 
    
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    // GREEN
    static func darkGreen() -> UIColor {
        return UIColor(named: "DarkGreen") ?? .red
    }
    
    static func lightGreen() -> UIColor {
        return UIColor(named: "LightGreen") ?? .red
    }
    
    static func offGreen() -> UIColor {
        return UIColor(named: "OffGreen") ?? .red
    }
    
    // YELLOW
    static func darkYellow() -> UIColor {
        return UIColor(named: "DarkYellow") ?? .red
    }
    
    static func lightYellow() -> UIColor {
        return UIColor(named: "LightYellow") ?? .red
    }
    
    // PEACH
    static func darkPeach() -> UIColor {
        return UIColor(named: "DarkPeach") ?? .red
    }
    
    static func lightPeach() -> UIColor {
        return UIColor(named: "LightPeach") ?? .red
    }
    
    static func offPeach() -> UIColor {
        return UIColor(named: "OffPeach") ?? .red
    }
    
    // BLUE
    static func darkBlue() -> UIColor {
        return UIColor(named: "DarkBlue") ?? .red
    }
    
    static func lightBlue() -> UIColor {
        return UIColor(named: "LightBlue") ?? .red
    }
    
    static func randomColorCombo() -> UIColorCombo {
        let colorArray = [UIColor.darkYellow(),
                          UIColor.darkPeach(),
                          UIColor.darkGreen(),
                          UIColor.darkBlue()]
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

    static var uiColors: (primary: UIColor, secondary: UIColor) = UIColor.randomColorCombo()
}

extension Notification.Name {
    static let selectedImage = NSNotification.Name("selectedImage")
}

extension NSAttributedString {
    static func stylizedTextWith(_ input: String, shadowColor: UIColor, shadowOffSet: CGFloat, mainTextColor: UIColor, textSize: CGFloat) -> NSAttributedString {
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = CGSize(width: shadowOffSet, height: shadowOffSet)
        let attributedText = NSMutableAttributedString(string: input, attributes: [NSAttributedStringKey.foregroundColor : mainTextColor,
                                                                                   NSAttributedStringKey.shadow : shadow,
                                                                                   NSAttributedStringKey.font : UIFont.init(name: "Devanagari Sangam MN", size: textSize) as Any])
        return attributedText
    }
}

extension UIViewController {
}













//
//  NSAttributeStringExtension.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 5/15/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

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


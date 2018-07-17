//
//  UIFontExtension.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 6/27/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

extension UIFont {
    static func signPainterFont(ofSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "SignPainterHouseScript", size: ofSize) else { fatalError("couldn't find custom font")}
        return font
    }
    
}

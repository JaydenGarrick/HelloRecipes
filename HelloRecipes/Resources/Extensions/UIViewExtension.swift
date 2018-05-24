//
//  UIViewExtension.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 5/15/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

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
        viewController.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.shadow : shadow,
            NSAttributedStringKey.font : UIFont(name: "Devanagari Sangam MN", size: 25) as Any
        ]
    }
}

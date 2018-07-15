//
//  ObjectSelectionCell.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 4/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class ObjectSelectionCell: UICollectionViewCell {
    
    var ingredient: String? {
        didSet {
            let ingredientWithQuestionMark = ingredient! + "?"
            objectLabel.attributedText = NSAttributedString.stylizedTextWith(ingredientWithQuestionMark, shadowColor: UIColor.uiColors.primary, shadowOffSet: 0, mainTextColor: UIColor.uiColors.primary, textSize: 20)
            self.backgroundColor = UIColor.uiColors.secondary
            self.layer.borderColor = UIColor.uiColors.primary.cgColor
        }
    }
    
    let objectLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        addSubview(objectLabel)
        clipsToBounds = false
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.borderColor = UIColor.uiColors.primary.cgColor
        backgroundColor = UIColor.uiColors.secondary
        
        objectLabel.translatesAutoresizingMaskIntoConstraints = false
        objectLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        objectLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        objectLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        let width = frame.width - 10
        objectLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
    }

}

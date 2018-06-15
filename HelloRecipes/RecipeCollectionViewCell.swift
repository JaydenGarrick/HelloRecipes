//
//  RecipeCollectionViewCell.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 4/3/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

protocol RecipeListCollectionViewCellDelegate : class {
    func imageViewTapped(_ sender: RecipeCollectionViewCell)
}

class RecipeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants/Variables
    var uiColors = UIColor.uiColors
    
    // Datasource
    var myRecipe: MyRecipie? {
        didSet {
            guard let urlString = myRecipe?.image else { return }
            
            seperatorView.backgroundColor = uiColors.primary
            ingredientsTextField.layer.borderColor = uiColors.primary.cgColor
            recipeNameLabel.shadowColor = uiColors.primary
            sourceLabel.shadowColor = uiColors.primary
            
            photoImageView.loadImage(urlString: urlString)
            recipeNameLabel.text = myRecipe?.label ?? ""
            sourceLabel.text = myRecipe?.source ?? ""
            
            guard let recipeString =  myRecipe?.ingredientLines?.joined(separator: "\n •   ") else { return }
            let shadow = NSShadow()
            shadow.shadowColor = uiColors.primary
            shadow.shadowOffset = CGSize(width: 0.5, height: 0.5)
            let attributedText = NSMutableAttributedString(string: "Ingredients: \n", attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.white,
                NSAttributedStringKey.shadow : shadow,
                NSAttributedStringKey.font : UIFont.init(name: "Devanagari Sangam MN", size: 35) as Any]
            )
            attributedText.append(NSAttributedString(string: "•    " + recipeString, attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.white,
                NSAttributedStringKey.shadow : shadow,
                NSAttributedStringKey.font : UIFont.init(name: "Devanagari Sangam MN", size: 16) as Any
                ]))
            ingredientsTextField.attributedText = attributedText
        }
    }
    
    // UI
    let photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1
        return imageView
    }()
        
    let imageHolderView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Name"
        label.minimumScaleFactor = 15
        label.font = UIFont.init(name: "Devanagari Sangam MN", size: 30)
        label.textColor = .white
        label.textAlignment = .center
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.numberOfLines = 0
        label.minimumScaleFactor = 15
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.text = "Source Name"
        label.font = UIFont.init(name: "Devanagari Sangam MN", size: 16)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 0.5, height: 0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let ingredientsTextField: UITextView = {
        let textView = UITextView()
        textView.clipsToBounds = true
        textView.isSelectable = false
        textView.backgroundColor = UIColor.clear
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.textColor = .white
        return textView
    }()
    
    // MARK: - Initialization Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    fileprivate func setupCellConstraints() {
        
        // Setup SuperView
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = uiColors.primary.cgColor
        clipsToBounds = true
        backgroundColor = uiColors.secondary
        
        // Add Subview
        addSubview(imageHolderView)
        addSubview(recipeNameLabel)
        addSubview(seperatorView)
        addSubview(sourceLabel)
        addSubview(ingredientsTextField)
        
        // Add Tap Gesture for imageView
        
        // Anchors
        imageHolderView.addSubview(photoImageView)
        photoImageView.anchor(top: imageHolderView.topAnchor, left: imageHolderView.leftAnchor, bottom: imageHolderView.bottomAnchor, right: imageHolderView.rightAnchor, paddingTop: -45, paddingLeft: -45, paddingBottom: 0, paddingRight: -45, width: 0, height: 0)
        imageHolderView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        imageHolderView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        recipeNameLabel.anchor(top: imageHolderView.bottomAnchor, left: leftAnchor, bottom: seperatorView.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 32)
        seperatorView.anchor(top: recipeNameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 1)
        sourceLabel.anchor(top: seperatorView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 18)
        ingredientsTextField.anchor(top: sourceLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 20, paddingBottom: 8, paddingRight: 20, width: 0, height: 200)
    }
    
}








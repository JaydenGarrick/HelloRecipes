//
//  IngredientListTableViewCell.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 3/24/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class IngredientListTableViewCell: UITableViewCell {
    
    // MARK: - Constants and Variables
    var uiColors = UIColor.uiColors
    var ingredient: Ingredient? {
        didSet {
            guard let ingredient = ingredient else { return }
            ingredientTextField.attributedText = NSAttributedString.stylizedTextWith(ingredient.ingredient, shadowColor: uiColors.primary, shadowOffSet: 1, mainTextColor: UIColor.white, textSize: 16)
            setupShadowView()
        }
    }
    
    // IBOutlets
    @IBOutlet weak var backgroundShadowView: UIView! {
        didSet {
            backgroundShadowView.backgroundColor = uiColors.secondary
        }
    }
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var checkLabel: UILabel! {
        didSet {
            checkLabel.textColor = uiColors.primary
        }
    }
    
    // MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        ingredientTextField.delegate = self
        setupLongPressGesture()
    }
    
    // MARK: - SetupFunctions
    fileprivate func setupShadowView() {
        checkLabel.textColor = uiColors.primary
        backgroundShadowView.backgroundColor = uiColors.secondary
        backgroundShadowView.layer.cornerRadius = 3.0
        backgroundShadowView.layer.masksToBounds = false
        backgroundShadowView.layer.borderWidth = 0.75
        backgroundShadowView.layer.borderColor = uiColors.primary.cgColor
    }
    
    fileprivate func setupLongPressGesture() {
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress() {
        ingredientTextField.isUserInteractionEnabled = true
        ingredientTextField.becomeFirstResponder()
    }
    
}

// MARK: - UITextFieldDelegate Methods
extension IngredientListTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let ingredient = ingredient else { return }
        IngredientController.shared.edit(ingredient: ingredient, ingredientString: textField.text ?? "")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let ingredient = ingredient else { return }
        textField.textColor = uiColors.primary
        textField.tintColor = uiColors.primary
        textField.attributedText = NSAttributedString.stylizedTextWith(ingredient.ingredient, shadowColor: uiColors.primary, shadowOffSet: 1, mainTextColor: UIColor.white, textSize: 16)
    }
    
}








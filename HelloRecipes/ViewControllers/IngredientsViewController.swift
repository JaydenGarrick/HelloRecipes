//
//  IngredientsViewController.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 3/24/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController {

    // MARK: - IBOutlets / Constants and Variables
    var uiColors = UIColor.uiColors
    let addRecipeRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(didPullForNewRecipe), for: .valueChanged)
        return refreshControl
    }()
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var doneFindingIngredientsLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet var listView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ingredientsStatementLabel: UILabel!
    @IBOutlet var doneFindingIngredientsButton: UIButton! {
        didSet {
            doneFindingIngredientsButton.setAttributedTitle(NSAttributedString.stylizedTextWith("Find Recipes!", shadowColor: uiColors.secondary, shadowOffSet: 1, mainTextColor: uiColors.primary, textSize: 17), for: .normal)
            doneFindingIngredientsButton.addTarget(self, action: #selector(handleDoneFindingIngredients), for: .touchUpInside)
        }
    }
    
    var labelFontSize: CGFloat = 17
    let plusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.contentMode = .center
        label.textColor = UIColor.uiColors.primary
        label.backgroundColor = .clear
        label.clipsToBounds = false
        label.layer.opacity = 0
        label.textAlignment = .center
        return label
    }()
    
    let noIngredientsLabel: UILabel = {
        let noIngredientsLabel = UILabel()
        noIngredientsLabel.attributedText = NSAttributedString.stylizedTextWith(
            "You currently have 0 ingredients gathered. \n Pull, Scan, Snap, or Tap to add more Ingredients!",
            shadowColor: UIColor.uiColors.primary,
            shadowOffSet: 1, mainTextColor: .white,
            textSize: 15
        )
        noIngredientsLabel.minimumScaleFactor = 15
        noIngredientsLabel.textAlignment = .center
        noIngredientsLabel.numberOfLines = 0
        noIngredientsLabel.layer.cornerRadius = 5
        noIngredientsLabel.layer.borderWidth = 1
        noIngredientsLabel.layer.borderColor = UIColor.uiColors.primary.cgColor
        return noIngredientsLabel
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupGesture()
        setupListView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollToBottom {}
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\n  🍋🥑🥕INGREDIENTS🥕🥑🍋 \n")
        IngredientController.shared.ingredients.forEach { $0.ingredient == "" ? IngredientController.shared.remove(ingredient: $0) : print("● \($0.ingredient)")}
    }
    
    // MARK: - SetupFunctions
    fileprivate func setupListView() {
        tableView.addSubview(addRecipeRefreshControl)
        listView.layer.borderColor = uiColors.primary.cgColor
        listView.layer.borderWidth = 1
        listView.layer.cornerRadius = 8
        listView.clipsToBounds = true
    }
    
    fileprivate func setupGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
    }
    
    fileprivate func setupAnimationForPullToRefresh() {
        // Slight Vibration
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        var rotationAndPerspectiveTransform = CATransform3DIdentity
        rotationAndPerspectiveTransform.m34 = 1.0 / -800.0
        rotationAndPerspectiveTransform = CATransform3DMakeRotation(.pi, 1, 0, 0)
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.plusLabel.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.plusLabel.layer.transform = rotationAndPerspectiveTransform
            self.plusLabel.attributedText = NSAttributedString.stylizedTextWith("Release to Add New Ingredient", shadowColor: self.uiColors.primary, shadowOffSet: 1, mainTextColor: .white, textSize: self.labelFontSize)
        })
    }
    
    /// Sets up the UI
    fileprivate func setupUI() {
        
        // Setup Custom RefreshControl
        addRecipeRefreshControl.addSubview(plusLabel)
        plusLabel.attributedText = NSAttributedString.stylizedTextWith("Pull to Add New Ingredient", shadowColor: UIColor.uiColors.primary, shadowOffSet: 1, mainTextColor: .white, textSize: CGFloat(labelFontSize))
        plusLabel.anchor(top: addRecipeRefreshControl.topAnchor, left: addRecipeRefreshControl.leftAnchor, bottom: nil, right: addRecipeRefreshControl.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: listView.frame.width, height: addRecipeRefreshControl.frame.height)
        
        // Set navigation Bar
        view.setupNavigationBarWith(viewController: self, primary: uiColors.primary, secondary: uiColors.secondary)
        
        // Setup UIElements
        ingredientsStatementLabel.attributedText = NSAttributedString.stylizedTextWith("Ingredients:", shadowColor: uiColors.primary, shadowOffSet: 1, mainTextColor: .white, textSize: 20)
        doneFindingIngredientsLabel.attributedText = NSAttributedString.stylizedTextWith("Done gathering ingredients?", shadowColor: uiColors.primary, shadowOffSet: 0.75, mainTextColor: .white, textSize: 17)
        doneFindingIngredientsButton.setTitleColor(uiColors.primary, for: .normal)
        
        // Setup View
        topView.backgroundColor = uiColors.secondary
        bottomView.backgroundColor = uiColors.secondary
        view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = uiColors.secondary
        listView.backgroundColor = uiColors.secondary
        tableView.backgroundColor = uiColors.secondary
        
        if IngredientController.shared.ingredients.isEmpty {
            doneFindingIngredientsButton.isHidden = true
            doneFindingIngredientsLabel.isHidden = true
        }
    }
    
    // MARK: - Action Functions
    @objc fileprivate func didPullForNewRecipe() {
        
        // Animate the pull to refresh
        setupAnimationForPullToRefresh()
        
        // Cancel Refreshing
        addRecipeRefreshControl.endRefreshing()
        
        // Set on timer because bounce was offsetting scrolling to the bottom
        if IngredientController.shared.ingredients.count > 1 { // Check to see if there's any ingredients already. if there is, scroll to bottom.
            scrollToBottom { [weak self] in
                self?.addNewIngredientOnRefresh()
                self?.doneFindingIngredientsButton.isHidden = false
                self?.doneFindingIngredientsLabel.isHidden = false
            }
        } else {
            doneFindingIngredientsButton.isHidden = false
            doneFindingIngredientsLabel.isHidden = false
            addNewIngredientOnRefresh()
        }
    }
    
    fileprivate func addNewIngredientOnRefresh() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { (_) in // On Timer to offset bounce interfereing with cell
            IngredientController.shared.add(ingredient: "")
            self.tableView.reloadData()
            let cell = self.tableView.visibleCells.last as! IngredientListTableViewCell
            cell.handleLongPress()
        }
    }
    
    @objc fileprivate func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleDoneFindingIngredients() {
        performSegue(withIdentifier: "toRecipes", sender: self)
    }
    
    /// Scrolls the TableView to the bottom of the ScrollView
    func scrollToBottom(completion: @escaping() -> Void){
        if IngredientController.shared.ingredients.count > 1 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: IngredientController.shared.ingredients.count-1, section: 0)
                UIView.animate(withDuration: 0.25, animations: {
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }, completion: { (success) in
                    if success {
                        completion()
                    }
                })
            }
        }
    }
    
}

// MARK: - UITableViewDelete and Datasource methods
extension IngredientsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IngredientController.shared.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! IngredientListTableViewCell
        let ingredient = IngredientController.shared.ingredients[indexPath.row]
        cell.ingredient = ingredient
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let ingredient = IngredientController.shared.ingredients[indexPath.row]
        
        // Generator so user feels slight vibration when swiping
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        // Action that deletes the ingredient from datasource
        let deleteIngredientAction = UIContextualAction(style: .normal, title: "Remove Ingredient") { [weak self](action, view, nil) in
            IngredientController.shared.remove(ingredient: ingredient)
            self?.tableView.reloadData()
        }
        deleteIngredientAction.backgroundColor = uiColors.primary
        let configuration = UISwipeActionsConfiguration(actions: [deleteIngredientAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if IngredientController.shared.ingredients.count == 0 {
            // Setup headerView
            let headerView = UIView()
            headerView.backgroundColor = .clear
            // Constraints
            headerView.addSubview(noIngredientsLabel)
            noIngredientsLabel.anchor(top: headerView.topAnchor, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: headerView.bounds.width - 8, height: headerView.bounds.height - 8)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if IngredientController.shared.ingredients.isEmpty {
            return 125
        } else { return 0 }
    }
    
}

// MARK: - ScrollView Functions
extension IngredientsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 0 {
            UIView.animate(withDuration: 0.25) {
                self.ingredientsStatementLabel.layer.opacity = 1
                self.plusLabel.layer.opacity = 0
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.ingredientsStatementLabel.layer.opacity = 0
                self.plusLabel.layer.opacity = 1
            }

        }
    }
}






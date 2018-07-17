//
//  RecipeListCollectionViewController.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 4/3/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class RecipeListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Constants / Variables
    var uiColors = UIColor.uiColors
    fileprivate let cellID = "cellID"
    var recipes = [MyRecipie]() {
        didSet {
            if recipes.count == 0 {
                DispatchQueue.main.async {
                    self.presentBadQueryAlert()
                }
            }
        }
    }
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.uiColors.primary
        return view
    }()
    
    let activityIndicatior: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.tintColor = UIColor.uiColors.primary
        activityIndicator.color = UIColor.uiColors.primary
        return activityIndicator
    }()
    
    // MARK: - ViewLifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        addConstraints()
        initialFetch()
        setupNavigationBar()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupActivityIndicatorWhenAppeared()
    }
    
    // MARK: - Setup Functions
    fileprivate func setupActivityIndicatorWhenAppeared() {
        if recipes.count > 0 {
            activityIndicatior.stopAnimating()
            activityIndicatior.isHidden = true
        }
    }
    
    fileprivate func addConstraints() {
        view.addSubview(seperatorView)
        view.addSubview(activityIndicatior)
        seperatorView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        activityIndicatior.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatior.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatior.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatior.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatior.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func initialFetch() {
        RecipeController.fetchRecipes(with: IngredientController.shared.ingredients) { [weak self](fetchedRecipes) in
            guard let fetchedRecipes = fetchedRecipes else { return }
            self?.recipes = fetchedRecipes
            DispatchQueue.main.async {
                self?.activityIndicatior.isHidden = true
                self?.collectionView?.reloadData()
            }
        }
    }
    
    fileprivate func setupNavigationBar() {
        view.setupNavigationBarWith(viewController: self, primary: UIColor.uiColors.primary, secondary: UIColor.uiColors.secondary)
        navigationController?.navigationBar.tintColor = UIColor.uiColors.primary
        navigationController?.navigationBar.backItem?.backBarButtonItem?.title = ""
    }
    
    fileprivate func setupCollectionView() {
        collectionView?.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView?.collectionViewLayout = layout
    }
    
}

// MARK: - CollectionView Delegate and Datasourcec Functions
extension RecipeListCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! RecipeCollectionViewCell
        let recipe = recipes[indexPath.row]
        cell.myRecipe = recipe
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let navigationBarHeight = navigationController?.navigationBar.frame.height else { print("⚠️Can't Find NavigationBar Height") ; return CGSize.init(width: view.frame.width - 10, height: view.frame.height - 30) }
        let height: CGFloat = view.frame.height - navigationBarHeight - 40
        
        return CGSize(width: view.frame.width - 10, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 2, bottom: 2, right: 10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        guard let recipeUrl = recipe.url,
        let source = recipe.source else { return }
        let webViewController = WebViewController()
        webViewController.url = recipeUrl
        webViewController.source = source
        let navigationController = UINavigationController(rootViewController: webViewController)
        present(navigationController, animated: true)
    }
    
}

// MARK: - Cell Animation Functions
extension RecipeListCollectionViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            for cell in collectionView.visibleCells as! [RecipeCollectionViewCell] {
                let indexPath = collectionView.indexPath(for: cell)!
                let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
                let cellFrame = collectionView.convert(attributes.frame, to: view)
                let translationX = cellFrame.origin.x / 7
                cell.photoImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
                cell.layer.transform = animateCell(cellFrame: cellFrame)
            }
        }
    }
    
    func animateCell(cellFrame: CGRect) -> CATransform3D {
        let angleFromX = Double((-cellFrame.origin.x) / 16.5)
        let angle = CGFloat((angleFromX * Double.pi) / 180.0)
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/900
        let rotation = CATransform3DRotate(transform, angle, 0, 0.5, 0)
        
        var scaleFromX = (1000 - (cellFrame.origin.x - 200)) / 1000
        let scaleMax: CGFloat = 1.0
        let scaleMin: CGFloat = 0.5
        if scaleFromX > scaleMax {
            scaleFromX = scaleMax
        }
        if scaleFromX < scaleMin {
            scaleFromX = scaleMin
        }
        let scale = CATransform3DScale(CATransform3DIdentity, scaleFromX, scaleFromX, 1)
        return CATransform3DConcat(rotation, scale)
    }
    
}

// MARK: - Bad query alert
extension RecipeListCollectionViewController {
    func presentBadQueryAlert() {
        let alertController = UIAlertController(title: "Whoops.. 😅", message: "Couldn't find any recipes with those ingredients. Adjust your list and try again!", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.uiColors.primary
        let okayAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
}



//
//  ObjectSelectionViewController.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 4/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import AVKit
import Vision
import CoreML

final class ObjectSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Constants and Variables
    @IBOutlet weak var collectionView: UICollectionView!
    let cellID = "cellID"
    
    let tapOnImageLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.stylizedTextWith("Select an Image, and I'll guess what it is!", shadowColor: UIColor.uiColors.primary, shadowOffSet: 0.7, mainTextColor: .white, textSize: 22)
        label.backgroundColor = UIColor.uiColors.secondary
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 0.75
        label.layer.borderColor = UIColor.uiColors.primary.cgColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var selectedImage: UIImage? // Image that is being guessed on
    private(set) var guesses = [String]() // Datasource
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(handleImageTapped), name: .selectedImage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePhotoTapped), name: .photoButtonTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleColorChanged), name: .colorsChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnPhotoView), name: .onPhotoView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnPictureView), name: .onCameraView, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        guesses = [] // Clear out the guesses when the view dissapears
        tapOnImageLabel.isHidden = false
    }
    
    // MARK: - Setup Functions
    fileprivate func setupUI() {
        view.addSubview(tapOnImageLabel)
        tapOnImageLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
        if guesses.isEmpty {
            tapOnImageLabel.isHidden = false
        } else {
            tapOnImageLabel.isHidden = true
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ObjectSelectionCell.self, forCellWithReuseIdentifier: cellID)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Notification Functions
    @objc fileprivate func handleImageTapped(notification: Notification) {
        
        // Checking for image being tapped
        if let image = notification.userInfo?["image"] as? UIImage {
            selectedImage = image
        
            // Creating model for CoreML
            guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
            
            // Getting the request
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else { return }
                self.guesses = [] // Empty out the guess array
                results.forEach { self.guesses.append($0.identifier) } // For each guess the model makes, append the indentifier to the guess array
                DispatchQueue.main.async {
                    self.collectionView.reloadData() // Reload CollectionView
                    
                    // Scroll to beginning
                    let indexPath = IndexPath(item: 0, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: true)
                    self.setupUI()
                }
            }
            guard let ciImage = CIImage(image: selectedImage!) else { return }
            try? VNImageRequestHandler(ciImage: ciImage).perform([request])
        }
    }
    
    @objc fileprivate func handlePhotoTapped(notification: Notification) {
        if let guessesArray = notification.object as? [String] {
            self.guesses = guessesArray
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                let indexPath = IndexPath(item: 0, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: true)
                self.setupUI()
            }
        }
    }
    
    @objc fileprivate func handleColorChanged(notification: Notification) {
        collectionView.reloadData()
        tapOnImageLabel.attributedText = NSAttributedString.stylizedTextWith("Select a picture of your ingredient, and I'll guess what it is!", shadowColor: UIColor.uiColors.primary, shadowOffSet: 0, mainTextColor: UIColor.uiColors.primary, textSize: 22)
        tapOnImageLabel.backgroundColor = UIColor.uiColors.secondary
        tapOnImageLabel.layer.borderColor = UIColor.uiColors.primary.cgColor
    }
    
    @objc fileprivate func handleOnPhotoView(notification: Notification) {
        tapOnImageLabel.attributedText = NSAttributedString.stylizedTextWith("Take a picture of your ingredient, and I'll guess what it is!", shadowColor: UIColor.uiColors.primary, shadowOffSet: 0, mainTextColor: UIColor.uiColors.primary, textSize: 22)
    }
    
    @objc fileprivate func handleOnPictureView(notification: Notification) {
        tapOnImageLabel.attributedText = NSAttributedString.stylizedTextWith("Select a picture of your ingredient, and I'll guess what it is!", shadowColor: UIColor.uiColors.primary, shadowOffSet: 0, mainTextColor: UIColor.uiColors.primary, textSize: 22)
    }
}

// MARK: - CollectionView Delegate and Datasource Methods
extension ObjectSelectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guesses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ObjectSelectionCell
        let ingredient = guesses[indexPath.row]
        cell.ingredient = ingredient
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 210, height: view.frame.height - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = guesses[indexPath.row].replacingOccurrences(of: "?", with: "")
        IngredientController.shared.add(ingredient: object)
        performSegue(withIdentifier: "toRecipes", sender: self)
    }
    
}

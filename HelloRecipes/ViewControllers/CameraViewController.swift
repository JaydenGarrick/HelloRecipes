    //
//  CameraViewController.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 3/24/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import AVKit
import Vision

class CameraViewController: UIViewController {

    // MARK: - Constants and Variables
    var uiColors = UIColor.uiColors {
        didSet {
            UIColor.uiColors = uiColors
        }
    }
    
    // IBOutlets and UI
    @IBOutlet weak var scannerView: UIView! {
        didSet {
            scannerView.layer.cornerRadius = 5
            scannerView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var pictureView: UIView! {
        didSet {
            pictureView.layer.cornerRadius = 5
            pictureView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var cameraRollView: UIView! {
        didSet {
            cameraRollView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var amIRightLabel: UILabel!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var inferredObjectLabel: UILabel!
    @IBOutlet weak var recipesBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var navigationBarBorderView: UIView!
    
    @IBOutlet weak var objectSelectionView: UIView!
    
    
    
    // Object that is being scanned
    var observedObject = ""
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorsForUI()
        setupCamera()
        setupNavigationBar()
        setupSegmentedControl()
    }
    
    @IBOutlet weak var segmentedControllerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentedControllerTopConstraint: NSLayoutConstraint!
    // MARK: - IBActions
    @IBAction func yesButtonTapped(_ sender: Any) {
        IngredientController.shared.add(ingredient: observedObject)
        performSegue(withIdentifier: "toRecipes", sender: self)
    }
    
    @IBAction func recipeButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toRecipes", sender: self)
    }
    
    @IBAction func segmentedControllerChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.25, animations: {
            if self.segmentedController.selectedSegmentIndex == 0 {
                self.inferredObjectLabel.isHidden = false
                self.pictureView.isHidden = true
                self.cameraRollView.isHidden = true
                self.scannerView.isHidden = false
                self.objectSelectionView.isHidden = true
                
                // Handle Constraint to bump down Segmented Controller
                self.segmentedControllerBottomConstraint.constant = 4
                self.segmentedControllerTopConstraint.constant = 50
                
            } else if self.segmentedController.selectedSegmentIndex == 1 {
                self.inferredObjectLabel.isHidden = true
                self.pictureView.isHidden = false
                self.cameraRollView.isHidden = true
                self.scannerView.isHidden = true
                self.objectSelectionView.isHidden = false
                
                // Handle Constraint to bump up Segmented Controller
                self.segmentedControllerBottomConstraint.constant = 50
                self.segmentedControllerTopConstraint.constant = 4
                
            } else if self.segmentedController.selectedSegmentIndex == 2 {
                self.inferredObjectLabel.isHidden = true
                self.pictureView.isHidden = true
                self.cameraRollView.isHidden = false
                self.scannerView.isHidden = true
                self.objectSelectionView.isHidden = false
                
                // Handle Constraint to bump up Segmented Controller
                self.segmentedControllerBottomConstraint.constant = 50
                self.segmentedControllerTopConstraint.constant = 4
            }
            
        })
    }
    // MARK: - Setup Functions
    fileprivate func setupSegmentedControl() {
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: uiColors.primary]
        segmentedController.tintColor = uiColors.secondary
        segmentedController.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentedController.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedController.layer.borderColor = uiColors.primary.cgColor
        segmentedController.layer.borderWidth = 1
        segmentedController.layer.cornerRadius = 5
        
        objectSelectionView.isHidden = true
    }
    
    fileprivate func setColorsForUI() {
        navigationBarBorderView.backgroundColor = uiColors.primary
        scannerView.layer.borderColor = uiColors.primary.cgColor
        pictureView.layer.borderColor = uiColors.primary.cgColor
        cameraRollView.layer.borderColor = uiColors.primary.cgColor
        inferredObjectLabel.textColor = uiColors.primary
        yesButton.layer.borderColor = uiColors.primary.cgColor
        yesButton.backgroundColor = uiColors.secondary
        yesButton.setTitleColor(uiColors.primary, for: .normal)
        recipesBarButtonItem.tintColor = uiColors.primary
        amIRightLabel.textColor = uiColors.primary
    }
    
    func setupCamera() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        scannerView.layer.addSublayer(previewLayer)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = CGRect(x: 0, y: 0, width: scannerView.frame.width, height: scannerView.frame.height)
        previewLayer.cornerRadius = 5
        
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    fileprivate func setupNavigationBar() {
        view.setupNavigationBarWith(viewController: self, primary: uiColors.primary, secondary: uiColors.secondary)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeUI))
        let width = view.frame.width
        guard let height = navigationController?.navigationBar.frame.height else { return }
        let navView = UIView(frame: CGRect(x: 0, y: 0, width: width - 55, height: height))
        navView.backgroundColor = .clear
        navView.addGestureRecognizer(tapGesture)
        navigationController?.navigationBar.addSubview(navView)
    }
    
    @objc func changeUI() {
        let lastUsedColor = uiColors.primary
        uiColors = UIColor.randomColorCombo() as (primary: UIColor, secondary: UIColor)
        if uiColors.primary == lastUsedColor {
            changeUI()
        }
        setupNavigationBar()
        setupSegmentedControl()
        setColorsForUI()
    }
    
}
    
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            DispatchQueue.main.async {
                self.inferredObjectLabel.text = "\(firstObservation.identifier)?"
                self.observedObject = firstObservation.identifier
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

    
    

    
    
    
    
    
    
    
    
    
    

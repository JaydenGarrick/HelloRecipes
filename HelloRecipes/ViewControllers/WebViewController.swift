//
//  WebViewController.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 4/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    // MARK: - Constants and Variables
    let webView: WKWebView = {
        let wView = WKWebView()
        wView.allowsBackForwardNavigationGestures = true
        return wView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.uiColors.primary
        return view
    }()

    var url: String?
    var source: String?
    
    // MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        checkForWebViewProgress()
        guard let stringUrl = url else { return }
        loadWebViewWith(urlString: stringUrl)
    }
    
    // MARK: - Setup Functions
    fileprivate func setupNavigationBar() {
        view.setupNavigationBarWith(viewController: self, primary: UIColor.uiColors.primary, secondary: UIColor.uiColors.secondary)
       
        // Setup Dismiss Button
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(dismissView))
        barButtonItem.tintColor = UIColor.uiColors.primary
        self.navigationItem.title = source ?? "Hello Recipes"
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        // Setup Swipe Gesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        swipeGesture.direction = .down
        let width = view.frame.width
        guard let height = navigationController?.navigationBar.frame.height else { return }
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: width - 55, height: height))
        navigationView.backgroundColor = .clear
        navigationView.addGestureRecognizer(swipeGesture)
        navigationController?.navigationBar.addSubview(navigationView)
    }
    
    fileprivate func setupViews() {
        view.addSubview(webView)
        view.addSubview(seperatorView)
        
        seperatorView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        setupNavigationBar()
        webView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: - Action Functions
    fileprivate func checkForWebViewProgress()  {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (_) in
            if self.webView.estimatedProgress != 1.0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    fileprivate func loadWebViewWith(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

}

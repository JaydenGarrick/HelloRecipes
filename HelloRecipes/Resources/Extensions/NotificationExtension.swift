//
//  NotificationExtension.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 5/15/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let selectedImage = NSNotification.Name("selectedImage")
    static let photoButtonTapped = NSNotification.Name("photoButtonTapped")
    static let colorsChanged = NSNotification.Name("colorsChanged")
    static let onCameraView = NSNotification.Name("onCameraView")
    static let onPhotoView = NSNotification.Name("onPhotoView")
    static let connectivityLost = Notification.Name("connectivityLost")
}

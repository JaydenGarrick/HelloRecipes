//
//  StretchingTableView.swift
//  HelloRecipes
//
//  Created by Jayden Garrick on 4/7/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

final class StretchingTableView: UITableView {

    var heightConstraint: NSLayoutConstraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let header = tableHeaderView else { return }
        if heightConstraint == nil {
            if let labelView = header.subviews.first as? UILabel {
                heightConstraint = labelView.constraints.filter { $0.identifier == "height" }.first
            }
        }
        let offsetY = -(contentOffset.y + adjustedContentInset.top)
        heightConstraint?.constant = max(header.bounds.height, header.bounds.height + offsetY)
        
        
    }
    

}

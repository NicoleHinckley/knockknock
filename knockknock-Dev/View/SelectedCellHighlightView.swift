//
//  SelectedCellHighlightView.swift
//  knockknock
//
//  Created by Nicole Hinckley on 11/4/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit

class SelectedCellHighlightView: UIView {

    
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.green.cgColor// #colorLiteral(red: 0.2666399777, green: 0.2666836977, blue: 0.2666304708, alpha: 1)
        self.layer.borderWidth = 3
        self.backgroundColor = .clear
    }
}

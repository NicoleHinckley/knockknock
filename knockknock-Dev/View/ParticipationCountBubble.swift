//
//  ParticipationCountBubble.swift
//  knockknock
//
//  Created by Nicole Hinckley on 11/4/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit

class ParticipationCountBubble : UIView {
  
    override func awakeFromNib() {
   setupColor()
    }
       
    func setupColor(){
        if self.tag == 1 {
            self.backgroundColor = #colorLiteral(red: 0.3944675624, green: 0.8240264058, blue: 0.6071181893, alpha: 1)
            self.layer.borderWidth = 0.0
        } else if self.tag == 2 {
            self.backgroundColor = . white
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 1.0
        }
        }
    }

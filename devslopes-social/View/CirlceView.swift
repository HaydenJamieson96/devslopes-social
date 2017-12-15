//
//  CirlceView.swift
//  devslopes-social
//
//  Created by TheAppExperts on 12/14/17.
//  Copyright © 2017 TheAppExperts. All rights reserved.
//

import UIKit

class CirlceView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
        
    

}

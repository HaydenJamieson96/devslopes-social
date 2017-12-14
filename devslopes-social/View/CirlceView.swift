//
//  CirlceView.swift
//  devslopes-social
//
//  Created by TheAppExperts on 12/14/17.
//  Copyright © 2017 TheAppExperts. All rights reserved.
//

import UIKit

class CirlceView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha:0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.width / 2
    }
    
        
    

}

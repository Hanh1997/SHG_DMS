//
//  CardView.swift
//  SH_SS
//
//  Created by phạm Hưng on 3/30/20.
//  Copyright © 2020 phạm Hưng. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {
   @IBInspectable var cornerradius : CGFloat = 2
   @IBInspectable var shadowOffSetWidth : CGFloat = 0
    
     @IBInspectable var shadowOffSetHeight: CGFloat = 5
    @IBInspectable var shadowColor : UIColor = UIColor.black
    @IBInspectable var shadowOpacity : CGFloat = 0.5

    override func layoutSubviews() {
        layer.cornerRadius = cornerradius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        
        let shawdowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
        layer.shadowPath = shawdowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
        
    
    }

}

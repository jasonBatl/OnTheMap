//
//  GradientView.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/26/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import UIKit

//Creates a class to style the background layer as a "view" layer
class GradientView: UIView {

    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    func gradientWithColors() {
        
        let topColor = UIColor.customColor(redValue: 224, greenValue: 224, blueValue: 171, alpha: 1)
        let bottomColor = UIColor.customColor(redValue: 153, greenValue: 153, blueValue: 103, alpha: 1)
        
        let deviceScale = UIScreen.mainScreen().scale
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width * deviceScale, self.frame.size.height * deviceScale)
        gradientLayer.colors = [topColor.CGColor, bottomColor.CGColor]
        
        self.layer.insertSublayer(gradientLayer, atIndex: 0)
    }

}

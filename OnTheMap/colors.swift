//
//  colors.swift
//  OnTheMap
//
//  Created by Bronson, Jason on 7/21/15.
//  Copyright (c) 2015 Bronson, Jason. All rights reserved.
//

import Foundation
import UIKit

/* extension created to quickly access create color without having to divide it out*/

extension UIColor {
    static func customColor(#redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
}






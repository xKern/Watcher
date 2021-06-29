//
//  UIButton+BGColor.swift
//  SHSH Host
//
//  Created by ninja on 21/12/19.
//  Copyright © 2019 arx8x.net. All rights reserved.
//

import Foundation
import UIKit

public extension UIButton
{
    func setBackgroundColor(color: UIColor, forState state:UIControl.State)
    {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: state)
        clipsToBounds = true
    }
}


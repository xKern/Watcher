//
//  UIColor+dark_light.swift
//  SHSH Host
//
//  Created by ninja on 21/12/19.
//  Copyright © 2019 arx8x.net. All rights reserved.
//

import Foundation
import UIKit
public extension UIColor
{
    func darkerColor(byFactor factor: CGFloat = 0.2) -> UIColor
    {
        let CIColorForUIColor = CIColor(color: self)
        let darkerColor = UIColor(red: CIColorForUIColor.red - factor, green: CIColorForUIColor.green - factor, blue: CIColorForUIColor.blue - factor, alpha: 1)
        return darkerColor
    }
    
    func lighterColor(byFacor factor: CGFloat = 0.2) -> UIColor
    {
        let CIColorForUIColor = CIColor(color: self)
        let darkerColor = UIColor(red: CIColorForUIColor.red + factor, green: CIColorForUIColor.green + factor, blue: CIColorForUIColor.blue + factor, alpha: 1)
        return darkerColor
    }
}

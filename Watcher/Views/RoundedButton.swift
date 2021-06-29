//
//  RoundedButton.swift
//  SHSH Host
//
//  Created by ninja on 16/12/19.
//  Copyright © 2019 arx8x.net. All rights reserved.
//

import UIKit

class RoundedButton: UIButton
{
    override var tintColor: UIColor!
    {
        didSet
        {
            self.backgroundColor = self.tintColor
        }
    }
    override var backgroundColor: UIColor?
    {
        didSet
        {
            setBackgroundColor(color: (self.backgroundColor?.darkerColor())!, forState: .highlighted)
        }
    }
    var cornerRadius = CGFloat(10)
    var insets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = self.tintColor
        setBackgroundColor(color: (self.backgroundColor?.darkerColor())!, forState: .highlighted)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        contentEdgeInsets = insets
        layer.cornerRadius = cornerRadius
    }
    
 

    
}


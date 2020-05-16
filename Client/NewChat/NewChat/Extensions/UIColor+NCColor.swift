//
//  UIColor+NCColor.swift
//  NewChat
//
//  Created by lou on 2020/4/25.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public var nc_bgColor: UIColor {
        return nc_colorFromRGB(rgbValue: 0xf0f0f1)
    }
    
    public var nc_color1: UIColor {
        return nc_colorFromRGB(rgbValue: 0xc0c0c3)
    }
    
    public var nc_color2: UIColor {
        return nc_colorFromRGB(rgbValue: 0x0b0b0c)
    }
    
    public var nc_color3: UIColor {
        return nc_colorFromRGB(rgbValue: 0x777a86)
    }
    
    public var nc_color4: UIColor {
        return nc_colorFromRGB(rgbValue: 0x5e5f60)
    }
    
    public var nc_color5: UIColor {
        return nc_colorFromRGB(rgbValue: 0x383c4b)
    }
    
    public func nc_colorFromRGB(rgbValue :Int) -> UIColor {
        let red = CGFloat(((rgbValue & 0xFF0000) >> 16))/255.0
        let green = CGFloat(((rgbValue & 0x00FF00) >> 8))/255.0
        let blue = CGFloat(((rgbValue & 0x0000FF) >> 0))/255.0
        return UIColor.init(red:red, green: green, blue: blue, alpha: 1.0)
    }
}

//
//  Tool.swift
//  SwiftTest
//
//  Created by yinmingji on 16/4/11.
//  Copyright © 2016年 yinmingji. All rights reserved.
//

import UIKit

class Tool: NSObject {
    //根据16进制颜色值算出UIColor
    class func colorwithHexString(colorString: String) -> UIColor {
        var cString:String = colorString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.clearColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    //根据16进制颜色值画出该颜色的UIImage
    class func createImageWithColor(colorString: String) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, Tool.colorwithHexString(colorString).CGColor)
        CGContextFillRect(context, rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //正整数的整数级指数运算
    class func expOperation(number: UInt, exponent: UInt) -> UInt {
        if exponent == 0 {
            return 1
        }
        var result: UInt = 1
        for _ in 1...exponent {
            result *= number
        }
        return result
    }
}

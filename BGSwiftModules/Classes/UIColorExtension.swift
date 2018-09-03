//
//  UIColorExtension.swift
//  BGSwiftBasicModule_Example
//
//  Created by 张波 on 2018/5/7.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit



public extension UIColor {
    
    /// 十六进制颜色，无透明度
    convenience init(hex: String) {
        self.init(hex: hex)
    }
    
    /// 十六进制颜色，有透明度
    convenience init(hex: String, _ alpha: CGFloat) {
        var colorString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //十六进制色值必须是6-8位
        if colorString.count < 6 || colorString.count > 8 {
            self.init(white: 0, alpha: 0)
            return
        }
        if (colorString.hasPrefix("0x") || colorString.hasPrefix("0X")) {
            colorString = (colorString as NSString).substring(from: 2)
        }
        else if (colorString.hasPrefix("#")) {
            colorString = (colorString as NSString).substring(from: 1)
        }
        if (colorString.count != 6) {
            self.init(white: 0, alpha: 0)
            return
        }
        let redStr   = (colorString as NSString).substring(to: 2)
        let greenStr = ((colorString as NSString).substring(to: 2) as NSString).substring(to: 2)
        let blueStr  = ((colorString as NSString).substring(to: 4) as NSString).substring(to: 2)
        var red: CUnsignedInt = 0, green: CUnsignedInt = 0, blue: CUnsignedInt = 0
        Scanner(string: redStr).scanHexInt32(&red)
        Scanner(string: greenStr).scanHexInt32(&green)
        Scanner(string: blueStr).scanHexInt32(&blue)
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}



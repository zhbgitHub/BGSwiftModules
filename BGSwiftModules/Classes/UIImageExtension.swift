//
//  UIImageExtension.swift
//  BGSwiftModules_Example
//
//  Created by 张波 on 2018/5/12.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    /// 由颜色生成一张图片
    ///
    /// - Parameters:
    ///   - color: 颜色值
    ///   - size: 图片大小
    /// - Returns: image
    static func img_init(with color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}



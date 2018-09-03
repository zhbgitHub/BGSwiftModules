//
//  UILabelExtension.swift
//  BGSwiftModules_Example
//
//  Created by 张波 on 2018/5/12.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

public extension UILabel {
    /// 设置文字，并且设置行间距
    ///
    /// - Parameters:
    ///   - text: label的文字
    ///   - lineSpace: 行间距
    func lb_text(_ text: String?, lineSpace: CGFloat) {
        let attributedString = NSMutableAttributedString.init(string: text ?? "" )
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.alignment = NSTextAlignment.left
        let attriDict = [NSAttributedStringKey.paragraphStyle : paragraphStyle]
        attributedString.addAttributes(attriDict, range: NSMakeRange(0, text?.count ?? 0))
        self.attributedText = attributedString
        self.sizeToFit()
    }
    
}



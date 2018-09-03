//
//  NSConstrain.swift
//  BGSwiftModules_Example
//
//  Created by 张波 on 2018/5/12.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public extension NSLayoutConstraint {
    /// 更改NSLayoutConstraint.multiplier
    ///
    /// - Parameter multiplier: 比例值
    /// - Returns: 返回值 作为 最新值，要求必须重新赋值要重新赋值
    func layout_setMultiplier(_ multiplier:CGFloat) -> NSLayoutConstraint {
        guard let fistItm = firstItem else { return self }
        NSLayoutConstraint.deactivate([self])
        let newConstraint = NSLayoutConstraint.init(item: fistItm, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

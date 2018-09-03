//
//  UITableViewExtension.swift
//  BGSwiftModules_Example
//
//  Created by 张波 on 2018/5/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView{
    
    /// tableView滚到最底部，适配：tableView刷新后，滚到最下端。
    ///
    /// - Parameter animated: 是否需要动画效果
    func tableview_scrollToBottom(_ animated: Bool) {
        let viewHeight = self.bounds.size.height
        let contentHeight = self.contentSize.height
        let topInset = self.contentInset.top
        let bottomInset = self.contentInset.bottom
        let  value = floorf(Float(contentHeight - bottomInset - topInset - viewHeight))
        let offsetY = max(CGFloat(value), 0)
        
        self.beginUpdates()
        let point = CGPoint(x: 0, y: offsetY)
        self.setContentOffset(point, animated: animated)
        self.endUpdates()
    }
    
    
    
}

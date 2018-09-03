//
//  StringExtension.swift
//  BGSwiftBasicModule_Example
//
//  Created by 张波 on 2018/5/7.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation

// MARK: ------------------------------ 工具操作 ------------------------------
//       ------------------------------ 工具操作 -----------------------------
public extension String {
    
    /// 截取字符串[from,to)前闭后开
    ///
    /// - Parameters:
    ///   - from: 下标第N位开始 包含第N位
    ///   - to: 到下标第M位结束 不包含第M位
    @discardableResult
    public func str_substring(from: Int,to: Int) -> String{
        if from >= to {return ""}
        if from >= self.count-1 || to >= self.count-1 {return "" }
        let str = self as NSString
        let range = NSMakeRange(from, to - from)
        let temp  = str.substring(with: range)
        return temp
    }
    
    /// self如果包含Array里的某个元素,返回true,不包含返回false..若self.isEmpty 或 array.isEmpty返回false
    ///
    /// - Parameter array: 判断依据,array的某个元素,
    /// - Returns: true:self包含某个元素
    public func str_isContainsElements(of array: [String]) -> Bool {
        if array.isEmpty || self.isEmpty {
            return false
        }
        var isVerify =  false
        for value in array {
            isVerify = (isVerify || self.contains(value))
        }
        return isVerify
    }
    
    /// 通过字体，最大宽度 获取文字高度。折断方式默认:NSLineBreakMode.byCharWrapping
    @discardableResult
    func str_height(byAttributes fone: UIFont, _ width: CGFloat) -> CGFloat {
        return self.str_getHeight(byAttributes: fone, NSLineBreakMode.byCharWrapping, width)
    }
    
    /// 通过字体，最大宽度 获取文字Size。折断方式默认:NSLineBreakMode.byCharWrapping
    func str_getSize(byAttributes fone: UIFont, _ width: CGFloat) -> CGSize {
        return self.str_getSize(byAttributes: fone, NSLineBreakMode.byCharWrapping, width)
    }

    
    /// 通过fone，段落方式，最大宽度 获取文字高度
    @discardableResult
    func str_getHeight(byAttributes fone: UIFont, _ breakMode: NSLineBreakMode, _ width: CGFloat) -> CGFloat {
        return self.str_getSize(byAttributes: fone, breakMode, width).height
    }
    
    
    /// 通过fone，段落方式，最大宽度 获取文字size
    @discardableResult
    func str_getSize(byAttributes fone: UIFont, _ breakMode: NSLineBreakMode, _ width: CGFloat) -> CGSize {
        var result = CGSize.init()
        guard self.count > 0 && width > 0 else { return result }
        let tempSize = CGSize.init(width: width, height: CGFloat(MAXFLOAT))
        let str = self as NSString
        var attr: [NSAttributedStringKey : Any] = [:]
        attr[NSAttributedStringKey.font] = fone
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = breakMode
        attr[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        result = str.boundingRect(with: tempSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attr, context: nil).size
        return result
    }
}

// MARK: ------------------------------ path路径 ------------------------------
//       ------------------------------ path路径 ------------------------------
/****************************************************/
/****       /---name.app                    ****/
/****       |---Documents                   ****/
/****       |             |- Caches         ****/
/*** Home---|---Library---|                 ****/
/****       |             |- Preferences    ****/
/****       \---tmp                         ****/
/****************************************************/
public extension String {
    
    
    /// 获取程序的Home目录路径
    @discardableResult
    public static func str_pathOfHomeDirectory() -> String {
        return NSHomeDirectory();
    }
    
    /// 获取Documents路径
    @discardableResult
    public static func str_pathOfDocument() -> String {
        let pathArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = pathArray[0]
        return path;
    }
    
    /// 获取Library路径
    @discardableResult
    public static func str_pathOfLibrary() -> String {
        let pathArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = pathArray[0]
        return path;
    }
    
    /// 获取Cache目录路径
    @discardableResult
    public static func str_pathOfCache() -> String {
        let pathArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = pathArray[0]
        return path;
    }
    
    /// 获取Tmp路径
    @discardableResult
    public static func str_pathOfTmp() -> String {
        return NSTemporaryDirectory()
    }
}



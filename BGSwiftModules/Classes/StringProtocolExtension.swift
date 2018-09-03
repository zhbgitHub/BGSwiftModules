//
//  UITextField+Formatting.swift
//  BaseSDK
//
//  Created by 张波 on 2017/12/12.
//  Copyright © 2017年 com.TieBaoBei. All rights reserved.
//

import Foundation

public extension StringProtocol {
    /// 去除文字中的所有空格,更改:调用者的值
    mutating func str_deleteAllSpaceForSelf(){
        let value = self.str_deleteAllSpace()
        self = value as! Self
    }

    /// 去除文字中的所有空格,不更改:调用者的值
    @discardableResult
    public func str_deleteAllSpace() -> String {
        if (self.isEmpty) == true {return ""}
        let str = self as! NSString
        var inputStr = str.trimmingCharacters(in: CharacterSet.whitespaces)
        var components = (inputStr.components(separatedBy: CharacterSet.whitespaces)) as NSArray
        components = components.filtered(using: NSPredicate(format: "NOT (SELF in %@)", [" ", "\\t", "\n", "\\s"])) as NSArray
        inputStr = components.componentsJoined(by: "")
        return inputStr
    }
    
    
    /// 删除冗余的空格,规范格式. 更改’调用者‘
    /// 类似英语句子 eg:("hello   swift  ! ") --> ("hello swift!")
    mutating func str_deleteDedundantSpaceForSelf(){
        let value = self.str_deleteDedundantSpace()
        self = value as! Self
    }
    
    /// 删除冗余的空格,规范格式. 不更改’调用者‘
    @discardableResult
    public func str_deleteDedundantSpace() -> String {
        if (self.isEmpty) == true {return ""}
        let str = self as! NSString
        var inputStr = str.trimmingCharacters(in: CharacterSet.whitespaces)
        var components = (inputStr.components(separatedBy: CharacterSet.whitespaces)) as NSArray
        components = components.filtered(using: NSPredicate(format: "self != ''")) as NSArray
        inputStr = components.componentsJoined(by: " ")
        return inputStr;
    }
    
    
    /// 删除头部和结尾的空格,更改’调用者‘
    mutating func str_deleteSpaceAtLeaderOrTailForSelf(){
        let value = self.str_deleteSpaceAtLeaderOrTail()
        self = value as! Self
    }
    /// 删除头部和结尾的空格,不更改’调用者‘
    @discardableResult
    public func str_deleteSpaceAtLeaderOrTail() -> String {
        if (self.isEmpty) {return ""};
        let str = self as! NSString
        let inputStr = str.trimmingCharacters(in: CharacterSet.whitespaces);
        return inputStr
    }
    
    
    /// 手机号格式: 13612345678 -->136 1234 5678,更改:调用者的值
    mutating func str_formatMobileNumberForSelf() {
        let value = self.str_formatMobileNumber()
        self = value as! Self
    }
    
    /// 手机号格式: 13612345678 -->136 1234 5678,不更改:调用者的值
    @discardableResult
    func str_formatMobileNumber() -> String {
        if (self.isEmpty) == true {return ""}
        let inputStr = self
        let formatter = NumberFormatter.init()
        formatter.positiveFormat = "#,####,###0"
        if let inputInt = Int(inputStr), var inputStr = formatter.string(from: NSNumber.init(value: inputInt))
        {
            inputStr = inputStr.replacingOccurrences(of: ",", with: " ")
            return inputStr
        }
        else {
            return ""
        }
    }
    
    
    /// 金钱格式: 10000000 -->10,000,000.00, 更改:调用者的值
    mutating func str_formatAmounOfMoneyForSelf(){
        let value = self.str_formatAmounOfMoney()
        self = value as! Self
    }
    
    /// 金钱格式: 10000000 -->10,000,000.00, 不更改:调用者的值
    @discardableResult
    func str_formatAmounOfMoney() -> String {
        if (self.isEmpty) == true {return "0.00"}
        let inputStr = self
        let formatter = NumberFormatter.init()
        formatter.positiveFormat = "###,##0.00"
        if let inputDouble = Double(inputStr), let inputStr = formatter.string(from: NSNumber.init(value: inputDouble))
        {
            return inputStr
        }
        else {
            return ""
        }
    }
}

// MARK: ------------------------------ 正则判断 ------------------------------
//       ------------------------------ 正则判断 ------------------------------
public extension StringProtocol {
    /// 通过正则表达式验证字符串
    ///
    /// - Parameter regex: 正则表达式
    /// - Returns: true:合格, false:不合格
    @discardableResult
    public func str_isValidate(by regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex);
        return predicate.evaluate(with: self);
    }
    
    /// 字符串是 手机号码 吗?
    @discardableResult
    public func str_isMobileNumber() -> Bool {
        let regex = "^((1[3-9]))\\d{9}$";
        return self.str_isValidate(by: regex);
    }
    
    
    /// 字符串是 身份证号码 吗?
    @discardableResult
    public func str_isIdentityCardNum() -> Bool {
        let regex = "(^[0-9]{15}$)|([0-9]{17}([0-9]|[xX])$)";
        return self.str_isValidate(by: regex);
    }
    
    /// 字符串是 车牌号码 吗?
    @discardableResult
    public func str_isCarNumer() -> Bool {
        let regex = "^[\u{4e00}-\u{9fff}]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u{4e00}-\u{9fff}]$";
        return self.str_isValidate(by: regex);
    }
    
    /// 字符串是 LinkURl 吗? 只能验证(带有http:// 或 https://的)url
    @discardableResult
    public func str_isLinkURl() -> Bool {
        let regex = "^(https?|ftp|file)://.+$";
        return self.str_isValidate(by: regex);
    }
    
    /// 字符串是 中文汉字 吗?
    @discardableResult
    public func str_isChinese() -> Bool {
        let regex = "^[\u{4e00}-\u{9fa5}]+$";
        return self.str_isValidate(by: regex);
    }
    
    /// 字符串是 用户名称(2-11个汉字) 吗?
    @discardableResult
    public func str_isChineseName() -> Bool {
        let regex = "^[\u{4e00}-\u{9fa5}]{2,11}+$";
        return self.str_isValidate(by: regex);
    }
    
    /// 字符串是 密码格式 吗? 英文字母或数字,6-20位长度
    @discardableResult
    public func str_isPassword() -> Bool {
        let regex = "^[a-zA-Z0-9]{6,20}+$";
        return self.str_isValidate(by: regex);
    }
    
    /// 字符串中是否包含 中文汉字?
    @discardableResult
    public func str_isCludeChinese() -> Bool {
        for i in self {
            let a = String(i);
            if a.str_isChinese() {
                return true
            }
        }
        return false;
    }
}





//
//  UITextField+Formatting.swift
//  BaseSDK
//
//  Created by 张波 on 2017/10/23.
//  Copyright © 2017年 com.TieBaoBei. All rights reserved.
//

import Foundation
import UIKit


public enum BusinessType {
    case phone, phoneSpace, number, money, bankCard
}

public extension UITextField {
    
    
    /// 输入手机号的同时,格式化输入格式
    /// 功能1:格式化显示;功能2:只能输入数字+回退; 功能3:限制输入的长度
    /// 用法: 在textFieldDelegate的:func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {}方法中调用
    /// - Parameters:
    ///   - businessType: 业务类型{phone:手机号,}
    /// - Returns: true:能继续输入, false:不允许输入
    @discardableResult
    public func txf_textField(shouldChangeCharactersIn range: NSRange, replacementString string: String, businessType: BusinessType) -> Bool {
        switch businessType {
        case BusinessType.phone:
            return txfPhone(shouldChangeCharactersIn: range, replacementString: string)
        case BusinessType.phoneSpace:
            return txfPhoneSpace(shouldChangeCharactersIn: range, replacementString: string)
        case BusinessType.number:
            return txfNumber(shouldChangeCharactersIn: range, replacementString: string)
        case BusinessType.money:
            return txfMoney(shouldChangeCharactersIn: range, replacementString: string)
        case BusinessType.bankCard:
            return txfBankCard(shouldChangeCharactersIn: range, replacementString: string)
        }
    }
}

// MARK: - 限制手机号输入
private extension UITextField {
    /// Format:13522589780
    func txfPhone(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = self.text as NSString? else{
            return false
        }
        var nString = string as NSString
        let characterSet = NSCharacterSet.init(charactersIn: "0123456789\\b")
        nString = nString.replacingOccurrences(of: " ", with: "") as NSString
        if nString.rangeOfCharacter(from: characterSet.inverted).location != NSNotFound {
            return false
        }
        let tolcount = (text.length - range.length + string.lengthOfBytes(using: String.Encoding.utf8));
        return (tolcount < 12)
        
    }
    
    /// Format:135 2258 9780
    func txfPhoneSpace(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = self.text as NSString? else{
            return false
        }
        var nString = string as NSString
        let characterSet = NSCharacterSet.init(charactersIn: "0123456789\\b")
        nString = nString.replacingOccurrences(of: " ", with: "") as NSString
        if nString.rangeOfCharacter(from: characterSet.inverted).location != NSNotFound {
            return false
        }
        text = text.replacingCharacters(in: range, with: nString as String) as NSString
        text = text.replacingOccurrences(of: " ", with: "") as NSString
        var newString = ""
        let subString = text.substring(to: min(text.length, 3)) as NSString
        newString = newString.appending(subString as String)
        if subString.length == 3 {
            newString = newString.appending(" ")
        }
        text = text.substring(from: min(text.length, 3)) as NSString
        if text.length > 0 {
            let subString2 = text.substring(to: min(text.length, 4)) as NSString
            newString = newString.appending(subString2 as String)
            if subString2.length == 4 {
                newString = newString.appending(" ")
            }
            let subString3 = text.substring(from: min(text.length, 4))
            newString = newString.appending(subString3 as String)
        }
        newString = newString.trimmingCharacters(in: characterSet.inverted)
        let newNSString = newString as NSString
        if newNSString.length >= 14 {
            return false
        }
        self.text = newString
        return false
    }
}


// MARK: - 只能数字输入
private extension UITextField {
    func txfNumber(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = self.text as NSString? else{
            return false
        }
        let nString = string as NSString
        let characterSet = NSCharacterSet.init(charactersIn: "0123456789\\b")
        if nString.rangeOfCharacter(from: characterSet.inverted).location != NSNotFound {
            return false
        }
        text = text.replacingCharacters(in: range, with: string) as NSString
        text = text.replacingOccurrences(of: " ", with: "") as NSString
        self.text = text as String
        return false
    }
}

// MARK: - 金额输入
private extension UITextField {
    var decimalSeperator: String {
        return "."
    }
    
    func txfMoney(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = self.text as NSString? else{
            return false
        }
        let chatSet: NSCharacterSet
        if string == self.decimalSeperator && text.length == 0{
            return false
        }
        
        let decimalRange = text.range(of: self.decimalSeperator)
        let isDecimalNumber = decimalRange.location != NSNotFound
        if isDecimalNumber {
            chatSet = NSCharacterSet.init(charactersIn: "0123456789")
            if nil != string.range(of: self.decimalSeperator) {
                return false
            }
        }else {
            chatSet = NSCharacterSet.init(charactersIn: "0123456789.")
        }
        let invertedCharSet = chatSet.inverted
        let trimmedString = string.trimmingCharacters(in: invertedCharSet)
        text = text.replacingCharacters(in: range, with: trimmedString) as NSString
        if isDecimalNumber {
            let arr = text.components(separatedBy: decimalSeperator)
            if arr.count == 2 {
                if arr[1].count > 2 {
                    return false
                }
            }
        }
        self.text = text as String
        return false
    }
}


// MARK: - 银行卡
private extension UITextField {
    func txfBankCard(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = self.text as NSString? else{
            return false
        }
        var nString = string as NSString
        let characterSet = NSCharacterSet.init(charactersIn: "0123456789\\b")
        nString = nString.replacingOccurrences(of: " ", with: "") as NSString
        if nString.rangeOfCharacter(from: characterSet.inverted).location != NSNotFound {
            return false
        }
        text = text.replacingCharacters(in: range, with: nString as String) as NSString
        text = text.replacingOccurrences(of: " ", with: "") as NSString
        var newString = ""
        while text.length > 0 {
            let subString = text.substring(to: min(text.length, 4)) as NSString
            newString = newString.appending(subString as String)
            if subString.length == 4 {
                newString = newString.appending(" ")
            }
            text = text.substring(from: min(text.length, 4)) as NSString
        }
        newString = newString.trimmingCharacters(in: characterSet.inverted)
        if newString.count >= 24 {
            return false
        }
        self.text = newString
        return false
    }
}





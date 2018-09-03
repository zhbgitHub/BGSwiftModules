//
//  BGTestTextFieldCell.swift
//  BGSwiftModules_Example
//
//  Created by 张波 on 2018/5/8.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import BGSwiftModules

public class BGTestTextFieldCell: UITableViewCell {
    @IBOutlet weak public var textField: UITextField!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        let mobile = "13522589780"
        self.textField.text = mobile.str_formatMobileNumber()
        self.textField.backgroundColor = UIColor.yellow
        self.textField.delegate = self
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BGTestTextFieldCell: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.txf_textField(shouldChangeCharactersIn: range, replacementString: string, businessType: BusinessType.phoneSpace)
    }
}




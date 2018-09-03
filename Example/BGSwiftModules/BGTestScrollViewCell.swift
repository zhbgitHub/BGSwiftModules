//
//  BGTestScrollViewCell.swift
//  BGSwiftModules_Example
//
//  Created by 张波 on 2018/5/8.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit


public class BGTestScrollViewCell: UITableViewCell {
    @IBOutlet weak var scrollView: BGScrollView!
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}


//
//  BGTestTimerCell.swift
//  BGSwiftModules_Example
//
//  Created by 张波 on 2018/5/10.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class BGTestTimerCell: UITableViewCell {

    var model: BGTestModel?
    @IBOutlet weak var carButton: UIButton!
    var blockZero: ((_ timeOutModel: BGTestModel)->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData(_ model: BGTestModel) {
        self.model = model
        self.countDownNotification()

        
    }
    

    
}

extension BGTestTimerCell {
    func setUpStatus(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.countDownNotification), name: .OYCountDownNotification, object: nil)
    }
    
    @objc func countDownNotification() {
        guard let model = self.model else {return}
        if (model.identifier.isEmpty) {return}
        let timeInterval = BGCountDownManager.sharedManager.timeIntervalWithIdentifier(identifier: model.identifier)
        let countDown = model.count - timeInterval

        if (countDown <= 0) {
            self.carButton.setTitle("预约卖车", for: UIControlState.normal)
            // 回调给控制器
            self.model?.count = 0
//            if self.countDownZero != nil {
//                self.countDownZero!(model)
//            }
            return;
        }
        let title = "预约卖车(" + "\(countDown)" + "s)"
        self.carButton.setTitle(title, for: UIControlState.normal)

    }

    
    

    
}

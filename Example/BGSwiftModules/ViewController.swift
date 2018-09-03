//
//  ViewController.swift
//  BGSwiftModules
//
//  Created by tiejiaGitHub on 05/08/2018.
//  Copyright (c) 2018 tiejiaGitHub. All rights reserved.
//

import UIKit

protocol Food {
    var name: String {get set}
    func product<U>(by elements: [U]) -> U;
}


class ViewController: UIViewController {

    fileprivate lazy var models: [BGTestModel] = {
        let model1 = BGTestModel.init()
        model1.isNeedTimer = true
        model1.identifier = "top"
        model1.count = 60
        
        let model2 = BGTestModel.init()
        model2.isNeedTimer = true
        model2.identifier = "bottom"
        model2.count = 60
        return [model1, model2]
    }()
    
    
    fileprivate lazy var tableView: UITableView = {
        let topGap = CGFloat(64)
        let bounds = CGRect.init(x: 0, y: topGap, width: self.view.bounds.size.width, height: self.view.bounds.height - topGap - 49.0)
        let tempView = UITableView.init(frame: bounds, style: UITableViewStyle.plain)
//        tempView.rowHeight = 88.0
        let textFieldNib = UINib.init(nibName: "BGTestTextFieldCell", bundle: Bundle.init(for: type(of: self)))
        let scrollNib = UINib.init(nibName: "BGTestScrollViewCell", bundle: Bundle.init(for: type(of: self)))
        let timerNib = UINib.init(nibName: "BGTestTimerCell", bundle: Bundle.init(for: type(of: self)))

        tempView.register(textFieldNib, forCellReuseIdentifier: "BGTestTextFieldCell")
        tempView.register(scrollNib, forCellReuseIdentifier: "BGTestScrollViewCell")
        tempView.register(timerNib, forCellReuseIdentifier: "BGTestTimerCell")
        
        tempView.register(UITableViewCell.self, forCellReuseIdentifier: "helloTableViewCell")

        tempView.delegate = self;
        tempView.dataSource = self
        if #available(iOS 11.0, *) {
            tempView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tempView.backgroundColor = UIColor.lightGray
        return tempView
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        // 启动倒计时管理
        BGCountDownManager.sharedManager.start()
    }

    deinit {
        BGCountDownManager.sharedManager.invalidate()
        BGCountDownManager.sharedManager.reload()
    }
    

    
    
    
    

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 4 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BGTestScrollViewCell", for: indexPath) as! BGTestScrollViewCell
            cell.scrollView.showStyle(.image)
//            cell.scrollView.scrollDirction(.horizontal)
            cell.scrollView.imageArray(["banner01", "banner02"])
            
            return cell
        }
        else if indexPath.row % 4 == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BGTestTextFieldCell", for: indexPath) as! BGTestTextFieldCell
            cell.textField?.placeholder = "发的说法是"
            return cell
        }
        else if indexPath.row % 4 == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BGTestTimerCell", for: indexPath) as! BGTestTimerCell
            let index = indexPath.row % 2
            cell.loadData(models[index])
            return cell
        }
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "helloTableViewCell", for: indexPath)
            cell.textLabel?.text = "🔥\(indexPath.row)🔥"
            return cell
        }
    }
}


extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 4 == 0 {
            return 160
        }
        else if indexPath.row % 4 == 1 {
            return 80
        }
        else if indexPath.row % 4 == 2 {
           return 80
        }
        else  {
            return 80
        }
    }
    
    
}


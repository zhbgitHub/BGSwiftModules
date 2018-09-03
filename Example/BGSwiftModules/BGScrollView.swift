//
//  BGScrollView.swift
//  BGSwiftBasicModule_Example
//
//  Created by 张波 on 2018/4/27.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SDWebImage

fileprivate let errorCellReuseId = "f<h>t{y}u(o)g?h!j}"

public enum BGScrollViewShowStyle {
    case none, image, text
}

@objc protocol BGScrollViewDelegate: NSObjectProtocol {
    @objc optional func autoScrollView(_ autoScrollView: BGScrollView, didSelectItemAt index: Int);
    @objc optional func autoScrollView(_ autoScrollView: BGScrollView, didScrollTo index: Int);
}
//待实现..
//@objc protocol BGScrollViewDataSource: NSObjectProtocol {
//    @objc optional func autoScrollView(_ autoScrollView: BGScrollView, cellForItemAt index: Int) -> UICollectionViewCell;
//
//}



public final class BGScrollView: UIView {
    public var placeholderImage : UIImage?
    public var selectedBlock: ((_ : Int)->Void)?
    public var scrollToIndexBlock: ((_ : Int)->Void)?
    @objc weak var delegate: BGScrollViewDelegate?
//    @objc weak var dataSource: BGScrollViewDataSource?

    fileprivate var runNumbers: Int = 1;//轮播次数,如果isUnlimited == false时,才有效.取值范围>1
    fileprivate var isUnlimited = true;//是否无限大轮播
    fileprivate var showStyle: BGScrollViewShowStyle = .none
    fileprivate var imageArray: [String] = []
    fileprivate var textArray: [(String, String)] = []
    fileprivate var totalCount: Int = 0
    fileprivate var arrayCount: Int = 0
    fileprivate weak var timer: Timer?
    fileprivate var timeInterval: CGFloat = 2.0
    fileprivate var isHiddenPageControl = false
    fileprivate var scrollDirction = UICollectionViewScrollDirection.horizontal
    
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!
    fileprivate weak var flowLayout: UICollectionViewFlowLayout!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSubViews()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.initSubViews()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
        let pageH:CGFloat = 16
        let pageY:CGFloat = self.bounds.height - pageH - CGFloat(10);
        let pageW:CGFloat = self.bounds.width
        self.pageControl.frame = CGRect(x: 0, y: pageY, width: pageW, height: pageH)
        self.flowLayout.itemSize = mySize
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        if let _ = newSuperview {
            self.removeTimer()
        }
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
}

public extension BGScrollView {
    func showStyle(_ style: BGScrollViewShowStyle) {
        self.showStyle = style
        self.collectionView.reloadData()
    }
    
    func runNumbers(_ number: Int) {
        self.runNumbers = (number > 0 ? number : 1)
        if self.isUnlimited == false {
            self.resetValueForProperty()
        }
    }
    
    func isUnlimited(_ limited: Bool) {
        self.isUnlimited = limited
        self.resetValueForProperty()
    }
    
    func imageArray(_ array: [String]) {
        self.imageArray = array
        self.resetValueForProperty()
    }
    
    func textArray(_ array: [(String, String)]) {
        self.textArray = array
        self.resetValueForProperty()
    }
    
    func timeInterval(_ intervar: CGFloat) {
        self.timeInterval = (intervar > 0 ? intervar : 2)
        self.removeTimer()
        self.addTimer()
    }
    
    func isHiddenPageControl(_ hidden: Bool) {
        self.isHiddenPageControl = hidden
        self.pageControl.isHidden = hidden
    }
    
    func scrollDirction(_ dirction: UICollectionViewScrollDirection) {
        self.flowLayout.scrollDirection = dirction
    }
    
    func reloadData(){
        self.collectionView.reloadData()
    }
    
    
    
    
    
//    func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
//        self.collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
//    }
//
//    func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
//        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
//    }
//
//    func dequeueReusableCell(withReuseIdentifier identifier: String, for index: Int) -> UICollectionViewCell {
//        let indexPath = IndexPath(item: index, section: 0)
//        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
//        return cell
//    }
}

fileprivate extension BGScrollView {
    func initSubViews() {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.flowLayout = flowLayout
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.collectionView.dataSource = self
        self.collectionView.delegate =  self
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.scrollsToTop = false
        self.collectionView.bounces = false
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
        self.collectionView.register(BSImageCell.self, forCellWithReuseIdentifier: "BSImageCell")
        self.collectionView.register(BSLabelCell.self, forCellWithReuseIdentifier: "BSLabelCell")
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: errorCellReuseId)
        
        self.pageControl = UIPageControl.init()
        self.pageControl.isUserInteractionEnabled = false
        
        self.addSubview(self.collectionView)
        self.addSubview(self.pageControl)
    }
    
    func resetValueForProperty() {
        self.removeTimer()
        self.collectionView.scrollRectToVisible(self.bounds, animated: false)
        switch self.showStyle {
        case .image:
            arrayCount = self.imageArray.count
        case .text:
            arrayCount = self.textArray.count
        default:
            break
        }
        self.pageControl.numberOfPages = arrayCount
        self.pageControl.isHidden = arrayCount < 2
        self.pageControl.isHidden = self.isHiddenPageControl
        self.collectionView.isScrollEnabled = arrayCount > 1
        if arrayCount > 1 {
            self.addTimer()
        }else {
            self.removeTimer()
        }
        if self.isUnlimited {
            self.totalCount = arrayCount * 200
        }else {
            self.totalCount = arrayCount * (runNumbers > 0 ? runNumbers : 0)
        }
        if arrayCount == 1 {
            self.totalCount = 1
            self.removeTimer()
        }
        self.totalCount = (totalCount < 0 ? 0 : totalCount)
        self.collectionView.reloadData()
    }
    
    func addTimer() {
        self.removeTimer()
        let timer = Timer.init(timeInterval: TimeInterval(self.timeInterval), target: self, selector: #selector(BGScrollView.timerChanged), userInfo: nil, repeats: true)
        timer.fireDate = Date.init(timeIntervalSinceNow: TimeInterval(self.timeInterval))
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        self.timer = timer
    }
    func removeTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func timerChanged() {
        if 0 == self.totalCount { return }
        if self.timer == nil {return}
        let currentIndex = self.currentIndex()
        let targetIndex = currentIndex + 1
        self.scrollToIndex(targetIndex)
    }
    
    func currentIndex() -> Int {
        if myW <= 0 || myH <= 0 { return 0 }
        var index = 0
        if flowLayout.scrollDirection == UICollectionViewScrollDirection.horizontal {
            let offsetX = collectionView.contentOffset.x
            let flowW   = flowLayout.itemSize.width
            let result = Float(offsetX / flowW)
            index = Int(roundf(result))
        }else {
            let offsetY = collectionView.contentOffset.y
            let flowH   = flowLayout.itemSize.height
            let result = Float(offsetY / flowH)
            index = Int(roundf(result))
        }
        return index > 0 ? index : 0
    }
    
    func scrollToIndex(_ index: Int) {
        var indexPath = IndexPath(item: index, section: 0)
        if index < totalCount {
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.init(rawValue: 0), animated: true)
            return
        }
        if self.isUnlimited {
            //            let page = self.totalCount / 2
            indexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.init(rawValue: 0), animated: false)
        }
        return
    }
    
    func transformIndex(_ index: Int) -> Int {
        if self.arrayCount <= 0 { return 0 }
        return (index % self.arrayCount)
    }
    
    var myW: CGFloat {
        return self.bounds.size.width
    }
    var myH: CGFloat {
        return self.bounds.size.height
    }
    var mySize: CGSize {
        return self.bounds.size
    }
}

extension BGScrollView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.transformIndex(indexPath.item)
        self.delegate?.autoScrollView?(self, didSelectItemAt: index)
        self.selectedBlock?(index)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.arrayCount <= 0 { return }
        let itemIndex = self.currentIndex()
        let currentPage = self.transformIndex(itemIndex)
        self.pageControl.currentPage = currentPage
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.removeTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.addTimer()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(self.collectionView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if self.arrayCount <= 0 { return }
        let itemIndex = self.currentIndex()
        let currentPage = self.transformIndex(itemIndex)
        self.scrollToIndexBlock?(currentPage)
        self.delegate?.autoScrollView?(self, didScrollTo: currentPage)
    }
}


extension BGScrollView : UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.totalCount
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = self.dataSource?.autoScrollView?(self, cellForItemAt: indexPath.row) {
//            return cell
//        }
        switch self.showStyle {
        case .image:
            let cell = self.getImageCell(collectionView, indexPath)
            return cell
        case .text:
            let cell = self.getLabelCell(collectionView, indexPath)
            return cell
        default:
//            let cell = self.de
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: errorCellReuseId, for: indexPath)
            return cell
        }
    }
    
    func getImageCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSImageCell", for: indexPath) as! BSImageCell
        if self.imageArray.count <= 0{
            cell.imageView.image = self.placeholderImage
            return cell
        }
        let item = transformIndex(indexPath.item)
        let imagePath = self.imageArray[item]
        if imagePath.hasPrefix("http") {
            let imgURL = URL.init(string: imagePath)
            cell.imageView.sd_setImage(with: imgURL, placeholderImage: self.placeholderImage, options: SDWebImageOptions.highPriority, completed: nil)
        }else {
            var image = UIImage(named: imagePath)
            if image == nil {
                image = UIImage(contentsOfFile: imagePath)
            }
            cell.imageView.image = (image ?? self.placeholderImage)
        }
        return cell
    }
    
    func getLabelCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSLabelCell", for: indexPath) as! BSLabelCell
        let item = transformIndex(indexPath.item)
        if self.textArray.count <= 0{
            cell.leftLabel.text = ""
            cell.rightLabel.text = ""
            return cell
        }
        let (left, right) = self.textArray[item]
        cell.leftLabel.text = left
        cell.rightLabel.text = right
        return cell
    }
    
}


fileprivate class BSImageCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpSubviews()
    }
    
    private func setUpSubviews() {
        self.backgroundColor = UIColor.white
        self.imageView = UIImageView.init()
        self.contentView.addSubview(self.imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
    }
}

fileprivate class BSLabelCell: UICollectionViewCell {
    
    var leftLabel: UILabel!
    var rightLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpSubviews()
    }
    
    private func setUpSubviews() {
        self.backgroundColor = UIColor.white
        self.leftLabel = UILabel.init()
        self.leftLabel.textColor = UIColor(hex: "6A6A77")
        self.leftLabel.font = UIFont.systemFont(ofSize: 13)
        self.leftLabel.numberOfLines = 2
        self.leftLabel.textAlignment = NSTextAlignment.left
        self.leftLabel.contentMode = UIViewContentMode.center
        self.rightLabel = UILabel.init()
        self.rightLabel.textColor = UIColor(hex: "9EA4AF")
        self.rightLabel.font = UIFont.systemFont(ofSize: 13)
        self.rightLabel.numberOfLines = 1
        self.rightLabel.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(self.leftLabel)
        self.contentView.addSubview(self.rightLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.bounds.size.width
        let h = self.bounds.size.height
        let rightW = CGFloat(190.0 * 0.5)
        let leftW = w - rightW
        let leftRect  = CGRect(x: 0, y: 0, width: leftW, height: h)
        let rightRect = CGRect(x: leftW, y: 0, width: rightW, height: h)
        self.leftLabel.frame = leftRect
        self.rightLabel.frame = rightRect
    }
}

//
//  RollView.swift
//  BuildAnInfiniteCarousel
//
//  Created by 哇不哇哈哈 on 15/12/25.
//  Copyright © 2015年 wabuwahaha. All rights reserved.
//


/**

ios7之后的特性

自带系统导航栏需要在 viewDidLoad() 方法加上 self.automaticallyAdjustsScrollViewInsets = false

如果你的 UIScrollView 老是在你不希望它滚动的方向的滚动，而且里面的 imageView 还有可能错位的话，在 viewDidLoad 方法中加入这句：
_scrollView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
 
*/

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


/// 显示样式
enum PositionStyle {
    case none,left,center,right
}

class RollView: UIView, UIScrollViewDelegate {
    
    // MARK: - control
    /// scrollView
    fileprivate var _scrollView: UIScrollView?
    /// pageControl
    fileprivate var _pageControl: UIPageControl?
    /// titleLabel
    var _titleLabel: UILabel?
    /// placeHoldImage
    fileprivate var placeHoldImage: UIImage?
    
    // 循环滚动的三个视图
    fileprivate var _leftImageView: UIImageView?
    fileprivate var _centerImageView: UIImageView?
    fileprivate var _rightImageView: UIImageView?
    
    // MARK: - var
    // 循环滚动的三个视图的位置
    fileprivate var leftImageIndex: Int?
    fileprivate var centerImageIndex: Int?
    fileprivate var rightImageIndex: Int?
    
    /// 用于确定人为滚动还是自动滚动  true:自动滚动true, false: 人为滚动(如果是人为滚动，计时器重新计时)
    fileprivate var isTimeUp = true
    /// 计时器
    fileprivate var moveTimer: Timer?
    
    /// 图片显示的宽度
    fileprivate var rollWidth:CGFloat = 0
    /// 图片显示的高度
    fileprivate var rollHeight:CGFloat = 0
    
    /// 设置page显示位置(默认不显示)
    var pageControlShowStyle = PositionStyle.none {
        didSet {
            updatePageControlShowStyle(pageControlShowStyle)
        }
    }
    /// 设置标题显示的位置(默认不显示)
    var titleLabelShowStyle = PositionStyle.none {
        didSet {
            updateTitleLabelShowStyle(titleLabelShowStyle)
        }
    }
    /// 是否循环滚动(默认true)
    var isNeedCycleRoll = true {
        didSet {
            setupTimer(moveTime)
        }
    }
    
    /// 图片滚动时间差(默认3.0s)
    var moveTime: Double = 3.0 {
        didSet {
            setupTimer(moveTime)
        }
    }
    /// 图片url数组
    var imageLinkURLArray: Array<String> = [] {
        didSet {
            guard !imageLinkURLArray.isEmpty else {debugPrint("图片url数组为空"); return}
            updateImageUI(imageLinkURLArray)
        }
    }
    /// 标题数组
    var titleArray: Array<String>? {
        didSet {
            guard let titleArray = titleArray , !titleArray.isEmpty else {debugPrint("标题数组为空"); return}
            updateTitleLabelUI(titleArray)
        }
    }
    
    /// currentPageIndicatorTintColor
    var currentPageIndicatorTintColor:UIColor = UIColor.blue {
        didSet(newValue) {
            if let pageControl = _pageControl {
                pageControl.currentPageIndicatorTintColor = newValue
            }
        }
    }
    /// pageIndicatorTintColor
    var pageIndicatorTintColor:UIColor = UIColor.white {
        didSet(newValue) {
            if let pageControl = _pageControl {
                pageControl.pageIndicatorTintColor = newValue
            }
        }
    }
    
    // MARK: - block
    /// 点击图片的回调方法
    var didSelectImage: ((_ index: Int, _ imageView:UIImageView, _ imageURL: String) -> Void)?
    
    
    // MARK: - init
    /// 初始化轮播图
    ///
    /// - parameter frame: frame
    /// - parameter imageLinkURLArray: 图片链接
    /// - parameter placeHolderImage: 图片占位图
    /// - parameter titleArray: 标题数组
    /// - parameter pageControlShowStyle: pageControl显示位置
    /// - parameter titleLabelShowStyle: titleLabel显示位置
    /// - parameter isNeedCycleRoll: 是否需要自动滚动
    init(frame: CGRect, imageLinkURLArray: [String]?, placeHolderImage: UIImage?, titleArray: [String]?, pageControlShowStyle: PositionStyle?, titleLabelShowStyle: PositionStyle?, isNeedCycleRoll: Bool) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 1.0 , alpha: 0.0)
        rollHeight = frame.height
        rollWidth  = frame.width

        
        if let placeHolderImage = placeHolderImage {
            self.placeHoldImage = placeHolderImage
        }
        
        if let pageControlShowStyle = pageControlShowStyle {
            self.pageControlShowStyle = pageControlShowStyle
        }
        
        if let titleLabelShowStyle = titleLabelShowStyle {
            self.titleLabelShowStyle = titleLabelShowStyle
        }
        
        if let imageLinkURLArray = imageLinkURLArray {
            self.imageLinkURLArray = imageLinkURLArray
            self.updateImageUI(imageLinkURLArray)
        }
        
        if let titleArray = titleArray {
            self.titleArray = titleArray
            self.updateTitleLabelUI(titleArray)
        }

        self.isNeedCycleRoll = isNeedCycleRoll
        self.setupTimer(moveTime)
    }
    /// 初始化轮播图
    ///
    /// - parameter frame: frame
    /// - parameter imageLinkURLArray: 图片链接
    /// - parameter placeHolderImage: 图片占位图
    /// - parameter pageControlShowStyle: pageControl显示位置
    /// - parameter isNeedCycleRoll: 是否需要自动滚动
    convenience init(frame: CGRect, imageLinkURLArray: [String]?, placeHolderImage: UIImage?, pageControlShowStyle: PositionStyle, isNeedCycleRoll: Bool) {
        self.init(frame: frame, imageLinkURLArray: imageLinkURLArray, placeHolderImage: placeHolderImage, titleArray: nil, pageControlShowStyle: pageControlShowStyle, titleLabelShowStyle: nil, isNeedCycleRoll: isNeedCycleRoll)
    }
    /// 初始化轮播图
    ///
    /// - parameter frame: frame
    /// - parameter placeHolderImage: 图片占位图
    /// - parameter pageControlShowStyle: pageControl显示位置
    /// - parameter isNeedCycleRoll: 是否需要自动滚动
    convenience init(frame: CGRect, placeHolderImage: UIImage?, pageControlShowStyle: PositionStyle, isNeedCycleRoll: Bool) {
        self.init(frame: frame, imageLinkURLArray: nil, placeHolderImage: placeHolderImage, titleArray: nil, pageControlShowStyle: pageControlShowStyle, titleLabelShowStyle: nil, isNeedCycleRoll: isNeedCycleRoll)
    }
    /// 初始化轮播图
    ///
    /// - parameter frame: frame
    /// - parameter placeHolderImage: 图片占位图
    /// - parameter titleArray: 标题数组
    /// - parameter titleLabelShowStyle: titleLabel显示位置
    /// - parameter isNeedCycleRoll: 是否需要自动滚动
    convenience init(frame: CGRect, placeHolderImage: UIImage?, titleArray: [String]?, titleLabelShowStyle: PositionStyle, isNeedCycleRoll: Bool) {
        self.init(frame: frame, imageLinkURLArray: nil, placeHolderImage: placeHolderImage, titleArray: titleArray, pageControlShowStyle: nil, titleLabelShowStyle: titleLabelShowStyle, isNeedCycleRoll: isNeedCycleRoll)
    }
    /// 初始化轮播图
    ///
    /// - parameter frame: frame
    /// - parameter imageLinkURLArray: 图片链接
    /// - parameter placeHolderImage: 图片占位图
    /// - parameter isNeedCycleRoll: 是否需要自动滚动
    convenience init(frame: CGRect, imageLinkURLArray: [String]?, placeHolderImage: UIImage?, isNeedCycleRoll: Bool) {
        self.init(frame: frame, imageLinkURLArray: imageLinkURLArray, placeHolderImage: placeHolderImage, titleArray: nil, pageControlShowStyle: nil, titleLabelShowStyle: nil, isNeedCycleRoll: isNeedCycleRoll)
    }
    /// 初始化轮播图
    ///
    /// - parameter frame: frame
    /// - parameter placeHolderImage: 图片占位图
    /// - parameter isNeedCycleRoll: 是否需要自动滚动
    convenience init(frame: CGRect, placeHolderImage: UIImage?, isNeedCycleRoll: Bool) {
        self.init(frame: frame, imageLinkURLArray: nil, placeHolderImage: placeHolderImage, titleArray: nil, pageControlShowStyle: nil, titleLabelShowStyle: nil, isNeedCycleRoll: isNeedCycleRoll)
    }
    /// 初始化轮播图
    ///
    /// - parameter frame: frame
    /// - parameter imageLinkURLArray: 图片链接
    /// - parameter isNeedCycleRoll: 是否需要自动滚动
    convenience init(frame: CGRect, imageLinkURLArray: [String]?, isNeedCycleRoll: Bool) {
        self.init(frame: frame, imageLinkURLArray: imageLinkURLArray, placeHolderImage: nil, titleArray: nil, pageControlShowStyle: nil, titleLabelShowStyle: nil, isNeedCycleRoll: isNeedCycleRoll)
    }
    /// 初始化轮播图
    ///
    /// - parameter frame: frame
    /// - parameter imageLinkURLArray: 图片链接
    /// - parameter isNeedCycleRoll: 是否需要自动滚动
    convenience init(frame: CGRect, isNeedCycleRoll: Bool) {
        self.init(frame: frame, imageLinkURLArray: nil, placeHolderImage: nil, titleArray: nil, pageControlShowStyle: nil, titleLabelShowStyle: nil, isNeedCycleRoll: isNeedCycleRoll)
    }
    /// 初始化轮播图
    ///
    /// - parameter frame: frame
    /// - parameter pageControlShowStyle: pageControl显示位置
    /// - parameter isNeedCycleRoll: 是否需要自动滚动
    convenience init(frame: CGRect, pageControlShowStyle: PositionStyle, isNeedCycleRoll: Bool) {
        self.init(frame: frame, imageLinkURLArray: nil, placeHolderImage: nil, titleArray: nil, pageControlShowStyle: pageControlShowStyle, titleLabelShowStyle: nil, isNeedCycleRoll: isNeedCycleRoll)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = self.bounds.width
        let h = self.bounds.height
        rollWidth = w
        rollHeight = h
        
        _scrollView?.frame = self.bounds
        _scrollView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        _scrollView?.contentOffset = CGPoint(x: imageLinkURLArray.count == 1 ? 0 : w, y: 0)
        _scrollView?.contentSize = CGSize(width: imageLinkURLArray.count == 1 ? w : w * 3, height: h)
        
        _leftImageView?.frame = CGRect(x: 0, y: 0, width: w, height: h)
        _centerImageView?.frame = CGRect(x: w, y: 0, width: w, height: h)
        _rightImageView?.frame = CGRect(x: 2 * w, y: 0, width: w, height: h)
        
        _pageControl?.numberOfPages = imageLinkURLArray.count
        updatePageControlShowStyle(pageControlShowStyle)
    }
    
    // MARK: - setup
    /// 初始化ScrollView
    fileprivate func setupScrollView() {
        if _scrollView == nil {
            _scrollView = UIScrollView(frame: self.bounds)
            _scrollView?.bounces = false
            _scrollView?.delegate = self
            _scrollView?.isPagingEnabled = true
            _scrollView?.showsHorizontalScrollIndicator = false
            _scrollView?.showsVerticalScrollIndicator = false
            _scrollView?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
            _scrollView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            self.insertSubview(_scrollView!, at: 0)
        }
        for subview in _scrollView!.subviews {
            subview.removeFromSuperview()
        }
        
        let imgViewHeight = _scrollView?.bounds.height
        _leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: rollWidth, height: imgViewHeight!))
        _scrollView?.addSubview(_leftImageView!)
        
        if (imageLinkURLArray.count == 1) {//只有一个数据
            _leftImageView?.isUserInteractionEnabled = true
            _leftImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RollView.tapImageView)))
            return
        }
        
        _centerImageView = UIImageView(frame: CGRect(x: rollWidth, y: 0, width: rollWidth, height: imgViewHeight!))
        _centerImageView?.isUserInteractionEnabled = true
        _centerImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RollView.tapImageView)))
        _scrollView?.addSubview(_centerImageView!)
        
        _rightImageView = UIImageView(frame: CGRect(x: 2 * rollWidth, y: 0, width: rollWidth, height: imgViewHeight!))
        _scrollView?.addSubview(_rightImageView!)
    }
    /// 初始化PageControl
    fileprivate func setupPageControl() {
        if _pageControl == nil {
            _pageControl = UIPageControl()
            _pageControl?.numberOfPages = imageLinkURLArray.count
            _pageControl?.currentPage = 0
            _pageControl?.isEnabled = false
            _pageControl?.pageIndicatorTintColor = pageIndicatorTintColor
            _pageControl?.currentPageIndicatorTintColor = currentPageIndicatorTintColor
            self.addSubview(_pageControl!)
        }
    }
    /// 初始化TitleLabel
    fileprivate func setupTitleLabel() {
        if _titleLabel == nil {
            let layer = UIView(frame: CGRect(x: 0, y: rollHeight - 20, width: rollWidth, height: 20))
            layer.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            self.addSubview(layer)
            self.bringSubview(toFront: _pageControl!)
            
            _titleLabel = UILabel(frame: CGRect(x: 5, y: rollHeight - 20, width: rollWidth - 20, height: 20))
            _titleLabel?.textColor = UIColor.white
            _titleLabel?.font = UIFont.systemFont(ofSize: 14)
            self.addSubview(_titleLabel!)
        }
    }
    /// 初始化定时器
    fileprivate func setupTimer(_ time:Double) {
        moveTimer?.invalidate()
        moveTimer = nil
        
        if isNeedCycleRoll {//需要自动滚动
            moveTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(RollView.animalMoveImage), userInfo: nil, repeats: true)
            isTimeUp = false
        }
    }
    
    // MARK: - update
    /// 更新ImageUI
    /// - parameter imageUrls: 图片链接数组
    fileprivate func updateImageUI(_ imageUrls:[String]) {
        setupScrollView()
        
        _scrollView?.contentOffset = CGPoint(x: imageUrls.count == 1 ? 0 : rollWidth, y: 0)
        _scrollView?.contentSize = CGSize(width: imageUrls.count == 1 ? rollWidth : rollWidth * 3, height: rollHeight)
        
        if imageUrls.count == 1 {
            centerImageIndex = 0 //点击事件的位置
            _leftImageView?.sd_setImage(with: URL(string: imageUrls[0])!, placeholderImage: placeHoldImage)
            return
        }
        
        leftImageIndex = imageUrls.count - 1
        centerImageIndex = 0
        rightImageIndex = 1

        _leftImageView?.sd_setImage(with: URL(string: imageUrls[leftImageIndex!])!, placeholderImage: placeHoldImage)
        _centerImageView?.sd_setImage(with: URL(string: imageUrls[centerImageIndex!])!, placeholderImage: placeHoldImage)
        _rightImageView?.sd_setImage(with: URL(string: imageUrls[rightImageIndex!])!, placeholderImage: placeHoldImage)
    }
    /// 更新TitleLabelUI显示样式
    /// - parameter texts: 标题数组
    fileprivate func updateTitleLabelUI(_ texts:[String]) {
        setupTitleLabel()
        
        if let centerImageIndex = centerImageIndex {
            _titleLabel?.text = texts[centerImageIndex]
        }
        
        updateTitleLabelShowStyle(titleLabelShowStyle)
    }
    /// 更新PageControl显示样式
    /// - parameter showStyle: PositionStyle
    fileprivate func updatePageControlShowStyle(_ showStyle:PositionStyle) {
        if showStyle == .none {return}
        
        setupPageControl()
        
        let _pageControlWidth = CGFloat(20 * _pageControl!.numberOfPages)
        let _pageControlHeight: CGFloat = 20
        
        switch showStyle {
        case .center:
            _pageControl?.frame = CGRect(x: 0,
                                            y: rollHeight - _pageControlHeight,
                                            width: rollWidth,
                                            height: _pageControlHeight
            )
        case .left:
            _pageControl?.frame = CGRect(x: 0,
                                            y: rollHeight - _pageControlHeight,
                                            width: _pageControlWidth,
                                            height: _pageControlHeight
            )
        case .right:
            _pageControl?.frame = CGRect(x: rollWidth - _pageControlWidth,
                                            y: rollHeight - _pageControlHeight,
                                            width: _pageControlWidth,
                                            height: _pageControlHeight
            )
        default: break
        }
    }
    /// 更新TitleLabel显示样式
    /// - parameter showStyle: PositionStyle
    fileprivate func updateTitleLabelShowStyle(_ showStyle:PositionStyle) {
        if showStyle == .none {return}
        
        switch showStyle {
        case .center:
            _titleLabel?.textAlignment = .center
        case .left:
            _titleLabel?.textAlignment = .left
        case .right:
            _titleLabel?.textAlignment = .right
        default: break
        }
    }
    
    // MARK: - 图片点击事件
    @objc func tapImageView() {
        if let didSelectImage = didSelectImage,let centerImageIndex = centerImageIndex , !imageLinkURLArray.isEmpty {
            didSelectImage(centerImageIndex, imageLinkURLArray.count == 1 ? _leftImageView! : _centerImageView!, imageLinkURLArray[centerImageIndex])
        }
    }
    
    // MARK: - 这个方法会在子视图添加到父视图或者离开父视图时调用
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
                moveTimer?.invalidate()
                moveTimer = nil
        } else {
            if isNeedCycleRoll && imageLinkURLArray.count > 1 {
                setupTimer(moveTime)
            }
        }
    }
    
    // MARK: - 计时器执行方法(自动滚动)
    @objc fileprivate func animalMoveImage() {
        isTimeUp = true
        _scrollView?.setContentOffset(CGPoint(x: rollWidth * 2, y: 0), animated: true)
        
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:)), userInfo: nil, repeats: false)
    }
    
    // MARK: - UIScrollViewDelegate
    // 图片停止时,调用该函数使得滚动视图复用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if imageLinkURLArray.count == 0 { return }
        
        let offsetX = _scrollView!.contentOffset.x
        
        if offsetX == 0 {
            leftImageIndex      = leftImageIndex! - 1
            centerImageIndex    = centerImageIndex! - 1
            rightImageIndex     = rightImageIndex! - 1
            
            if leftImageIndex   == -1 {
                leftImageIndex      = imageLinkURLArray.count - 1
            }
            if centerImageIndex == -1 {
                centerImageIndex    = imageLinkURLArray.count - 1
            }
            if rightImageIndex  == -1 {
                rightImageIndex     = imageLinkURLArray.count - 1
            }
        } else if offsetX == rollWidth * 2 {
            leftImageIndex      = leftImageIndex! + 1
            centerImageIndex    = centerImageIndex! + 1
            rightImageIndex     = rightImageIndex! + 1
            
            if leftImageIndex   == imageLinkURLArray.count {
                leftImageIndex      = 0
            }
            if centerImageIndex == imageLinkURLArray.count {
                centerImageIndex    = 0
            }
            if rightImageIndex  == imageLinkURLArray.count {
                rightImageIndex     = 0
            }
        } else {
            return
        }
        
        _leftImageView?.sd_setImage(with: URL(string: imageLinkURLArray[leftImageIndex!])!, placeholderImage: placeHoldImage)
        _centerImageView?.sd_setImage(with: URL(string: imageLinkURLArray[centerImageIndex!])!, placeholderImage: placeHoldImage)
        _rightImageView?.sd_setImage(with: URL(string: imageLinkURLArray[rightImageIndex!])!, placeholderImage: placeHoldImage)

        _scrollView?.contentOffset = CGPoint(x: rollWidth, y: 0)
        
        if let pageControl = _pageControl {
            pageControl.currentPage = centerImageIndex!
        }
        
        // 有标题加标题
        if let titleArray = titleArray , centerImageIndex < titleArray.count {
            _titleLabel?.text = titleArray[centerImageIndex!]
        }
        
        if !isTimeUp && moveTimer != nil {
            moveTimer?.fireDate = Date(timeIntervalSinceNow: moveTime)
        }
        isTimeUp = false
    }
    // 人为滚动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard moveTimer != nil else { return }
        
        moveTimer?.invalidate()
        moveTimer = nil
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupTimer(moveTime)
    }

}

//
//  PopoverCategoryView.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

protocol PopoverCategoryViewDelegate: NSObjectProtocol {
    func selectedCategoryEndWithIndex(_ index: NSInteger)
}

class PopoverCategoryView: UIView {

    weak var delegate: PopoverCategoryViewDelegate?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var switchBtn: UIButton!
    @IBOutlet weak var switchCover: UIView!
    
    /// 分类标题
    var categoryTitles:[NSString]? {
        didSet {
            /// 滚动的分类视图
            createScrollCategory(categoryTitles!)
            /// 弹出的分类视图
            popoverView = createPopoverView(categoryTitles!)
        }
    }
    /// 弹出分类视图的按钮列数
    let popverBtnColumn = 4
    /// 缓存滚动分类按钮
    var cacheScrollCategoryBtns = [UIButton]()
    /// 缓存格子分类按钮
    var cacheSquareCategoryBtns = [UIButton]()
    /// 当前所选的滚动分类按钮
    var selectedScrollCategoryBtn:UIButton?
    /// 当前所选的格子分类按钮
    var selectedSquareCategoryBtn:UIButton?
    /// 弹出的格子分类视图
    var popoverView:UIView?
    /// 是否显示格子分类视图
    var showingPopoverView = false
    
    class func popoverCategoryView() -> PopoverCategoryView {
        let view =  Bundle.main.loadNibNamed("PopoverCategoryView", owner: nil, options: nil)!.last as! PopoverCategoryView
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUIFrame()
    }
    
    // MARK: - 视图
    fileprivate func setupUI() {
        backgroundColor = UIColor.white
        /// 添加滚动红线
        scrollView.addSubview(scrollBottomLineView)
        /// 给蒙版绑定点击事件
        let hideMaskCoverViewPan = UITapGestureRecognizer(target: self, action: #selector(PopoverCategoryView.hidePopoverView))
        maskCoverView.addGestureRecognizer(hideMaskCoverViewPan)
    }
    
    fileprivate func setupUIFrame() {
        /// 设置scrollView contentSize
        if let lastCategoryBtn = cacheScrollCategoryBtns.last {
            scrollView.contentSize = CGSize(width: lastCategoryBtn.frame.maxX, height: 0)
        }
        /// 设置底部线条frame
        if let categoryBtn = selectedScrollCategoryBtn {
            scrollBottomLineView.center = CGPoint(x: categoryBtn.center.x, y: bounds.height - 2.0)
            scrollBottomLineView.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: categoryBtn.bounds.width - 10.0, height: 2.0))
        }
    }
    fileprivate func createBtn(_ title: NSString) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title as String, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        btn.setTitleColor(UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0), for: UIControlState())
        btn.setTitleColor(UIColor(red: 251.0/255.0, green: 45.0/255.0, blue: 71.0/255.0, alpha: 1.0), for: UIControlState.selected)
        return btn
    }
    
    fileprivate func createVerticalLine(_ frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = Color_GlobalLine
        return view
    }
    
    fileprivate func createHorizontalLine(_ frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = Color_GlobalLine
        return view
    }
    
    fileprivate func createScrollCategory(_ titles: [NSString]) {
        for i in 0..<titles.count {
            let title = titles[i]
            let btn = createBtn(title)
            btn.tag = i
            let width:CGFloat = title.boundingRect(with: CGSize.zero, options: NSStringDrawingOptions(rawValue: 0), attributes: [NSFontAttributeName : btn.titleLabel!.font], context: nil).width + 20
            let x:CGFloat = cacheScrollCategoryBtns.last == nil ? 5.0 : cacheScrollCategoryBtns.last!.frame.maxX
            btn.frame = CGRect(x: x, y: 0, width: width, height: 44.0)
            btn.addTarget(self, action: #selector(PopoverCategoryView.scrollCategoryBtnAction(_:)), for: UIControlEvents.touchUpInside)
            scrollView.addSubview(btn)
            cacheScrollCategoryBtns.append(btn)
            if i == 0 { scrollCategoryBtnAction(btn)}
        }
    }
    
    fileprivate func createPopoverView(_ titles:[NSString]) -> UIView {
        let btnWidth = ScreenWidth / CGFloat(popverBtnColumn)
        let btnHeight:CGFloat = 50.0
        let popoverView = UIView()
        for i in 0..<titles.count {
            let column = i % popverBtnColumn;
            let row = i / popverBtnColumn
            let x = btnWidth * CGFloat(column)
            let y = btnHeight * CGFloat(row);
            let btn = createBtn(titles[i])
            btn.tag = i
            btn.frame = CGRect(x: x, y: y, width: btnWidth, height: btnHeight)
            btn.addTarget(self, action: #selector(PopoverCategoryView.squareCategoryBtnAction(_:)), for: UIControlEvents.touchUpInside)
            popoverView.addSubview(btn)
            cacheSquareCategoryBtns.append(btn)
            /// 线条
            btn.addSubview(createVerticalLine(CGRect(x: btn.bounds.width - 0.5, y: 0, width: 0.5, height: btn.bounds.height)))
            btn.addSubview(createHorizontalLine(CGRect(x: 0, y: btn.bounds.height - 0.5, width: btn.bounds.width, height: 0.5)))
            if i == 0 { squareCategoryBtnAction(btn)}
        }
        popoverView.addSubview(squareBottomLineView)
        popoverView.backgroundColor = UIColor.white
        popoverView.frame = CGRect(x: 0, y: -cacheSquareCategoryBtns.last!.frame.maxY, width: ScreenWidth, height: -cacheSquareCategoryBtns.last!.frame.maxY)
        return popoverView
    }
    
    // MARK: - 公共方法
    /**
     选择分类按钮
     
     - parameter index: 按钮索引
     */
    func scrollCategoryBtnByIndex(_ index: NSInteger) {
        scrollCategoryBtnAction(cacheScrollCategoryBtns[index])
    }
    
    // MARK: - 事件
    @IBAction func switchBtnAction(_ sender: UIButton) {
        if !sender.isSelected {
            showPopoverView()
        } else {
            hidePopoverView()
        }
    }
    
    @objc fileprivate func scrollCategoryBtnAction(_ sender: UIButton) {
        if let btn = selectedScrollCategoryBtn { btn.isSelected = false }
        sender.isSelected = !sender.isSelected
        selectedScrollCategoryBtn = sender
        /// 重设分类标签状态
        if sender.center.x < bounds.width * 0.5 {
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        } else if scrollView.contentSize.width > bounds.width && sender.center.x > bounds.width * 0.5 && sender.center.x < (scrollView.contentSize.width - bounds.width * 0.5) {
            scrollView.setContentOffset(CGPoint(x: sender.frame.origin.x + sender.bounds.width * 0.5 - bounds.width * 0.5, y: 0), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: max(scrollView.contentSize.width - scrollView.bounds.size.width, 0), y: 0), animated: true)
        }
        /// 重新调用layoutSubviews
        setNeedsLayout()
        delegate?.selectedCategoryEndWithIndex(sender.tag)
    }
    
    @objc fileprivate func squareCategoryBtnAction(_ sender: UIButton) {
        if let btn = selectedSquareCategoryBtn { btn.isSelected = false }
        sender.isSelected = !sender.isSelected
        selectedSquareCategoryBtn = sender
        squareBottomLineView.frame = CGRect(x: sender.frame.origin.x, y: sender.frame.maxY, width: sender.frame.width, height: 2.0)
        if showingPopoverView { hidePopoverView()}
    }
    
    /**
     显示筛选视图
     */
    fileprivate func showPopoverView() {
        backgroundColor = switchCover.backgroundColor
        switchBtn.isSelected = true
        switchCover.isHidden = false
        /// 选择格子分类按钮
        squareCategoryBtnAction(cacheSquareCategoryBtns[selectedScrollCategoryBtn!.tag])
        /// 显示蒙版
        showMaskCoverView()
        /// 显示筛选视图
        superview!.insertSubview(popoverView!, belowSubview: self)
        switchCover.alpha = 0
        showingPopoverView = true
        UIView.animate(withDuration: 0.3, animations: {
            self.switchCover!.alpha = 1.0
            self.popoverView!.frame.origin.y = self.bounds.height
        }) 
    }
    
    /**
     隐藏筛选视图
     */
    @objc fileprivate func hidePopoverView() {
        guard let _ = popoverView else {
            return
        }
        backgroundColor = UIColor.white
        switchBtn.isSelected = false
        switchCover.isHidden = true
        /// 选择格子分类按钮
        scrollCategoryBtnAction(cacheScrollCategoryBtns[selectedSquareCategoryBtn!.tag])
        ///  隐藏筛选视图
        UIView.animate(withDuration: 0.3, animations: {
            self.popoverView!.frame.origin.y = -self.popoverView!.bounds.height
            self.switchCover!.alpha = 0.0
        }, completion: { (_) in
            self.popoverView!.removeFromSuperview()
            self.showingPopoverView = false
        }) 
        /// 隐藏蒙版
        hideMaskCoverView()
    }
    
    /**
     显示蒙版
     */
    fileprivate func showMaskCoverView() {
        superview!.insertSubview(maskCoverView, belowSubview: self)
    }
    
    /**
     隐藏蒙版
     */
    @objc fileprivate func hideMaskCoverView() {
        maskCoverView.removeFromSuperview()
    }
    
    // MARK: - 懒加载
    fileprivate var scrollBottomLineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 251.0/255.0, green: 45.0/255.0, blue: 71.0/255.0, alpha: 1.0)
        return view
    }()
    
    fileprivate var squareBottomLineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 251.0/255.0, green: 45.0/255.0, blue: 71.0/255.0, alpha: 1.0)
        return view
    }()
    
    fileprivate lazy var maskCoverView: MaskCoverView = MaskCoverView()
    
    fileprivate lazy var createHLine: UIView = {
        let view = UIView()
        view.backgroundColor = Color_GlobalLine
        return view
    }()


}

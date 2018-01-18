//
//  ClassifyTitleView.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

protocol ClassifyTitleViewDelegate: NSObjectProtocol {
    func selectedOptionAtIndex(_ index: NSInteger)
}

class ClassifyTitleView: UIView {
    
    weak var delegate: ClassifyTitleViewDelegate?
    fileprivate var singleBtn:UIButton?
    fileprivate var strategyBtn:UIButton?
    fileprivate let lineMargin:CGFloat = 10.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUIFrame()
    }
    
    // MARK: - 视图
    fileprivate func setupUI() {
        backgroundColor = UIColor.clear
        strategyBtn = createBtn("攻略")
        strategyBtn?.addTarget(self, action: #selector(ClassifyTitleView.strategyBtnAction), for: UIControlEvents.touchUpInside)
        singleBtn = createBtn("单品")
        singleBtn?.addTarget(self, action: #selector(ClassifyTitleView.singleBtnAction), for: UIControlEvents.touchUpInside)
        addSubview(strategyBtn!)
        addSubview(singleBtn!)
        addSubview(line)
    }
    
    fileprivate func setupUIFrame() {
        strategyBtn?.frame = CGRect(x: 0, y: 0, width: frame.size.width * 0.5, height: frame.size.height)
        singleBtn?.frame = CGRect(x: strategyBtn!.frame.maxX, y: 0, width: frame.size.width * 0.5, height: frame.size.height)
        line.frame = CGRect(x: lineMargin * 0.5, y: frame.size.height - 6.0, width: frame.size.width * 0.5 - lineMargin, height: 2.0)
    }
    
    fileprivate func createBtn(_ titile: NSString) -> UIButton {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle(titile as String, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.setTitleColor(UIColor.white, for: UIControlState())
        return btn
    }
    
    // MARK: - 事件
    @objc fileprivate func strategyBtnAction() {
        delegate?.selectedOptionAtIndex(0)
    }
    
    @objc fileprivate func singleBtnAction() {
        delegate?.selectedOptionAtIndex(1)
    }
    
    // MARK: - 懒加载
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // MARK: - 公共方法
    func scrollLine(_ scrollViewWidth: CGFloat, offsetX: CGFloat) {
        line.frame.origin.x = lineMargin * 0.5 + offsetX / scrollViewWidth * (bounds.width - line.bounds.width - lineMargin)
    }


}

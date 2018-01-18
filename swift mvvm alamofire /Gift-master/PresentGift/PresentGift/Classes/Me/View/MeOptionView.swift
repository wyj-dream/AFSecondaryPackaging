//
//  MeOptionView.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class MeOptionView: UIView {

    var btns = [UIButton]()
    
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
    fileprivate func setupUI(){
        backgroundColor = UIColor.white
        addSubview(createBtn("shopcart_bt", title: "购物车"))
        addSubview(createBtn("order_bt", title: "订单"))
        addSubview(createBtn("discount_bt", title: "礼劵"))
        addSubview(createBtn("costomer_bt", title: "客服"))
        addSubview(line)
    }
    
    fileprivate func setupUIFrame() {
        var i = 0
        let width = frame.width / 4
        let height = frame.height
        for btn in btns {
            btn.frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height)
            btn.tag = i
            i += 1
        }
        line.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(0)
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.height.equalTo(0.5)
        }
    }
    
    fileprivate func createBtn(_ imageName: NSString, title: NSString) -> UIButton{
        let btn = ButtonTitleDown()
        btn.setTitle(title as String, for: UIControlState())
        btn.setTitleColor(UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0), for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setImage(UIImage(named: imageName as String), for: UIControlState())
        btn.addTarget(self, action: #selector(MeOptionView.buttonAction(_:)), for: UIControlEvents.touchUpInside)
        btns.append(btn)
        
        return btn
    }
    
    // MARK: - 懒加载
    fileprivate lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 208.0/255.0, green: 208.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        return line
    }()
    
    
    // MARK: - 事件
    @objc fileprivate func buttonAction(_ button: UIButton){
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notif_Login), object: nil)
    }


}

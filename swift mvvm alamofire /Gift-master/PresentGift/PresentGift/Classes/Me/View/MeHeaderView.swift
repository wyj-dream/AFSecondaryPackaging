//
//  MeHeaderView.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class MeHeaderView: UIView {

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
        backgroundColor = UIColor.yellow
        
        addSubview(bgimageView)
        addSubview(loginBtn)
        addSubview(nickLab)
        addSubview(meOptionView)
        
        loginBtn.addTarget(self, action: #selector(MeHeaderView.loginBtnAction), for: UIControlEvents.touchUpInside)
    }
    
    fileprivate func setupUIFrame() {
        loginBtn.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(90.0)
            make.left.equalTo((ScreenWidth - loginBtn.bounds.width) * 0.5)
        })
        nickLab.snp_makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp_bottom).offset(5.0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        meOptionView.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.width.equalTo(self.snp_width)
            make.height.equalTo(70.0)
        }
    }
    
    // MARK: - 懒加载
    lazy var bgimageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "me_profilebackground"))
        return imageView
    }()
    
    fileprivate lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "me_avatar_boy"), for: UIControlState())
        btn.sizeToFit()
        return btn
    }()
    
    fileprivate lazy var nickLab: UILabel = {
        let lab = UILabel()
        lab.text = "登陆"
        lab.textColor = UIColor.white
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textAlignment = NSTextAlignment.center
        lab.sizeToFit()
        return lab
    }()
    
    fileprivate lazy var meOptionView: UIView = {
        let meOptionView = MeOptionView()
        return meOptionView
    }()
    
    // MARK: - 事件
    @objc fileprivate func loginBtnAction() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notif_Login), object: nil)
    }

}

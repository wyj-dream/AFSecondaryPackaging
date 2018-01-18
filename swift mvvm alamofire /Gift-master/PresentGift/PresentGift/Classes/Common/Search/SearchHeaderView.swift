//
//  SearchHeaderView.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class SearchHeaderView: UIView {

    var temBtn:UIButton?
    let btnTitles = ["零食", "手机壳", "双肩包", "钱包", "凉鞋", "手表", "情侣", "泳衣", "杯子", "连衣裙", "手链", "宿舍"]
    var layoutUIFinishBlock: ((_ height: CGFloat)->())?
    
    init(layoutUIFinish: @escaping (_ height: CGFloat) -> ()) {
        super.init(frame: CGRect.zero)
        layoutUIFinishBlock = layoutUIFinish
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUIFrame()
    }
    
    // MARK: - 视图
    fileprivate func setupUI() {
        addSubview(titleLab)
        addSubview(line)
        addSubview(contentView)
        setupBtns()
    }
    
    fileprivate func setupUIFrame() {
        titleLab.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 30)
        line.frame = CGRect(x: 0, y: titleLab.frame.maxY, width: ScreenWidth, height: 0.5)
        if let btn = temBtn {
            contentView.frame = CGRect(x: 0, y: line.frame.maxY, width: ScreenWidth, height: btn.frame.maxY + 15)
        }
        /// 重新设置SearchHeaderView高度
        layoutUIFinishBlock!(contentView.frame.maxY)
    }
    
    fileprivate func setupBtns() {
        let marginX: CGFloat = 15.0
        let marginY: CGFloat = 15.0
        let height:CGFloat = 28.0
        
        for i in 0 ..< btnTitles.count {
            let tagBtn = createBtn()
            let titleStr = btnTitles[i] as NSString
            let width:CGFloat = titleStr.boundingRect(with: CGSize.zero, options: NSStringDrawingOptions(rawValue: 0), attributes: [NSFontAttributeName : tagBtn.titleLabel!.font], context: nil).width + 20 * 2
            
            tagBtn.tag = i
            tagBtn.setTitle(titleStr as String, for: UIControlState())
            tagBtn.addTarget(self, action: #selector(SearchHeaderView.tagBtnAction), for: UIControlEvents.touchUpInside)
            tagBtn.frame.size.width = width
            tagBtn.frame.size.height = height
            contentView.addSubview(tagBtn)
            
            if temBtn == nil {
                tagBtn.frame.origin.x = marginX
                tagBtn.frame.origin.y = marginY
            } else {
                let isWrap = ScreenWidth - temBtn!.frame.maxX - marginX < tagBtn.frame.size.width + marginX;
                if (isWrap) {
                    /// 换行
                    tagBtn.frame.origin.x = marginX;
                    tagBtn.frame.origin.y = temBtn!.frame.maxY + marginY;
                } else {
                    /// 不换行
                    tagBtn.frame.origin.x =  temBtn!.frame.maxX + marginX;
                    tagBtn.frame.origin.y = temBtn!.frame.origin.y;
                }
            }
            temBtn = tagBtn;
        }
    }
    
    fileprivate func createBtn() -> UIButton {
        let tagBtn = UIButton(type: UIButtonType.custom)
        tagBtn.titleLabel!.font = UIFont.systemFont(ofSize: 13.0)
        tagBtn.layer.cornerRadius = 3.0
        tagBtn.layer.masksToBounds = true
        tagBtn.layer.borderWidth = 0.5
        tagBtn.layer.borderColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0).cgColor
        tagBtn.setTitleColor(UIColor(red: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1.0), for: UIControlState())
        return tagBtn
    }
    
    // MARK: - 懒加载
    fileprivate lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.text = "    大家都在搜"
        lab.backgroundColor = Color_GlobalBackground
        lab.font = UIFont.systemFont(ofSize: 13.0)
        lab.textAlignment = NSTextAlignment.left
        lab.textColor = UIColor(red: 150.0/255.0, green: 150.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        return lab
    }()
    
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        return line
    }()
    
    // MARK: - 事件
    @objc fileprivate func tagBtnAction() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Notif_BtnAction_SearchTag"), object: nil)
    }
    

}

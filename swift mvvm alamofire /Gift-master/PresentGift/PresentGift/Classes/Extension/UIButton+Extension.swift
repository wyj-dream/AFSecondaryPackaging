//
//  UIButton+Extension.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(x: CGFloat, iconName: NSString, target: AnyObject?, action: Selector, imageEdgeInsets: UIEdgeInsets){
        self.init()
        frame = CGRect(x: x, y: 0, width: 44, height: 44)
        setImage(UIImage(named: iconName as String), for: UIControlState())
        setImage(UIImage(named: iconName as String), for: UIControlState.highlighted)
        self.imageEdgeInsets = imageEdgeInsets
        addTarget(target, action: action, for: UIControlEvents.touchUpInside)
    }
    
    /// 导航栏排序按钮
    convenience init(sortTarget: AnyObject?, action: Selector) {
        self.init()
        frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        setImage(UIImage(named: "icon_sort"), for: UIControlState())
        addTarget(sortTarget, action: action, for: UIControlEvents.touchUpInside)
    }
    
    /// 导航栏返回按钮
    convenience init(backTarget: AnyObject?, action: Selector) {
        self.init()
        setImage(UIImage(named: "back"), for: UIControlState())
        frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        addTarget(backTarget, action: action, for: UIControlEvents.touchUpInside)
    }
    
    /// 导航栏取消按钮
    convenience init(cancelTarget: AnyObject?, action: Selector) {
        self.init()
        setTitle("取消", for: UIControlState())
        frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        addTarget(cancelTarget, action: action, for: UIControlEvents.touchUpInside)
    }
    
    /// 选礼神器-筛选标签按钮
    convenience init(srotTagTarget: AnyObject?, action: Selector) {
        self.init()
        setBackgroundImage(UIImage.imageWithColor(UIColor.white, size: CGSize(width: 1, height: 1)), for: UIControlState())
        setBackgroundImage(UIImage.imageWithColor(UIColor(red: 251.0/255.0, green: 45.0/255.0, blue: 71.0/255.0, alpha: 1.0), size: CGSize(width: 1, height: 1)), for: UIControlState.selected)
        setBackgroundImage(UIImage.imageWithColor(UIColor.red, size: CGSize(width: 1, height: 1)), for: UIControlState.highlighted)
        setTitleColor(UIColor (red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0), for: UIControlState())
        setTitleColor(UIColor.white, for: UIControlState.selected)
        setTitleColor(UIColor.white, for: UIControlState.highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        layer.masksToBounds = true
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor (red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
        layer.borderWidth = 0.5
        addTarget(srotTagTarget, action: action, for: UIControlEvents.touchUpInside)
    }
}


//
//  UIBarButtonItem+Extension.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 礼物
    convenience init(gifTarget: AnyObject?, action: Selector){
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "feed_signin"), for: UIControlState())
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btn.addTarget(gifTarget, action: action, for: UIControlEvents.touchUpInside)
        self.init(customView: btn)
    }
    
    /// 搜索
    convenience init(searchTarget: AnyObject?, action: Selector){
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "icon_navigation_search"), for: UIControlState())
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        btn.addTarget(searchTarget, action: action, for: UIControlEvents.touchUpInside)
        self.init(customView: btn)
    }
    
    /// 选礼神器
    convenience init(chooseGifTarget: AnyObject?, action: Selector){
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        btn.setTitle("选礼神器", for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.setTitleColor(UIColor.white, for: UIControlState())
        btn.addTarget(chooseGifTarget, action: action, for: UIControlEvents.touchUpInside)
        self.init(customView: btn)
    }
}

//
//  NavigationController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer!.delegate = nil;
        
        let appearance = UINavigationBar.appearance()
        appearance.isTranslucent = false
        appearance.setBackgroundImage(UIImage.imageWithColor(Color_NavBackground, size: CGSize(width: 1, height: 1)), for: UIBarMetrics.default)
        var textAttrs: [String : AnyObject] = Dictionary()
        textAttrs[NSForegroundColorAttributeName] = UIColor.white
        textAttrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 16)
        appearance.titleTextAttributes = textAttrs
    }
    
    lazy var backBtn: UIButton = UIButton(backTarget: self, action: #selector(NavigationController.backBtnAction))
    
    func backBtnAction() {
        self.popViewController(animated: true)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count > 0 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}

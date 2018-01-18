//
//  TabbarController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController()
        // Do any additional setup after loading the view.
    }

    fileprivate func addChildViewController(){
        addChildViewController(HomeViewController(), title: "礼物说", imageName: "tabbar_home")
        addChildViewController(HotViewController(), title: "热门", imageName: "tabbar_gift")
        addChildViewController(ClassifyViewController(), title: "分类", imageName: "tabbar_category")
        addChildViewController(MeViewController(), title: "我", imageName: "tabbar_me")
    }
    
    fileprivate func addChildViewController(_ controller: UIViewController, title: String, imageName: String) {
        controller.tabBarItem.image = UIImage(named: imageName)
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")
        controller.tabBarItem.title = title
        
        let nav = NavigationController()
        nav.addChildViewController(controller)
        addChildViewController(nav)
    }

}

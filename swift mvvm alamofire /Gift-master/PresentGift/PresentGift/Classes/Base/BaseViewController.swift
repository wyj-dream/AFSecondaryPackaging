//
//  BaseViewController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.login), name: NSNotification.Name(rawValue: Notif_Login), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Notif_Login), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc fileprivate func login() {
        let sb = UIStoryboard(name: "LoginViewController", bundle: nil)
        let login = sb.instantiateInitialViewController()!
        present(login, animated: true, completion: nil)
    }
}

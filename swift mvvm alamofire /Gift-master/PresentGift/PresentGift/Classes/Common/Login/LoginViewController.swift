//
//  LoginViewController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var getVerifycodeBtn: UIButton!
    @IBOutlet weak var passIconBtn: UIButton!
    @IBOutlet weak var changeLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - 视图
    fileprivate func setupUI(){
        getVerifycodeBtn.isHidden = true
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.masksToBounds = true
        getVerifycodeBtn.layer.cornerRadius = 5
        getVerifycodeBtn.layer.masksToBounds = true
    }
    
    // MARK: - 事件
    @IBAction func closeAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getVerifycodeBtnAction(_ sender: AnyObject) {
        print("获取验证码")
    }
    
    @IBAction func changePassBtnAction(_ sender: AnyObject) {
        passIconBtn.isSelected = !passIconBtn.isSelected
        getVerifycodeBtn.isHidden = !passIconBtn.isSelected
        if passIconBtn.isSelected {
            passTextField.placeholder = "短信验证码"
            changeLoginBtn.setTitle("使用密码登录", for: UIControlState())
        } else {
            passTextField.placeholder = "输入密码"
            changeLoginBtn.setTitle("使用验证码登录", for: UIControlState())
        }
    }
    
    @IBAction func loginBtnAction(_ sender: AnyObject) {
        print("登录")
    }
    
    @IBAction func weiboBtnAction(_ sender: AnyObject) {
        print("微博登录")
    }
    
    @IBAction func weixinBtnAction(_ sender: AnyObject) {
        print("微信登录")
    }
    
    @IBAction func qqBtnAction(_ sender: AnyObject) {
        print("QQ登录")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

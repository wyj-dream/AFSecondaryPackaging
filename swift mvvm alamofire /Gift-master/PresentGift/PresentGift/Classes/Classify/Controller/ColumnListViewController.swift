//
//  ColumnListViewController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/19.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

/// 顶部封面图高度
private let showImageHeight:CGFloat = 150.0
private let cellID = "ColumnListCell"
class ColumnListViewController: BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController!.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUIFrame()
    }
    
    // MARK: - 视图
    fileprivate func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(tableView)
        navbarView.addSubview(titleLab)
        view.addSubview(navbarView)
        view.addSubview(backBtn)
    }
    
    fileprivate func setupUIFrame() {
        /// 导航栏
        navbarView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 64.0)
        backBtn.frame = CGRect(x: 10.0, y: 15.0, width: 44, height: 44)
        titleLab.sizeToFit()
        titleLab.frame = CGRect(x: (navbarView.bounds.width - titleLab.bounds.width) * 0.5, y: (navbarView.bounds.height - titleLab.bounds.height) * 0.5 + 5.0, width: titleLab.bounds.width, height: titleLab.bounds.height)
        /// tableView
        tableView.frame = view.bounds
        tableViewHeader.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 250.0)
        tableViewSection.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50.0)
    }
    
    // MARK: - 事件
    @objc fileprivate func backBtnAction() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 懒加载
    fileprivate lazy var navbarView:UIView = {
        let navbarView = UIView()
        navbarView.backgroundColor = Color_NavBackground
        navbarView.alpha = 0.0
        return navbarView
    }()
    
    fileprivate lazy var backBtn: UIButton = UIButton(backTarget: self, action: #selector(ColumnListViewController.backBtnAction))
    
    fileprivate lazy var titleLab:UILabel = {
        let titleLab = UILabel()
        titleLab.text = "不打烊的礼物店"
        titleLab.textColor = UIColor.white
        titleLab.font = UIFont.systemFont(ofSize: 17.0)
        titleLab.textAlignment = NSTextAlignment.center
        return titleLab
    }()
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Color_GlobalBackground
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.sectionFooterHeight = 0.0001
        tableView.sectionHeaderHeight = 0.0001
        tableView.register(UINib(nibName: "ColumnListCell", bundle:
            Bundle.main), forCellReuseIdentifier: cellID)
        tableView.tableHeaderView = self.tableViewHeader
        return tableView
    }()
    
    fileprivate lazy var tableViewHeader:UIView = ColumnListHeader.columnListHeader()
    
    fileprivate lazy var tableViewSection:UIView = Bundle.main.loadNibNamed("ColumnListSectionView", owner: nil, options: nil)!.last as! UIView
    
}

// MARK: - 代理
extension ColumnListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tabBarViewController = UIApplication.shared.keyWindow?.rootViewController as! TabbarController
        let navigationController = tabBarViewController.viewControllers![tabBarViewController.selectedIndex] as! NavigationController
        navigationController.pushViewController(CommonStrategyViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewSection
    }
}

extension ColumnListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        navbarView.alpha = offsetY / (showImageHeight - navbarView.bounds.height)
    }
}

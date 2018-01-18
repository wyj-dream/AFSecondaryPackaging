//
//  SearchViewController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

private let SearchGiftCellReuseIdentifier = "SearchGiftCell"
class SearchViewController: BaseViewController {
    
    private static var __once: () = {
            self.perform(#selector(SearchViewController.searchBarBecomeFirstResponder), with: nil, afterDelay: 0.1)
        }()
    
    struct Static {
        static var dispatchOnceToken: Int = 0
    }
    fileprivate var tableView: UITableView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotif()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// 延时弹出键盘(否则键盘弹不出)
        _ = SearchViewController.__once
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBarResignFirstResponder()
        removeNotif()
        popoverSortView.hide()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addNotif()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBarResignFirstResponder()
    }
    
    fileprivate func addNotif() {
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.tagBtnAction(_:)), name: NSNotification.Name(rawValue: Notif_BtnAction_SearchTag), object: nil)
    }
    
    fileprivate func removeNotif() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Notif_BtnAction_SearchTag), object: nil)
    }
    
    // MARK: - 视图
    fileprivate func setupUI() {
        view.backgroundColor = Color_GlobalBackground
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.plain)
        view.addSubview(tableView!)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = Color_GlobalBackground
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.sectionFooterHeight = 0.0001
        tableView?.sectionHeaderHeight = 0.0001
        tableView?.register(UINib(nibName: "SearchGiftCell", bundle: Bundle.main), forCellReuseIdentifier: SearchGiftCellReuseIdentifier)
        tableView?.tableHeaderView = searchHeaderView
        /// 刷选视图
        view.addSubview(popoverSortView)
    }
    
    fileprivate func resetBarBtnSate() {
        if searchBar.isFirstResponder {
            /// 弹出键盘
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
            rightBtn.setImage(UIImage(named: ""), for: UIControlState())
            rightBtn.setTitle("取消", for: UIControlState())
        } else {
            /// 隐藏键盘
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
            rightBtn.setImage(UIImage(named: "icon_sort"), for: UIControlState())
            rightBtn.setTitle("", for: UIControlState())
        }
    }
    
    // MARK: - 事件
    @objc fileprivate func searchBarBecomeFirstResponder() {
        searchBar.becomeFirstResponder()
        resetBarBtnSate()
    }
    
    @objc fileprivate func searchBarResignFirstResponder() {
        searchBar.resignFirstResponder()
        resetBarBtnSate()
    }
    
    @objc fileprivate func leftBtnAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func rightBtnAction() {
        if searchBar.isFirstResponder {
            searchBarResignFirstResponder()
        } else {
            /// 弹出刷选视图
            if popoverSortView.isHidden {
                popoverSortView.show()
            } else {
                popoverSortView.hide()
            }
        }
    }
    
    // MARK: - 通知
    @objc fileprivate func tagBtnAction(_ btn: AnyObject){
        searchBarResignFirstResponder()
        let searchResult = SearchResultViewController()
        navigationController?.pushViewController(searchResult, animated: true)
    }
    
    // MARK: - 懒加载
    fileprivate lazy var searchBar: UISearchBar = UISearchBar(searchGifdelegate: self, backgroundColor:UIColor.white, backgroundImage: UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default)!)
    
    fileprivate lazy var leftBtn: UIButton = UIButton(backTarget: self, action: #selector(SearchViewController.leftBtnAction))
    
    fileprivate lazy var rightBtn: UIButton = UIButton(cancelTarget: self, action: #selector(SearchViewController.rightBtnAction))
    
    fileprivate lazy var searchHeaderView: SearchHeaderView = {
        let view = SearchHeaderView { [unowned self] (height) in
            self.searchHeaderView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
            self.tableView?.tableHeaderView = self.searchHeaderView
        }
        return view
    }()
    
    fileprivate lazy var popoverSortView = PopoverSortView(frame: CGRect(x: ScreenWidth - 155, y: 0, width: 155, height: 190))
}

// MARK: - 代理
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarBecomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarResignFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchGiftCellReuseIdentifier)
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBarResignFirstResponder()
        navigationController?.pushViewController(SearchGifViewController(), animated: true)
    }
}

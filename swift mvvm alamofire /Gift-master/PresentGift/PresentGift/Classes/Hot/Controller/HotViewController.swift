//
//  HotViewController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//
import UIKit
import MJRefresh
class HotViewController: BaseGoodsFeedViewController {
    
    fileprivate var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefresh()
    }
    
    fileprivate func setupUI() {
        title = "热门"
        view.backgroundColor = Color_GlobalBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(searchTarget: self, action: #selector(HotViewController.searchBtnAction))
    }
    
    fileprivate func setupRefresh() {
        let header = Refresh(refreshingTarget: self, refreshingAction: #selector(HotViewController.pullDownLoadData))
        collectionView.mj_header = header
    }
    
    @objc fileprivate func pullDownLoadData() {
        let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.collectionView.mj_header.endRefreshing()
        }
    }
    
    @objc fileprivate func searchBtnAction() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

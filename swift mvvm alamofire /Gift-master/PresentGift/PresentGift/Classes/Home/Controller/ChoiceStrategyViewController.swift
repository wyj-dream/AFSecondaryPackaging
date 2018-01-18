//
//  ChoiceStrategyViewController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class ChoiceStrategyViewController: BaseStrategyFeedController {
    
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
        headerView.addSubview(banner)
        headerView.addSubview(topic)
        tableView.tableHeaderView = headerView
    }
    
    fileprivate func setupUIFrame() {
        banner.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 170.0)
        topic.frame = CGRect(x: 0, y: banner.bounds.height, width: tableView.bounds.width, height: 120.0)
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: banner.bounds.height + topic.bounds.height + 10.0)
        /// 设置完高度需要重新赋值，否则高度不准确
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - 懒加载
    fileprivate lazy var headerView: UIView = UIView()
    
    fileprivate lazy var banner:BannerCollectionView =  BannerCollectionView(frame: CGRect.zero, collectionViewLayout: BannerFlowLayout())
    
    fileprivate lazy var topic:TopicCollectionView =  TopicCollectionView(frame: CGRect.zero, collectionViewLayout: TopicFlowLayout())

}

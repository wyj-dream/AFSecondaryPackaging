//
//  HomeViewController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    var categoryTitles: [NSString]
    {
        return ["精选", "海淘", "创意生活", "送女票", "科技范", "送爸妈", "送基友", "送闺蜜", "送同事", "送宝贝", "设计感", "文艺范", "奇葩搞怪", "萌萌哒"]
    }
    var cacheCategoryViews = [UIView]()
    
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
        view.backgroundColor = Color_GlobalBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(gifTarget: self, action: #selector(HomeViewController.gifBtnAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(searchTarget: self, action: #selector(HomeViewController.searchBtnAction))
        navigationItem.titleView = titleImageView
        view.addSubview(scrollView)
        view.addSubview(popoverCategoryView)
        
        for i in 0..<categoryTitles.count {
            let categoryVC = i == 0 ? ChoiceStrategyViewController() : CommonStrategyViewController()
            addChildViewController(categoryVC)
            scrollView.addSubview(categoryVC.view)
            cacheCategoryViews.append(categoryVC.view)
        }
    }
    
    fileprivate func setupUIFrame() {
        popoverCategoryView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44.0)
        scrollView.frame = CGRect(x: 0, y: popoverCategoryView.frame.maxY, width: view.bounds.width, height: view.bounds.height - popoverCategoryView.bounds.height - 44.0)
        for i in 0..<cacheCategoryViews.count {
            let view = cacheCategoryViews[i]
            view.frame = CGRect(x: scrollView.bounds.width * CGFloat(i), y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        }
        scrollView.contentSize = CGSize(width: CGFloat(cacheCategoryViews.count) * scrollView.bounds.width, height: 0)
    }
    
    // MARK: - 事件
    @objc fileprivate func searchBtnAction() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    @objc fileprivate func gifBtnAction() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notif_Login), object: nil)
        
    }
    
    // MARK: - 懒加载
    fileprivate lazy var titleImageView:UIImageView = {
        let image = UIImage(named: "logo")
        let titleImageView = UIImageView(image: image)
        titleImageView.contentMode = UIViewContentMode.scaleAspectFit
        titleImageView.bounds = CGRect(x: 0, y: 0, width: 20.0 * (image!.size.width / image!.size.height), height: 20.0)
        return titleImageView
    }()
    
    fileprivate lazy var popoverCategoryView: PopoverCategoryView = {
        let view =  PopoverCategoryView.popoverCategoryView()
        view.delegate = self
        view.categoryTitles = self.categoryTitles
        return view
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        return view
    }()
}

// MARK: - 代理
extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.bounds.width;
        popoverCategoryView.scrollCategoryBtnByIndex(NSInteger(index))
    }
}

extension HomeViewController: PopoverCategoryViewDelegate {
    
    func selectedCategoryEndWithIndex(_ index: NSInteger) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * scrollView.bounds.width, y: 0), animated: true)
    }

}

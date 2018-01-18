//
//  ClassifyViewController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class ClassifyViewController: BaseViewController {

    private static var __once: () = {
            ClassifyViewController.titleView.frame = CGRect(x: 0, y: 0, width: 120.0, height: 44.0)
            ClassifyViewController.searchBar.frame = CGRect(x: 0, y: 0, width: ClassifyViewController.view.bounds.width, height: 44.0)
            ClassifyViewController.scrollView.frame = CGRect(x: 0, y: ClassifyViewController.searchBar.frame.maxY, width: ClassifyViewController.view.bounds.width, height: ClassifyViewController.view.bounds.height - ClassifyViewController.searchBar.bounds.height - 44.0)
            
            ClassifyViewController.scrollView.contentSize = CGSize(width: ClassifyViewController.scrollView.bounds.width * 2.0, height: ClassifyViewController.scrollView.bounds.height)
            ClassifyViewController.strategyVC.view.frame = ClassifyViewController.scrollView.bounds
            ClassifyViewController.singleGifVC.view.frame = CGRect(x: ClassifyViewController.scrollView.frame.width, y: 0, width: ClassifyViewController.scrollView.bounds.width, height: ClassifyViewController.scrollView.bounds.height)
        }()

    struct Static {
        static var dispatchOnceToken: Int = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
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
        view.backgroundColor = Color_GlobalBackground
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(chooseGifTarget: self, action: #selector(ClassifyViewController.SearchGifBtnAction))
        navigationItem.rightBarButtonItem?.customView?.alpha = 0
        view.addSubview(searchBar)
        view.addSubview(scrollView)
        scrollView.addSubview(strategyVC.view)
        scrollView.addSubview(singleGifVC.view)
        addChildViewController(strategyVC)
        addChildViewController(singleGifVC)
    }
    
    fileprivate func setupUIFrame() {
        _ = ClassifyViewController.__once
    }
    
    // MARK: - 事件
    @objc fileprivate func SearchGifBtnAction() {
        navigationController?.pushViewController(SearchGifViewController(), animated: true)
    }
    
    // MARK: - 懒加载
    fileprivate lazy var titleView: ClassifyTitleView = {
        let view = ClassifyTitleView()
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var searchBar: UISearchBar =  UISearchBar(searchGifdelegate: self, backgroundColor:UIColor(white: 0, alpha: 0.05), backgroundImage:UIImage.imageWithColor(UIColor.white, size: CGSize.zero))
    
    fileprivate lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        return view
    }()
    
    fileprivate lazy var strategyVC: StrategyViewController = StrategyViewController()
    fileprivate lazy var singleGifVC: SingleGifViewController = SingleGifViewController()
}

// MARK: - 代理
extension ClassifyViewController: ClassifyTitleViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    // MARK: - ClassifyTitleViewDelegate
    func selectedOptionAtIndex(_ index: NSInteger) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * scrollView.bounds.width, y: 0), animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// 更改选礼神器按钮alpha
        navigationItem.rightBarButtonItem?.customView?.alpha = scrollView.contentOffset.x / scrollView.bounds.width
        /// 更改titleView底部线条x
        titleView.scrollLine(scrollView.bounds.width, offsetX: scrollView.contentOffset.x)
    }

    

}

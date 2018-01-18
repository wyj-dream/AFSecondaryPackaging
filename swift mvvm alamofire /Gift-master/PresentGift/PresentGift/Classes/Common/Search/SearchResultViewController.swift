//
//  SearchResultViewController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var redLineView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var redLineViewConstraintLeading: NSLayoutConstraint!
    
    override func loadView() {
        let classString = String(describing: type(of: self))
        Bundle.main.loadNibNamed(classString, owner: self, options: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        popoverSortView.hide()
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
        view.backgroundColor = Color_GlobalBackground
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        addChildViewController(goodsVC)
        addChildViewController(strategyVC)
        scrollView.addSubview(goodsVC.view)
        scrollView.addSubview(strategyVC.view)
        view.addSubview(popoverSortView)
    }
    
    fileprivate func setupUIFrame() {
        goodsVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height:scrollView.bounds.height)
        strategyVC.view.frame = CGRect(x: scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height:scrollView.bounds.height)
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * 2, height: 0)
    }
    
    // MARK: - 事件
    @IBAction func singleBtnAction(_ sender: AnyObject) {
        resetRedlineView(true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func strategyBtnAction(_ sender: AnyObject) {
        resetRedlineView(false)
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.bounds.width, y: 0), animated: true)
    }
    
    func resetRedlineView(_ scrollToleft: Bool) {
        redLineViewConstraintLeading.constant = scrollToleft ? 0 : self.topView.bounds.width * 0.5
    }
    
    @objc fileprivate func leftBtnAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func rightBtnAction() {
        /// 弹出刷选视图
        if popoverSortView.isHidden {
            popoverSortView.show()
        } else {
            popoverSortView.hide()
        }
    }
    
    // MARK: - 懒加载
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "快选一份礼物，送给亲爱的Ta吧"
        searchBar.tintColor = UIColor.white
        searchBar.backgroundImage = UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default)
        return searchBar
    }()
    
    fileprivate lazy var goodsVC:CommonGoodsFeedViewController = CommonGoodsFeedViewController()
    
    fileprivate lazy var strategyVC:CommonStrategyViewController = CommonStrategyViewController()
    
    fileprivate lazy var leftBtn: UIButton = UIButton(backTarget: self, action: #selector(SearchResultViewController.leftBtnAction))
    
    fileprivate lazy var rightBtn: UIButton = UIButton(sortTarget: self, action: #selector(SearchResultViewController.rightBtnAction))
    
    fileprivate lazy var popoverSortView = PopoverSortView(frame: CGRect(x: ScreenWidth - 155, y: 0, width: 155, height: 190))
}

// MARK: - 代理
extension SearchResultViewController:UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetRedlineView(scrollView.contentOffset.x == 0.0 ? true : false)
    }
}

extension SearchResultViewController:UISearchBarDelegate {

}

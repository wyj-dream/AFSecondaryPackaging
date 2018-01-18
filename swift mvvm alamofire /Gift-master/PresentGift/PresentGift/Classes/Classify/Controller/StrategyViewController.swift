//
//  StrategyViewController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

private let cellColumns = 2
private let cellMargin:CGFloat = 10.0
private let columnCellHeight:CGFloat = 250.0
private let cellScale:CGFloat = 200.0 / 100.0 /// cellxib宽高比例

private let categoryCellID = "StrategyCategoryCell"
private let columnCellID =  "StrategyColumnCell"
private let sectionID = "StrategySectionView"
class StrategyViewController: BaseViewController {
    
    fileprivate var headerReferenceSize:CGSize?
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
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
    
    fileprivate func setupUIFrame() {
        collectionView.frame = view.bounds
    }
    
    // MARK: - 事件
    
    // MARK: - 懒加载
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: StrategyCollectionFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "StrategyColumnCell", bundle: nil), forCellWithReuseIdentifier: columnCellID)
        collectionView.register(UINib(nibName: "StrategyCategoryCell", bundle: nil), forCellWithReuseIdentifier: categoryCellID)
        collectionView.register(UINib(nibName: "StrategySectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionID)
        let section = Bundle.main.loadNibNamed("StrategySectionView", owner: self, options: nil)!.last!
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.headerReferenceSize = CGSize(width: ScreenWidth, height: section.size.height)
        self.headerReferenceSize = collectionViewLayout.headerReferenceSize
        return collectionView
    }()
}

// MARK: - 代理
extension StrategyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /// 栏目
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: columnCellID, for: indexPath) as! StrategyColumnCell
            return cell
        }
        /// 分类
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellID, for: indexPath) as! StrategyCategoryCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionID, for: indexPath) as! StrategySectionView
        sectionView.hideMarginTopView(indexPath.section == 0 ? true : false)
        sectionView.viewAllBtn.tag = indexPath.section
        return sectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(CommonStrategyViewController(), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width, height: columnCellHeight)
        }
        let width = (collectionView.bounds.width - (cellMargin * CGFloat(cellColumns + 1))) / CGFloat(cellColumns)
        let height = width / cellScale
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsetsMake(0, cellMargin, 0, cellMargin);
        }
        return UIEdgeInsetsMake(cellMargin, cellMargin, cellMargin, cellMargin);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: headerReferenceSize!.width, height: headerReferenceSize!.height - 12)
        }
        return headerReferenceSize!
    }
}

// MARK: - 其他类
class StrategyCollectionFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        minimumInteritemSpacing = cellMargin * 0.5
        minimumLineSpacing = cellMargin
        scrollDirection = UICollectionViewScrollDirection.vertical
    }
}

/// 分组头部
class StrategySectionView: UICollectionReusableView {
    
    @IBOutlet weak var marginTopView: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    
    func hideMarginTopView(_ hide: Bool) {
        marginTopView.isHidden = hide
    }
    
    @IBAction func viewAllBtnAction(_ sender: AnyObject) {
        let tabBarViewController = UIApplication.shared.keyWindow?.rootViewController as! TabbarController
        let navigationController = tabBarViewController.viewControllers![tabBarViewController.selectedIndex] as! NavigationController
        navigationController.pushViewController(sender.tag == 0 ? AllColumnViewController() : AllClassifyViewController(), animated: true)
    }
}


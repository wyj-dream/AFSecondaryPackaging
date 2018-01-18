//
//  AllColumnViewController.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/19.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

private let cellColumns = 1
private let cellMargin:CGFloat = 10.0
/// cellxib宽高比例
private let cellScale:CGFloat = 340.0 / 90.0
private let cellID = "StrategyColumnCellCell"
class AllColumnViewController: BaseViewController {
    
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
        view.addSubview(collectionView)
    }
    
    fileprivate func setupUIFrame() {
        collectionView.frame = view.bounds
    }
    
    // MARK: - 懒加载
    fileprivate lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: AllColumnViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "StrategyColumnCellCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        return collectionView
    }()
}

// MARK: - 代理
extension AllColumnViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! StrategyColumnCellCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(ColumnListViewController(), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - (CGFloat(cellColumns + 1) * cellMargin)
        let height = width / cellScale
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(cellMargin, cellMargin, cellMargin, cellMargin);
    }
    
}


// MARK: - 其他类
class AllColumnViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        minimumInteritemSpacing = cellMargin * 0.5
        minimumLineSpacing = cellMargin
        scrollDirection = UICollectionViewScrollDirection.vertical
    }
}

//
//  BannerCollectionView.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/19.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "BannerCell"
class BannerCollectionView: UICollectionView {
    
    private static var __once: () = {
            BannerCollectionView.pageControl.center.x = BannerCollectionView.bounds.width * 0.5;
            BannerCollectionView.pageControl.frame.origin.y = BannerCollectionView.bounds.height - (12.0 + BannerCollectionView.pageControl.bounds.height);
        }()
    
    struct Static {
        static var dispatchOnceToken: Int = 0
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUIFrame()
    }
    
    // MARK: - 视图
    fileprivate func setupUI() {
        backgroundColor = Color_GlobalBackground
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        delegate = self;
        dataSource = self;
        register(UINib(nibName: "BannerCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        
        addSubview(pageControl)
    }
    
    fileprivate func setupUIFrame() {
        _ = BannerCollectionView.__once
    }
    
    // MARK: - 事件
    
    // MARK: - 懒加载
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor(white: 0, alpha: 0.1)
        pageControl.numberOfPages = 4
        return pageControl
    }()
}


// MARK: - 代理
extension BannerCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 300.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tabBarViewController = UIApplication.shared.keyWindow?.rootViewController as! TabbarController
        let navigationController = tabBarViewController.viewControllers![tabBarViewController.selectedIndex] as! NavigationController
        navigationController.pushViewController(CommonStrategyViewController(), animated: true)
        print("点击了cell");
    }
    
}

// MARK: - 其他类
extension BannerCollectionView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x;
        let page = (contentOffsetX / scrollView.frame.size.width + 0.5).truncatingRemainder(dividingBy: CGFloat(4))
        pageControl.center.x = contentOffsetX + (ScreenWidth * 0.5)
        pageControl.currentPage = NSInteger(page)
    }
}


class BannerCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.clipsToBounds = true
        photoImageView.contentMode =  UIViewContentMode.scaleAspectFill;
        photoImageView.image = UIImage(named: "strategy_\(Int(arc4random() % 17) + 1).jpg")
    }
}

class BannerFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
    }
}


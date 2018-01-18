//
//  Refresh.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit
import MJRefresh

class Refresh: MJRefreshGifHeader {
    
    override func prepare() {
        super.prepare()
        
        var idleImages = [UIImage]()
        var pullingImages = [UIImage]()
        var refreshingImages = [UIImage]()
        
        for i in 0...10 {
            idleImages.append(UIImage(named: String(format: "loading_dragdown_%02d", i))!.resetImageSize(100))
        }
        pullingImages.append(UIImage(named: "loading_00")!.resetImageSize(100))
        for i in 0...22 {
            refreshingImages.append(UIImage(named: String(format: "loading_%02d", i))!.resetImageSize(100))
        }
        lastUpdatedTimeLabel.isHidden = true
        stateLabel.isHidden = true
        setImages(idleImages, for: MJRefreshState.idle)
        setImages(pullingImages, for: MJRefreshState.pulling)
        setImages(refreshingImages, for: MJRefreshState.refreshing)
    }
}

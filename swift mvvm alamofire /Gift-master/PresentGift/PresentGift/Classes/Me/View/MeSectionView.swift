//
//  MeSectionView.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class MeSectionView: UIView {

    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var bottomLineViewLeading: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - 事件
    @IBAction func singleBtnAction(_ sender: AnyObject) {
        bottomLineViewLeading.constant = 0
    }
    
    @IBAction func strategyBtnAction(_ sender: AnyObject) {
        bottomLineViewLeading.constant = self.bounds.width * 0.5
    }
}

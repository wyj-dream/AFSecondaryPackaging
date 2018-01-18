//
//  ButtonTitleDown.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class ButtonTitleDown: UIButton {

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 2.0
        let height = frame.size.height
        let width = frame.size.width
        
        let imageH = imageView!.frame.size.height
        let imageW = imageView!.frame.size.width
        let titleH = titleLabel!.frame.size.height
        let titleW = titleLabel!.frame.size.width
        let contentMargin = (height - imageH - titleH - margin) / 2;
        
        imageView!.frame.origin.y = contentMargin
        imageView!.frame.origin.x = (width - imageW ) / 2
        titleLabel!.frame.origin.y = (imageView!.frame.maxY + margin)
        titleLabel!.frame.origin.x = (width - titleW ) / 2
    }

}

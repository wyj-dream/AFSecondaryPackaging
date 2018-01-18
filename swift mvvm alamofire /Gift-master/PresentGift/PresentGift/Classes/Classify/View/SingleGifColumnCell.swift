//
//  SingleGifColumnCell.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/19.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class SingleGifColumnCell: UITableViewCell {

    @IBOutlet weak var edgeLineView: UIView!
    @IBOutlet weak var titleBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        edgeLineView.isHidden = true
        titleBtn.setTitleColor(UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0), for: UIControlState())
        titleBtn.setTitleColor(UIColor(red: 251.0/255.0, green: 45.0/255.0, blue: 71.0/255.0, alpha: 1.0), for: UIControlState.selected)
        
        titleBtn.setBackgroundImage(UIImage.imageWithColor(Color_GlobalBackground, size: CGSize.zero), for: UIControlState())
        titleBtn.setBackgroundImage(UIImage.imageWithColor(UIColor.white, size: CGSize.zero), for: UIControlState.selected)
    }
    
    func changeStatus(_ selected: Bool) {
        titleBtn.isSelected = selected
        edgeLineView.isHidden = !selected
    }
}

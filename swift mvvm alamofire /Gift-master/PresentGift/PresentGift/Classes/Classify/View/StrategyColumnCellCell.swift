//
//  StrategyColumnCellCell.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/19.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

class StrategyColumnCellCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var viewAllcoverView: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoImageView.clipsToBounds = true
        photoImageView.contentMode =  UIViewContentMode.scaleAspectFill;
        photoImageView.image = UIImage(named: "strategy_\(Int(arc4random() % 17) + 1).jpg")
        
        viewAllBtn.layer.masksToBounds = true
        viewAllBtn.layer.cornerRadius = 2.0
        viewAllBtn.layer.borderColor = viewAllBtn.titleLabel!.textColor.cgColor
        viewAllBtn.layer.borderWidth = 0.5
        
    }
    
    @IBAction func viewAllBtnAction(_ sender: AnyObject) {
    }

}

//
//  PopoverSortView.swift
//  PresentGift
//
//  Created by 金亮齐 on 16/9/18.
//  Copyright © 2016年 醉看红尘这场梦. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "PopoverSortCell"
class PopoverSortView: UIView {
    
    fileprivate var cacheFrame:CGRect?
    fileprivate var tableView:UITableView?
    fileprivate var markSelectCellRow = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUIFrame()
    }
    
    // MARK: - 视图
    fileprivate func setupUI() {
        isHidden = true
        addSubview(bgImageView)
        
        tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.sectionFooterHeight = 0.0001
        tableView!.sectionHeaderHeight = 0.0001
        tableView!.backgroundView = nil
        tableView!.backgroundColor = UIColor.clear
        tableView!.separatorInset = UIEdgeInsets.zero
        tableView!.layoutMargins = UIEdgeInsets.zero
        tableView!.separatorColor = UIColor(red: 120.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        tableView!.register(UINib(nibName: "PopoverSortCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseIdentifier)
        tableView!.tableFooterView = UIView()
        addSubview(tableView!)
    }
    
    fileprivate func setupUIFrame() {
        bgImageView.frame = bounds
        tableView?.frame = CGRect(x: 0, y: 10, width: bounds.width, height: bounds.height - 14)
    }
    
    func show(){
        // 更改anchorPoint后，position(frame)会改变
        let oldposition = layer.position
        let oldanchorPoint = layer.anchorPoint
        let newanchorPoint = CGPoint(x: 0.5, y: 0.0)
        let newpositionX = oldposition.x + (newanchorPoint.x - oldanchorPoint.x)  * bounds.size.width
        let newpositionY = oldposition.y + (newanchorPoint.y - oldanchorPoint.y)  * bounds.size.height
        isHidden = false
        transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        layer.position = CGPoint(x: newpositionX, y: newpositionY)
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 1.0, y: 0.0000001)
            }, completion: { (_) -> Void in
                self.isHidden = true
        })
    }
    
    // MARK: - 懒加载
    fileprivate lazy var datas:NSArray = ["默认排序", "按热度排序", "价格从低到高", "价格从高到低"]
    
    fileprivate lazy var bgImageView:UIImageView = UIImageView(image: UIImage(named: "popover_background_right"))
}

// MARK: - 代理
extension PopoverSortView:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PopoverSortCell
        cell.layoutMargins = UIEdgeInsets.zero;
        cell.preservesSuperviewLayoutMargins = false
        cell.textLab.text = datas[indexPath.row] as? String
        cell.selectBtn.isHidden = indexPath.row == markSelectCellRow ? false : true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        markSelectCellRow = indexPath.row
        tableView.reloadData()
    }
}


//
//  BannerMatrixSingleCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/9.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import FSPagerView

fileprivate let cellIdentifier = "HomeMatrixBaseImTitleViewCellIdentifier"

class BannerMatrixSingleCell: FSPagerViewCell {
    //数据
    var dataSource:[ArticleAdminModelDatum] = [ArticleAdminModelDatum]() {
        willSet(newValue) {
            tableView.reloadData()
        }
    }
    
    //MARK: - 选择的cell索引
    var _selectedIndex: Int?
    
    var _isReload:Bool = true {
        willSet {
            tableView.reloadData()
        }
    }
    
    
    var selectedBlock: (Int) -> Void = { _ in }
    
    
    //MARK: - 显示的tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(HomeMatrixBaseImTitleViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.transform = CGAffineTransform(rotationAngle: -.pi/2)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textLabel?.removeFromSuperview()
        self.imageView?.removeFromSuperview()
        
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化界面
    private func _setupUI() {
        contentView.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: 110 * iPHONE_AUTORATIO)
    }
    
}

extension BannerMatrixSingleCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HomeMatrixBaseImTitleViewCell
        cell.contentView.transform = CGAffineTransform(rotationAngle: .pi/2)
        cell.imagename = model.avatar.string //头像
        cell.title = model.nickname.string //昵称
        if let index = _selectedIndex, index == indexPath.row { cell.isChoose = true } else { cell.isChoose = false }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBlock(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94 * iPHONE_AUTORATIO
    }
}

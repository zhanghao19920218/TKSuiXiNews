//
//  HomeTitleHeaderFirstCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "HomeMatrixBaseImTitleViewIdentifier"

class HomeTitleHeaderFirstCell: BaseTableViewCell {
    private var _dataSource:  [HomeMatrixListItemModel] = []
    
    var dataSource: [HomeMatrixListItemModel]? {
        willSet(newValue) {
            _dataSource = newValue ?? []
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.register(HomeMatrixBaseImTitleViewCell.self, forCellReuseIdentifier: cellIdentifier)
        //横向的tableView
        view.transform = CGAffineTransform(rotationAngle: -.pi/2)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        return view
    }()
    
    override func setupUI() {
        contentView.backgroundColor = .red
        
        tableView.frame = CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: 124 * iPHONE_AUTORATIO)
        contentView.addSubview(tableView)
    }
    
}

extension HomeTitleHeaderFirstCell: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = _dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HomeMatrixBaseImTitleViewCell
        //横向
        cell.contentView.transform = CGAffineTransform(rotationAngle: .pi/2)
        cell.title = model.nickname?.string
        cell.imagename = model.avatar?.string
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124 * iPHONE_AUTORATIO
    }
}


//
//  BaseVoteView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 *
 */

fileprivate let cellIdentifier = "BaseVoteButtonCellIdentifier"

class BaseVoteView: UIView {
    var currentIndex: Int?
    
    var currentVoteBlock: (_ id: Int, _ index:Int) -> Void = { _, _  in }
    
    
    var dataSources: [VoteOption] = [VoteOption]() {
        willSet(newValue) {
            //刷新数据
            _dataSources = newValue
            _tableView.reloadData()
        }
    }
    
    var totalCount: Int = 0
    
    var title:String = "" {
        willSet(newValue) {
            _titleLabel.text = newValue
        }
    }

    //获取投票的数据的数组
    private lazy var _dataSources: [VoteOption] = {
        return [VoteOption]()
    }()
    
    //显示界面的UI
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        return label
    }()

    //显示下方的tableView
    private lazy var _tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BaseVoteButtonCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = RGBA(245, 245, 245, 1)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        
        backgroundColor = RGBA(245, 245, 245, 1)
        
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化页面
    private func _setupUI() {
        addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20 * iPHONE_AUTORATIO)
        }
        
        addSubview(_tableView)
        _tableView.snp.makeConstraints { (make) in
            make.top.equalTo(45 * iPHONE_AUTORATIO)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-10 * iPHONE_AUTORATIO)
        }
    }
}

extension BaseVoteView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! BaseVoteButtonCell
        cell.title = _dataSources[indexPath.row].name.string
        cell.person = _dataSources[indexPath.row].count.int
        //判断是不是已经点击了
        if let index = currentIndex {
            if index == indexPath.row {
                cell.isCustomerIsSelected = true
            } else {
                cell.isCustomerIsSelected = false
            }
        } else {
            cell.isCustomerShow = false
        }
        if totalCount != 0 { //如果有投票
            cell.progress = Float((_dataSources[indexPath.row].count.int / totalCount))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 * iPHONE_AUTORATIO
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = _dataSources[indexPath.row]
        currentVoteBlock(model.id.int, indexPath.row)
    }
    
}

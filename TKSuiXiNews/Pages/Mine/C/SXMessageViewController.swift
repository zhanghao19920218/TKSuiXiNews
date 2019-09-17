//
//  MessageViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "CDLMessageCellIdentifier";

///我的消息的Controller
class SXMessageViewController: BaseTableViewController {
    //设置右侧的navigationItem
    private lazy var _rightNavigatorItem: UIButton = {
        let button = UIButton(type: .custom);
        button.setTitle("清空")
        button.titleLabel?.font = kFont(16 * iPHONE_AUTORATIO)
        button.frame = CGRect(x: 0, y: 0, width: 50 * iPHONE_AUTORATIO, height: 40 * iPHONE_AUTORATIO)
        button.addTarget(self, action: #selector(clearMessageButtonClicked(_:)), for: .touchUpInside)
        return button;
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI();
        
        self.navigationItem.title = "我的消息";
        
        loadData(); //请求数据
    }
    
    //自定义tableView
    private func setupUI()
    {
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
        tableView.backgroundColor = RGBA(247, 247, 247, 1)
        tableView.register(SXTKMessageCell.self, forCellReuseIdentifier: cellIdentifier);
        tableView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview();
        };
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: _rightNavigatorItem)
    }
    
    
    //请求消息数据
    override func loadData() {
        super.loadData();
        
        requestData()
    }
    
    //刷新获取页面
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.messageBlock(page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXUserMessageListItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.reloadData();
            }, failure:{ [weak self] () in
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.reloadData();
            }
        )
    };
    
    
    override func pullUpLoadMoreData() {
        super.pullUpLoadMoreData()
        
        page = (page == 1 ? 2 : page);
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.messageBlock(page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXUserMessageListItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            if forceModel.data.data.count != 0 {
                //页数+1
                self?.page += 1;
                self?.dataSource += forceModel.data.data;
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.reloadData();
            } else {
                //没有更多数据
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            }, failure:{ [weak self] () in
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                self?.tableView.reloadData();
            }
        )
    }
    
    ///清空数据
    @objc private func clearMessageButtonClicked(_ sender: UIButton) {
        clearMsgData()
    }
}

extension SXMessageViewController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.messageBlock(page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXUserMessageListItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.reloadData();
            }
        )
    }
    
    //MARK: - 清空数据
    private func clearMsgData() {
        HttpClient.shareInstance.request(target: BAAPI.clearAllMessage, success: { [weak self] (json) in
            TProgressHUD.show(text: "清空消息成功")
            self?.requestData()
            }
        )
    }
}

extension SXMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //判断数据源
        let model = dataSource[indexPath.row] as! MyMessageListItemModel
        
        return 90 * iPHONE_AUTORATIO + model.detail.string.ga_heightForComment(fontSize: 14 * iPHONE_AUTORATIO, width: K_SCREEN_WIDTH - 30 * iPHONE_AUTORATIO);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SXTKMessageCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SXTKMessageCell;
        let model = dataSource[indexPath.row] as!  MyMessageListItemModel
        cell.selectionStyle = .none;
        cell.date = model.createtime.string
        cell.message = model.detail.string
        cell.isUnread = model.status.int
        
        return cell;
    }
}

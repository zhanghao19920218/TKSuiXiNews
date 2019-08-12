//
//  HomeSearchListViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/12.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import DefaultsKit

/*
 * 搜索的栏目
 */
fileprivate let newsOnePicIdentifier = "HomeNewsOnePictureCellIdentifier"
fileprivate let newsThreePicIdentifier = "HomeNewsThreePictureCellIdentifier"
fileprivate let newsNoPicIdentifier = "HomeNewsNoPicCellIdentifier"

class HomeSearchListViewController: BaseTableViewController {
    private var _name = ""
    //新闻的设置
    //设置背景
    private lazy var contentBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        view.backgroundColor = .white
        return view
    }();
    
    //搜索按钮
    private lazy var searchIcon: UIImageView = {
        let imageView = UIImageView();
        imageView.image = K_ImageName("news_search_icon");
        return imageView;
    }();
    
    //搜索文本框
    private lazy var textField: UITextField = {
        let textField = UITextField();
        textField.font = kFont(12 * iPHONE_AUTORATIO)
        textField.placeholder = Defaults.shared.get(for: placeholderKey)
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        textField.addTarget(self,
                            action: #selector(textFieldValueDidChanged(_:)),
                            for: .editingChanged)
        textField.delegate = self
        return textField;
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        // Do any additional setup after loading the view.
        createNavigationBarLogo()
    }
    
    private func setupUI() {
        
        view.backgroundColor = RGBA(245, 245, 245, 1)
        
        view.addSubview(contentBackView)
        contentBackView.snp.makeConstraints { (make) in
            make.left.top.equalTo(5 * iPHONE_AUTORATIO)
            make.right.equalTo(-5 * iPHONE_AUTORATIO)
            make.height.equalTo(30 * iPHONE_AUTORATIO)
        }
        
        contentBackView.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { (make) in
            make.left.equalTo(8 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 11 * iPHONE_AUTORATIO, height: 11 * iPHONE_AUTORATIO))
        }
        
        contentBackView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(24 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
            make.right.equalTo(-10 * iPHONE_AUTORATIO)
        }
        
        tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(40 * iPHONE_AUTORATIO)
            make.left.bottom.right.equalToSuperview()
        }
        tableView.register(HomeNewsOnePictureCell.self, forCellReuseIdentifier: newsOnePicIdentifier)
        tableView.register(HomeNewsThreePictureCell.self, forCellReuseIdentifier: newsThreePicIdentifier)
        tableView.register(HomeNewsNoPicCell.self, forCellReuseIdentifier: newsNoPicIdentifier)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
    }
    
    override func loadData() {
        super.loadData();
        
//        requestData(); //请求数据
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.searchArticle(name: _name, page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeNewsListResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.es.stopPullToRefresh();
            self?.tableView.reloadData();
            }, failure:{ [weak self] () in
                self?.tableView.es.stopPullToRefresh();
                self?.tableView.reloadData();
            }
        )
    };
    
    
    override func pullUpLoadMoreData() {
        super.pullUpLoadMoreData()
        
        page = (page == 1 ? 2 : page);
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: _name, page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeNewsListResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            if forceModel.data.data.count != 0 {
                //页数+1
                self?.page += 1;
                self?.dataSource += forceModel.data.data;
                self?.tableView.es.stopLoadingMore();
                self?.tableView.reloadData();
            } else {
                //没有更多数据
                self?.tableView.es.noticeNoMoreData();
            }
            
            }, failure:{ [weak self] () in
                self?.tableView.es.stopLoadingMore();
                self?.tableView.reloadData();
            }
        )
    }
    
    //MARK: - 搜索框变化
    @objc private func textFieldValueDidChanged(_ sender: UITextField) {
        _name = sender.text ?? ""
    }
}

extension HomeSearchListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row] as! HomeNewsListModel
        
        if !model.image.string.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: newsOnePicIdentifier) as! HomeNewsOnePictureCell;
            cell.title = model.name.string
            cell.imageName = model.image.string
            cell.isLike = model.likeStatus.int
            cell.like = model.likeNum.int
            cell.review = model.visitNum.int
            cell.time = model.begintime.string
            return cell;
        } else if model.images.count == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: newsThreePicIdentifier) as! HomeNewsThreePictureCell;
            cell.title = model.name.string
            cell.imageName = model.images[0]
            cell.imageName2 = model.images[1]
            cell.imageName3 = model.images[2]
            cell.isLike = model.likeStatus.int
            cell.like = model.likeNum.int
            cell.review = model.visitNum.int
            cell.time = model.begintime.string
            return cell;
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newsNoPicIdentifier) as! HomeNewsNoPicCell
        cell.title = model.name.string
        cell.isLike = model.likeStatus.int
        cell.like = model.likeNum.int
        cell.review = model.visitNum.int
        cell.time = model.begintime.string
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row] as! HomeNewsListModel
        
        if !model.image.string.isEmpty {
            return 118 * iPHONE_AUTORATIO
        }
        
        if model.images.count == 3 {
            return 187 * iPHONE_AUTORATIO
        } else {
            return 118 * iPHONE_AUTORATIO
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as! HomeNewsListModel;
        let vc = HomeNewsDetailInfoController();
        vc.id = model.id.string
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeSearchListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if _name.isEmpty {
            TProgressHUD.show(text: "请输入搜索内容")
            return false
        }
        //获取数据
        pullDownRefreshData()
        
        view.endEditing(true)
        return true
    }
    //MARK: - 请求首页数据
//    private func requestData(){
//        HttpClient.shareInstance.request(target: BAAPI.contentList(module: _name, page: page), success: { [weak self] (json) in
//            let decoder = JSONDecoder()
//            let model = try? decoder.decode(HomeNewsListResponse.self, from: json)
//            guard let forceModel = model else {
//                return;
//            }
//
//            self?.dataSource = forceModel.data.data;
//            self?.tableView.reloadData();
//            }
//        )
//    }
}

//
//  HomeTVViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 濉溪TV
 */
fileprivate let sectionFirstCellIdentifier = "HomeTVChannelFirstCellIdentifier";
fileprivate let sectionOtherCellIdentifier = "HomeTVOtherSectionCellIdentifier";

class HomeTVViewController: BaseViewController {
    //基类的tableView
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: .zero);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(HomeTVChannelFirstCell.self, forCellReuseIdentifier: sectionFirstCellIdentifier);
        tableView.register(HomeTVOtherSectionCell.self, forCellReuseIdentifier: sectionOtherCellIdentifier)
        tableView.separatorStyle = .none;
        return tableView;
    }();
    
    //获取濉溪新闻的列表
    private lazy var dataSource:Array<HomeTVTitleResponseDatum> = {
        let array = [HomeTVTitleResponseDatum]();
        return array;
    }();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        requestData()
    }
    

    //初始化页面
    private func setupUI() {
        view.addSubview(tableView);
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview();
            make.bottom.equalTo(-TAB_BAR_HEIGHT)
        }
    }

}

extension HomeTVViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionFirstCellIdentifier) as! HomeTVChannelFirstCell;
            return cell;
        }
        
        let model = dataSource[indexPath.row - 1]
        let cell = tableView.dequeueReusableCell(withIdentifier: sectionOtherCellIdentifier) as! HomeTVOtherSectionCell;
        cell.title = model.moduleSecond;
        cell.imageNameFirst = model.data[0].image.string
        cell.imageNameSecond = model.data[1].image.string
        cell.titleFirst = model.data[0].name.string
        cell.titleSecond = model.data[1].name.string
        cell.videoBlock = { [weak self] () in
            let vc = NETLivePlayerController(url: "https://hwapi.yunshicloud.com/m87oxo/251011.m3u8");
            self?.navigationController?.pushViewController(vc, animated: true);
        }
        
        cell.videoSecondBlock = { [weak self] () in
            let vc = NETLivePlayerController(url: "https://hwapi.yunshicloud.com/m87oxo/251011.m3u8");
            self?.navigationController?.pushViewController(vc, animated: true);
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 130 * iPHONE_AUTORATIO;
        }
        
        return 204 * iPHONE_AUTORATIO;
    }
}

extension HomeTVViewController {
    //MARK: - 请求濉溪TV的界面
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.contentSingleList(module: "濉溪TV"), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeTVTitleResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }

            self?.dataSource = forceModel.data;
            self?.tableView.reloadData();
            }
        )
    }
}

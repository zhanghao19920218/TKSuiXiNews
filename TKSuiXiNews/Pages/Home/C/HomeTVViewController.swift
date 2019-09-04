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
    //获取基本的标题model
    private var topModel: HomeTVTitleResponseDatum?
    
    //基类的tableView
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: .zero);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(HomeTVChannelFirstCell.self, forCellReuseIdentifier: sectionFirstCellIdentifier);
        tableView.register(HomeTVOtherSectionCell.self, forCellReuseIdentifier: sectionOtherCellIdentifier)
        tableView.separatorStyle = .none;
        //iOS 11Self-Sizing自动打开后，contentSize和contentOffset都可能发生改变。可以通过以下方式禁用
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
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
            make.edges.equalToSuperview()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionFirstCellIdentifier) as! HomeTVChannelFirstCell
            if let model = self.topModel {
                //没有数据
                if model.data.count == 0 {
                    return cell
                }
                else if model.data.count == 1 {
                    cell.firstImage = model.data[0].image.string
                    cell.firstName = model.data[0].name.string
                    cell.block = { [weak self] (index) in
                        if index == 1 {
                            let category:String = model.data[0].type.string
                            if category == "tv" {
                                let vc = DetailTelevisonInfoController()
                                vc.id = model.data[0].id.int
                                self?.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                let vc = BocastDetailViewController()
                                vc.id = model.data[0].id.int
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                } else if model.data.count == 2 {
                    //如果有两条数据
                    cell.firstImage = model.data[0].image.string
                    cell.secondImage = model.data[1].image.string
                    cell.firstName = model.data[0].name.string
                    cell.movieName = model.data[1].name.string
                    cell.block = { [weak self] (index) in
                        if index <= 2 {
                            let category:String = model.data[index - 1].type.string
                            if category == "tv" {
                                let vc = DetailTelevisonInfoController()
                                vc.id = model.data[index - 1].id.int
                                self?.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                let vc = BocastDetailViewController()
                                vc.id = model.data[index - 1].id.int
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                    return cell
                    
                }
                cell.firstImage = model.data[0].image.string
                cell.secondImage = model.data[1].image.string
                cell.thirdImage = model.data[2].image.string
                cell.firstName = model.data[0].name.string
                cell.movieName = model.data[1].name.string
                cell.thirdName = model.data[2].name.string
                cell.block = { [weak self] (index) in
                    let category:String = model.data[index - 1].type.string
                    if category == "tv" {
                        let vc = DetailTelevisonInfoController()
                        vc.id = model.data[index - 1].id.int
                        self?.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = BocastDetailViewController()
                        vc.id = model.data[index - 1].id.int
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            return cell;
        }
        
        let model = dataSource[indexPath.row - 1]
        let cell = tableView.dequeueReusableCell(withIdentifier: sectionOtherCellIdentifier) as! HomeTVOtherSectionCell
        cell.title = model.moduleSecond;
        cell.dataSource = model.data
        cell.videoBlock = { [weak self] (id) in
            let vc = OnlineTVShowViewController(url: model.data[0].video.string)
            vc.id = id
            self?.navigationController?.pushViewController(vc, animated: true);
        }
        
        cell.videoDetailBlock = { [weak self] (id) in
            let vc = VideoNewsDetailController()
            vc.id = id
            vc.timerTravel = 360
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.checkTotalBlock = { [weak self] in
            let vc = HomeTotalVideoController()
            vc.startIndex = indexPath.row - 1
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 130 * iPHONE_AUTORATIO;
        }
        
        let model = dataSource[indexPath.row - 1]
        if model.data.count == 0 {
            return 60 * iPHONE_AUTORATIO
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
            
            self?.dataSource = forceModel.data
            for (index, item) in (self?.dataSource.enumerated() ?? [].enumerated()) {
                if item.moduleSecond == "置顶频道" { self?.topModel = item; self?.dataSource.remove(at: index) }
            }
            self?.tableView.reloadData();
            }
        )
    }
}

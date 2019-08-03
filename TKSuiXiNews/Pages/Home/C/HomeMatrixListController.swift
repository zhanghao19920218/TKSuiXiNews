//
//  HomeMatrixListController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 矩阵ViewController
 */
fileprivate let bannerIdentifier = "HomeVVideoBannerCellIdentifier";
fileprivate let titlePickIdentifier = "HomeTitleHeaderFirstCellIdentifier"
fileprivate let newsOnePicIdentifier = "HomeNewsOnePictureCellIdentifier"


class HomeMatrixListController: BaseGrouppedTableViewController {
    //banner的model
    private var model: HomeVVideoBannerResponse?
    
    //置顶的model
    var topModel: HomeMatrixListItemResponseDatum?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(HomeVVideoBannerCell.self, forCellReuseIdentifier: bannerIdentifier)
        tableView.register(HomeTitleHeaderFirstCell.self, forCellReuseIdentifier: titlePickIdentifier)
        tableView.register(HomeNewsOnePictureCell.self, forCellReuseIdentifier: newsOnePicIdentifier)
        
        tableView.es.removeRefreshHeader()
        tableView.es.removeRefreshFooter()
    }

    override func loadData() {
        super.loadData();
        
        requestData(); //请求数据
        
        requestBanner()
    }
    
}

extension HomeMatrixListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        let model = dataSource[section-1] as! HomeMatrixListItemResponseDatum
        
        return model.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: bannerIdentifier) as! HomeVVideoBannerCell
                if let model = model { cell.images = model.data }
                cell.block = { [weak self] (model) in
                    let vc = HomeBannerDetailViewController()
                    vc.loadUrl = model.content.string
                    vc.name = model.name.string
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                return cell;
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: titlePickIdentifier) as! HomeTitleHeaderFirstCell
            cell.dataSource = topModel?.data
            return cell;
        }
        
        let model = dataSource[indexPath.section-1] as! HomeMatrixListItemResponseDatum
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newsOnePicIdentifier) as! HomeNewsOnePictureCell;
        if !(model.data[indexPath.row].image?.string.isEmpty ?? true){
            cell.title = model.data[indexPath.row].name?.string
            cell.imageName = model.data[indexPath.row].image?.string
            cell.like = model.data[indexPath.row].likeNum?.int
            cell.review = model.data[indexPath.row].visitNum?.int
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 188 * iPHONE_AUTORATIO
            }
            return 124 * iPHONE_AUTORATIO
        }
        return 112 * iPHONE_AUTORATIO
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let model = dataSource[indexPath.section-1] as! HomeMatrixListItemResponseDatum
            let vc = HomeNewsDetailInfoController();
            vc.id = model.data[indexPath.row].id.string
            parent?.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    //把sectionViewHeader设置为空
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        let model = dataSource[section - 1] as! HomeMatrixListItemResponseDatum
        let view = HomeMatrixSectionHeaderView()
        view.name = model.moduleSecond
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        }
        return 87 * iPHONE_AUTORATIO
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}

extension HomeMatrixListController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.contentSingleList(module: "矩阵"), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeMatrixListItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data
            for (index, item) in (self?.dataSource as! [HomeMatrixListItemResponseDatum]).enumerated() {
                if item.moduleSecond == "矩阵列表" { self?.topModel = item; self?.dataSource.remove(at: index) }
            }
            self?.tableView.reloadData()
            }
        )
    }
    
    //MARK: - 请求Banner
    private func requestBanner() {
        HttpClient.shareInstance.request(target: BAAPI.topBanner(module: "矩阵"), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeVVideoBannerResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.model = forceModel
            self?.tableView.reloadData();
            }
        )
    }
}

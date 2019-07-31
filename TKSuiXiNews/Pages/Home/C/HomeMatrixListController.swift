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
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    
}

extension HomeMatrixListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: bannerIdentifier) as! HomeVVideoBannerCell
                return cell;
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: titlePickIdentifier) as! HomeTitleHeaderFirstCell
            return cell;
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newsOnePicIdentifier) as! HomeNewsOnePictureCell
        cell.title = "最高8000元！7月15日起安徽省 贫困生可申请助学贷款"
        cell.imageName = "http://medium.tklvyou.cn/uploads/20190730/be074ce2942e4754f091edec4c58c878.png"
        cell.isLike = 1
        cell.like = 1265
        cell.review = 1265
        cell.time = "2小时前"
        return cell
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
    
    //把sectionViewHeader设置为空
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        let view = HomeMatrixSectionHeaderView()
        view.name = "矩阵号名称"
        view.time = "2019年9月23日"
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

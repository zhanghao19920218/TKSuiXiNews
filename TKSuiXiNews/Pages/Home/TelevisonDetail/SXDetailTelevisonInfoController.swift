//
//  DetailTelevisonInfoController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let videoNewsDetailIdentifier = "VideoNewsDetailInfoCellIdentifier"
fileprivate let boardCastVideoIdentifier = "BoardCastVideoNewsCellIdentifier"
fileprivate let televisionListIdentifier = "HYTelevisionProgramCellIdentifier"

class SXDetailTelevisonInfoController: SXBaseViewController {
    var currentIndex = 1
    
    var model: SXTelevisionDetailPageData?
    
    private lazy var _dataSource: Array<SuixiTvListModel> = {
        return [SuixiTvListModel]()
    }()
    
    var id:Int = 0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SXVideoNewsDetailInfoCell.self, forCellReuseIdentifier: videoNewsDetailIdentifier)
        tableView.register(SXBoardCastVideoNewsCell.self, forCellReuseIdentifier: boardCastVideoIdentifier)
        tableView.register(SXTelevisionProgramCell.self, forCellReuseIdentifier: televisionListIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        timerTravel = 360
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "电视"
        
        _setupUI()
        
        loadDetailData()
    }
    
    //请求定时器进行加分
    override func _counterAction() {
        super._counterAction()
        
        readGotScore()
    }
    

    private func _setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

extension SXDetailTelevisonInfoController
{
    //MARK: - 获取新闻详情
    private func loadDetailData() {
        HttpClient.shareInstance.request(target: BAAPI.articleDetail(id: "\(id)"), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXTelevisionDetailPageResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.model = forceModel.data
            
            self?._dataSource = forceModel.data.telList[1].list
            
            self?.tableView.reloadData();
            }
        )
    }
    
    //MARK: - 阅读获得积分
    private func readGotScore() {
        HttpClient.shareInstance.request(target: BAAPI.readGetScore(id: Int(id) ), success: { (json) in
            let decoder = JSONDecoder()
            let baseModel = try? decoder.decode(BaseModel.self, from: json)
            if let model = baseModel, !model.msg.isEmpty {
                TProgressHUD.show(text: model.msg)
            }
        })
    }
}

extension SXDetailTelevisonInfoController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = model {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return _dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: videoNewsDetailIdentifier) as! SXVideoNewsDetailInfoCell
                if model?.images.count ?? 0 > 0 {
                    cell.imageUrl = model?.images[0]
                }
                
                return cell
            }
            
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: boardCastVideoIdentifier) as! SXBoardCastVideoNewsCell
                cell.isTv = false
                cell.title = model?.name.string
                cell.review = model?.visitNum.int
                return cell
            }
        }
        
        let model = _dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: televisionListIdentifier) as! SXTelevisionProgramCell
        cell.title = model.date.string + " " + model.content.string
        cell.isHiddened = (model.now?.int ?? 0 != 1 )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 188 * iPHONE_AUTORATIO
            }
            
            if indexPath.row == 1 {
                return 65 * iPHONE_AUTORATIO
            }
        }
        
        return 40 * iPHONE_AUTORATIO
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            let vc = OnlineTVShowViewController.init(url: model?.video.string ?? "")
            vc.id = model?.id.int ?? 0
            navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 68 * iPHONE_AUTORATIO
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = SXTelevisionSectionView()
        if let model = model {
            view.before = model.telList[0].date
            view.after = model.telList[2].date
            view.today = model.telList[1].date
            view.selectedBlock = { [weak self] (index) in
                self?._dataSource = model.telList[index - 1].list
                self?.tableView.reloadSections(IndexSet(integersIn: 1...1), with: .none)
            }
        }
        return view
    }
    
}

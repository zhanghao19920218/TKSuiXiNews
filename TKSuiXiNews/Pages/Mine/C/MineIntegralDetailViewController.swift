//
//  MineIntegralDetailViewController.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let str = "MineIntegralDetailTableViewCell"

class MineIntegralDetailViewController: BaseViewController {
    
    private var topImageView : UIImageView?
    
    private var page : Int?
    
    //当前的数据
    private lazy var _dataList:Array<Any> = {
        let array = [Any]();
        return array;
    }();
    
    //set/get方法
    var dataList: Array<Any> {
        set(value){
            _dataList = value;
        }
        get {
            return _dataList;
        }
    }
    
    
    private lazy var integralLab : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 36)
        lab.textColor = UIColor.white
        return lab
    }()
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MineIntegralDetailTableViewCell.self, forCellReuseIdentifier: str)
        return tableView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        createNavView()
        createView()
        requestIntegralData()
        requestData()
    }
    
    //积分数据
    func requestIntegralData(){
        HttpClient.shareInstance.request(target: BAAPI.memeberInfo, success: {(json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MemeberInfoResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            self.integralLab.text = forceModel.data.score.string;
            }
        )
    }
    
    //列表数据
    func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.integralDetail(page: page ?? 1), success: {(json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(IntegralDetailResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
//            print("---" + String(forceModel.data.currentPage) + "----")
            if self.page == 1 || self.page == 0{
                self.tableView.es.stopPullToRefresh()
                self.dataList = forceModel.data.data
            }else{
                self.tableView.es.stopLoadingMore()
                self.dataList += forceModel.data.data
            }
//            print("---" + String(forceModel.data.data.count) + "----" + String(self.dataList.count))
            self.page = forceModel.data.currentPage + 1
            self.tableView.reloadData()
            }
        )
    }
    
    func createNavView() {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage.init(named: "integral_detail_top.png")
        self.view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        topImageView = bgImageView
        
        let backBtn = UIButton()
        backBtn.setImage("token_back_main")
        self.view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(STATUS_BAR_HEIGHT + 10)
            make.size.equalTo(35)
        }
        backBtn.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
        let titleLab = UILabel()
        titleLab.font = UIFont.init(name: "PingFang-SC-Medium", size: 19)
        titleLab.textColor = .white
        titleLab.text = "积分明细"
        self.view.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(STATUS_BAR_HEIGHT + 10)
        }
        
        bgImageView.addSubview(integralLab)
        integralLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        integralLab.text = "---"
        
        let btn = UIButton()
        btn.setImage("integral_detail_coin")
        btn .setTitle("  可用积分", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = kFont(14)
        bgImageView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(integralLab.snp_bottom).offset(10)
        }
    }
    //返回
    @objc func clickBackAction(){
        navigationController?.popViewController(animated: true)
    }
    
    func createView(){
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(topImageView?.snp.bottom ?? self.view).offset(0)
        }
        //增加下拉刷新
        tableView.es.addPullToRefresh {
            [unowned self] in
            self.page = 1
            self.dataList.removeAll()
            self.requestData();
        }
        
        //增加上拉加载更多
        tableView.es.addInfiniteScrolling {
            [unowned self] in
            self.requestData();
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MineIntegralDetailViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: str) as! MineIntegralDetailTableViewCell
        cell.selectionStyle = .none
        let model = self.dataList[indexPath.row] as! IntegralDetailModel
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


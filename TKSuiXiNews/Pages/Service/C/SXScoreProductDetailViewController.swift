//
//  ScoreProductDetailViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let productDetailImgIdentifier = "ProductDetailImageCellIdentifier"
fileprivate let productTitleIdentifier = "ProductDetailTitleCellIdentifier"
fileprivate let sxcontentWebIdentifier = "HomeArticleContentWebCellIdentifier"

///商品详情的Controller
class SXScoreProductDetailViewController: SXBaseViewController {
    ///产品的id
    var goodId:Int?
    
    ///获取信息的model
    private var _model: SXDetailProductItemModel?
    
    private var _webContentHeight: CGFloat = 0 //下方富文本的高度
    
    private lazy var _exchangeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = RGBA(153, 153, 153, 1)
        button.setTitle("兑 换")
        button.isEnabled = false
        button.addTarget(self,
                         action: #selector(scoreExchangeButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var _tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SXProductDetailImageCell.self, forCellReuseIdentifier: productDetailImgIdentifier)
        tableView.register(SXProductDetailTitleCell.self, forCellReuseIdentifier: productTitleIdentifier)
        tableView.register(SXHomeArticleContentWebCell.self, forCellReuseIdentifier: sxcontentWebIdentifier) //加载web显示富文本
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        //iOS 11Self-Sizing自动打开后，contentSize和contentOffset都可能发生改变。可以通过以下方式禁用
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "商品详情"

        _setupUI()
        
        getGoodDetailInfo()
    }

    private func _setupUI(){
        view.addSubview(_exchangeButton)
        _exchangeButton.snp.makeConstraints { (make) in
            make.right.bottom.left.equalToSuperview()
            make.height.equalTo(49 * iPHONE_AUTORATIO)
        }

        view.addSubview(_tableView)
        _tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-49 * iPHONE_AUTORATIO)
        }
    }
    
    @objc func scoreExchangeButton(_ sender: UIButton) {
        // 兑换当前的积分
        if let model = self._model {
            let view = MallPopMenu(frame: CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT))
            view.score2 = model.score.int
            view.productName = model.name.string
            view.isLottery = false
            view.block = { [weak self] () in
                //兑换成功返回
                self?.exchangeProduct()
                
            }
            navigationController?.view.addSubview(view)
        }
    }
}

extension SXScoreProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _model != nil {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: productDetailImgIdentifier) as! SXProductDetailImageCell
            cell.imageName = _model?.image.string
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: productTitleIdentifier) as! SXProductDetailTitleCell
            cell.name = _model?.name.string
            cell.score = _model?.score.int
            cell.storage = _model?.stock.int
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: sxcontentWebIdentifier) as! SXHomeArticleContentWebCell
        cell.loadUrl = _model?.content.string
        cell.block = { [weak self](height) in
            self?._webContentHeight = height
            self?._tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250 * iPHONE_AUTORATIO
        }
        
        if indexPath.row == 1 {
            return 120 * iPHONE_AUTORATIO
        }
        
        return _webContentHeight
    }
    
    //MARK: - 滚动刷新页面数据，防止产生空白页面
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //滚动过程中强制渲染一下webView
        if _tableView == scrollView {
            for cell in _tableView.visibleCells {
                if cell is SXHomeArticleContentWebCell {
                    (cell as! SXHomeArticleContentWebCell)._webView.setNeedsLayout()
                }
            }
        }
    }
    
}

extension SXScoreProductDetailViewController {
    //MARK: - 请求详情
    private func getGoodDetailInfo(){
        HttpClient.shareInstance.request(target: BAAPI.productDetail(id: goodId ?? 0), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXDetailProductItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?._model = forceModel.data
            self?._tableView.reloadData()
            
            //根据库存定义按钮置灰
            if forceModel.data.stock.int == 0 {
                self?._exchangeButton.backgroundColor = RGBA(153, 153, 153, 1)
                self?._exchangeButton.isEnabled = false
            } else {
                self?._exchangeButton.backgroundColor = RGBA(255, 74, 92, 1)
                self?._exchangeButton.isEnabled = true
            }
            
            }
        )
    }
    
    //MARK: - 兑换操作
    private func exchangeProduct() {
        HttpClient.shareInstance.request(target: BAAPI.exchangeAward(id: _model?.id.int ?? 0), success: { [weak self] (json) in
            self?.navigationController?.popViewController(animated: true)
            TProgressHUD.show(text: "兑换成功")
            }
        )
    }
}

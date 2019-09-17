//
//  BocastDetailViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 广播详情页面
 */
fileprivate let videoNewsDetailIdentifier = "VideoNewsDetailInfoCellIdentifier"
fileprivate let boardCastVideoIdentifier = "BoardCastVideoNewsCellIdentifier"
fileprivate let commentLikeIdentifier = "DetailCommentLikeNumCellIdentifier"
fileprivate let userCommentsIdentifier = "DetailUserCommentCellIdentifier"

class SXBocastDetailViewController: SXBaseViewController {
    private var model: SXBocastListItemModel?
    
    private lazy var bottomView: SXBocastShareBottom = {
        let view = SXBocastShareBottom()
        view.bottomBlock = { [weak self](type) in
            if type == .comment {
                //评论的弹窗
                let view = CommentPopMenu(frame: CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT))
                self?.view.addSubview(view)
                view.sendBlock = { (comment) in
                    self?.sendComment(comment)
                }
            } 
        }
        view.isTappedBlock = { [weak self] isChoosed in
            if isChoosed {
                self?.disLikeArticle()
            } else {
                self?.likeArticle()
            }
        }
        return view
    }()
    
    var id:Int = 0
    
    private lazy var _tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SXBoardCastAudioPlayerCell.self, forCellReuseIdentifier: videoNewsDetailIdentifier)
        tableView.register(SXBoardCastVideoNewsCell.self, forCellReuseIdentifier: boardCastVideoIdentifier)
        tableView.register(SXDetailCommentLikeNumCell.self, forCellReuseIdentifier: commentLikeIdentifier)
        tableView.register(SXDetailUserCommentCell.self, forCellReuseIdentifier: userCommentsIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    

    override func viewDidLoad() {
        timerTravel = 360
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "广播"
        
        setupUI()
        
        loadDetailData()
    }
    
    //请求定时器进行加分
    override func _counterAction() {
        super._counterAction()
        
        readGetScore()
    }
    
    private func setupUI()
    {
        view.addSubview(_tableView)
        _tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-49 * iPHONE_AUTORATIO)
        }
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(49 * iPHONE_AUTORATIO)
        }
    }

}

extension SXBocastDetailViewController
{
    //MARK: - 获取新闻详情
    private func loadDetailData() {
        HttpClient.shareInstance.request(target: BAAPI.articleDetail(id: "\(id)"), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXBocastListItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.model = forceModel.data
            
            self?._tableView.reloadData();
            
            self?.bottomView.isLike = forceModel.data.likeStatus.int
            }
        )
    }
    
    //MARK: - 上传新闻评论信息
    private func sendComment(_ msg: String) {
        let message = msg.removeHeadAndTailSpacePro
        
        if message.isEmpty {
            TProgressHUD.show(text: "请输入评论")
            return
        }
        
        HttpClient.shareInstance.request(target: BAAPI.commentAdd(id: id, detail: message), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(BaseModel.self, from: json)
            TProgressHUD.show(text: model?.msg ?? "评论失败")
            self?.loadDetailData()
            }
        )
    }
    
    //MARK: - 点赞信息
    private func likeArticle() {
        HttpClient.shareInstance.request(target: BAAPI.addLikeNum(id: id), success: { [weak self] (json) in
            TProgressHUD.show(text: "点赞成功")
            self?.loadDetailData()
            }
        )
    }
    
    //MARK: - 取消点赞
    private func disLikeArticle() {
        HttpClient.shareInstance.request(target: BAAPI.dislikeComment(id: id), success: { [weak self] (json) in
            TProgressHUD.show(text: "取消点赞成功")
            self?.loadDetailData()
            }
        )
    }
    
    //MARK: - 阅读获得积分
    private func readGetScore() {
        HttpClient.shareInstance.request(target: BAAPI.readGetScore(id: Int(id) ?? 0), success: { (json) in
            let decoder = JSONDecoder()
            let baseModel = try? decoder.decode(BaseModel.self, from: json)
            if let model = baseModel, !model.msg.isEmpty {
                TProgressHUD.show(text: model.msg)
            }
        })
    }
}

extension SXBocastDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = model {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + (model?.comment?.count ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: videoNewsDetailIdentifier) as! SXBoardCastAudioPlayerCell
            cell.audioPlayerUrl = model?.video.string.removeHeadAndTailSpacePro ?? ""
            cell.audioImageUrl = model?.image.string

            return cell
        }

        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: boardCastVideoIdentifier) as! SXBoardCastVideoNewsCell
            cell.isTv = true
            cell.title = model?.name.string
            cell.review = model?.visitNum.int
            return cell
        }

        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: commentLikeIdentifier) as! SXDetailCommentLikeNumCell
            cell.comment = model?.commentNum.int
            cell.like = model?.likeNum.int
            return cell
        }

        //用户评论
        let cell = tableView.dequeueReusableCell(withIdentifier: userCommentsIdentifier) as! SXDetailUserCommentCell
        cell.avatar = model?.comment?[indexPath.row - 3].avatar.string
        cell.nickname = model?.comment?[indexPath.row - 3].nickname.string
        cell.comment = model?.comment?[indexPath.row - 3].detail.string
        cell.time = model?.comment?[indexPath.row - 3].createtime.string
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 188 * iPHONE_AUTORATIO
        }

        if indexPath.row == 1 {
            return 65 * iPHONE_AUTORATIO
        }

        if indexPath.row == 2 {
            return 59 * iPHONE_AUTORATIO
        }

        return 59 * iPHONE_AUTORATIO + (model?.comment?[indexPath.row - 3].detail.string.ga_heightForComment(fontSize: 14 * iPHONE_AUTORATIO, width: K_SCREEN_WIDTH - 83 * iPHONE_AUTORATIO) ?? 0)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            //进入评论页面
            let vc = SXCommentCommonController()
            vc.articleCommentId = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
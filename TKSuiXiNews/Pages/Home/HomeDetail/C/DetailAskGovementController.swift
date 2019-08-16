//
//  DetailAskGovementController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/12.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 问政详情
 */

fileprivate let articleTitleIdentifier = "HomeArticleContentWebCellIdentifier"
fileprivate let nameCellIdentifier = "CommonDetailTitleNameCellIdentifier"
fileprivate let shareCellIdentifier = "BaseShareBottomViewIdentifier"
fileprivate let likeCellIdentifier = "DetailCommentLikeNumCellIdentifier"
fileprivate let commentCellIdentifier = "DetailUserCommentCellIdentifier"
fileprivate let imagesIdentifier = "ShowImagesCollectionCellCellIdentifier"
fileprivate let voteCellIdentifier = "DetailInfoVoteSectionCellIdentifier" //投票的Cell

class DetailAskGovementController: BaseViewController {
    
    
    //获取当前投票的index
    private var _currentVoteIndex: Int?
    
    var model: DetailArticleModel?
    
    var voteModel: VoteContentDetailModelResponse? = nil
    //获取详情的id
    var id: String = "0"
    
    //设置tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView();
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none;
        tableView.register(CommonDetailTitleNameCell.self, forCellReuseIdentifier: articleTitleIdentifier)
        tableView.register(BaseShareBottomView.self, forCellReuseIdentifier: shareCellIdentifier);
        tableView.register(DetailCommentLikeNumCell.self, forCellReuseIdentifier: likeCellIdentifier)
        tableView.register(DetailUserCommentCell.self, forCellReuseIdentifier: commentCellIdentifier)
        tableView.register(DetailInfoVoteSectionCell.self, forCellReuseIdentifier: voteCellIdentifier) //投票的Cell
        tableView.register(ProductDetailDescribeCell.self, forCellReuseIdentifier: nameCellIdentifier)
        tableView.register(ShowImagesCollectionCell.self, forCellReuseIdentifier: imagesIdentifier)
        //iOS 11Self-Sizing自动打开后，contentSize和contentOffset都可能发生改变。可以通过以下方式禁用
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView;
    }();
    
    //底部的评论
    private lazy var bottomView: ResendButtonBottom = {
        let view = ResendButtonBottom();
        view.bottomBlock = { [weak self](type) in
            if type == .comment {
                //评论的弹窗
                let view = CommentPopMenu(frame: CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT))
                self?.view.addSubview(view)
                view.sendBlock = { (comment) in
                    self?.sendComment(comment)
                }
            } else if type == .resend {
                ShareBottomPopMenu.show(success: { [weak self](type) in
                    let url = K_URL_Share + (self?.model?.id.string ?? "0")
                    if type == .qq { //QQ分享
                        QQShareInstance.share.shareQQ(title: self?.model?.name.string ?? "", url: url)
                    }
                    if type == .weibo { //微博分享
                        ThirdPartyLogin.share.shareWebToSina(title: self?.model?.name.string ?? "", url: url)
                    }
                    if type == .circle { //朋友圈
                        ThirdPartyLogin.share.shareWechatTimeline(title: self?.model?.name.string ?? "", url: url)
                    }
                    if type == .wechat {
                        ThirdPartyLogin.share.shareWechatFriend(title: self?.model?.name.string ?? "", url: url)
                    }
                })
            }
        }
        view.isTappedBlock = { [weak self] isChoosed in
            if isChoosed {
                self?.disLikeArticle()
            } else {
                self?.likeArticle()
            }
        }
        return view;
    }();
    
    override func viewDidLoad() {
        //请求定时器进行加分
        timerTravel = 15
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "问政"
        
        setupUI()
        
        loadDetailData(); //请求数据
        
    }
    
    //请求定时器进行加分
    override func counterAction() {
        super.counterAction()
        
        readGetScore()
    }
    
    //初始化页面
    private func setupUI() {
        
        view.addSubview(tableView);
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview();
            make.bottom.equalTo(-49 * iPHONE_AUTORATIO);
        }
        
        //底部评论
        view.addSubview(bottomView);
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview();
            make.height.equalTo(49 * iPHONE_AUTORATIO);
        }
    }
    
}

extension DetailAskGovementController {
    //MARK: - 获取新闻详情
    private func loadDetailData() {
        HttpClient.shareInstance.request(target: BAAPI.articleDetail(id: id), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(DetailArticleResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.model = forceModel.data
            
            self?.tableView.reloadData()
            
            self?.bottomView.isLike = forceModel.data.likeStatus.int
            
            //如果有投票请求投票接口
            if forceModel.data.voteID.int != 0 {
                self?.getVoteContent(id: forceModel.data.voteID.int)
            }
            
            //刷新详情页面的几个参数
            self?.commentNum = forceModel.data.commentNum.int
            self?.reviewNum = forceModel.data.visitNum.int
            self?.likeNum = forceModel.data.likeNum.int
            self?.isLike = (forceModel.data.likeStatus.int == 1)
            self?.parametersBlock(self?.commentNum ?? 0, self?.reviewNum ?? 0, self?.likeNum ?? 0, self?.isLike ?? false)
            
            }
        )
    }
    
    //MARK: - 上传新闻评论信息
    private func sendComment(_ msg: String) {
        HttpClient.shareInstance.request(target: BAAPI.commentAdd(id: Int(id) ?? 0, detail: msg), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(BaseModel.self, from: json)
            TProgressHUD.show(text: model?.msg ?? "评论失败")
            self?.loadDetailData()
            }
        )
    }
    
    //MARK: - 点赞信息
    private func likeArticle() {
        HttpClient.shareInstance.request(target: BAAPI.addLikeNum(id: Int(id) ?? 0), success: { [weak self] (json) in
            TProgressHUD.show(text: "点赞成功")
            self?.loadDetailData()
            }
        )
    }
    
    //MARK: - 取消点赞
    private func disLikeArticle() {
        HttpClient.shareInstance.request(target: BAAPI.dislikeComment(id: Int(id) ?? 0), success: { [weak self] (json) in
            TProgressHUD.show(text: "取消点赞成功")
            self?.loadDetailData()
            }
        )
    }
    
    //MARK: - 点击投票
    private func voteSuccess(optionId: Int) {
        HttpClient.shareInstance.request(target: BAAPI.addVoteInArticle(id: self.model?.voteID.int ?? 0, optionId: optionId), success: { [weak self] (json) in
            TProgressHUD.show(text: "投票成功")
            //刷新页面
            self?.loadDetailData()
            }
        )
    }
    
    //MARK: - 获取投票内容
    private func getVoteContent(id: Int) {
        HttpClient.shareInstance.request(target: BAAPI.voteDetailContent(id: id), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(VoteContentDetailModelResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.voteModel = forceModel
            self?.tableView.reloadData()
            
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

extension DetailAskGovementController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //没有为nil
        if model == nil {
            return 0;
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //判断是不是有投票内容
        if let detailModel = model, detailModel.voteID.int != 0 {
            //有投票内容
            return 6 + (model?.comment?.count ?? 0)
        }
        return 5 + (model?.comment?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //视频信息界面
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: articleTitleIdentifier) as! CommonDetailTitleNameCell
            cell.title = model?.name.string
            cell.writer = "问政对象: \(model?.moduleSecond.string ?? "")"
            cell.time = model?.begintime?.string
            cell.review = model?.visitNum.int
            return cell
        }
        
        //用户发表内容
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: nameCellIdentifier) as! ProductDetailDescribeCell
            cell.content = model?.content.string
            return cell
        }
        
        //用户的images
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: imagesIdentifier) as! ShowImagesCollectionCell
            cell.images = model?.images
            return cell
        }
        
        //判断是不是有投票内容
        if let detailModel = model, detailModel.voteID.int != 0 {
            //是不是用户投票的界面
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: voteCellIdentifier) as! DetailInfoVoteSectionCell
                if let _ = voteModel {
                    if let status = detailModel.voteStatus?.int, status != 1 {
                        cell.title = voteModel!.data.name.string
                        cell.dataSource = voteModel!.data.option
                        //发起投票的Block
                        cell.currentVoteBlock = { [weak self] (id, index) in
                            self?.voteSuccess(optionId: id)
                        }
                    } else {
                        //获取当前check得索引
                        cell.title = voteModel!.data.name.string
                        cell.dataSource = voteModel!.data.option
                        //更新投票Block无法使用
                        cell.currentVoteBlock = { _,_ in
                            
                        }
                        for (index, item) in voteModel!.data.option.enumerated() {
                            if item.check?.int != 0 {
                                cell.currentIndex = index
                            }
                        }
                    }
                }
                return cell
            }
            
            //用户分享的Cell
            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: shareCellIdentifier) as! BaseShareBottomView
                cell.shareBlock = { type in
                    let url = K_URL_Share + (self.model?.id.string ?? "0")
                    if type == .qqShare { //QQ分享
                        QQShareInstance.share.shareQQ(title: self.model?.name.string ?? "", url: url)
                    }
                    if type == .weiboShare { //微博分享
                        ThirdPartyLogin.share.shareWebToSina(title: self.model?.name.string ?? "", url: url)
                    }
                    if type == .circleShare { //朋友圈
                        ThirdPartyLogin.share.shareWechatTimeline(title: self.model?.name.string ?? "", url: url)
                    }
                    if type == .wechatShare {
                        ThirdPartyLogin.share.shareWechatFriend(title: self.model?.name.string ?? "", url: url)
                    }
                }
                return cell
            }
            
            
            //用户称赞数量和评论数量
            if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: likeCellIdentifier) as! DetailCommentLikeNumCell
                cell.comment = model?.commentNum.int
                cell.like = model?.likeNum.int
                return cell
            }
            
            //用户评论
            let cell = tableView.dequeueReusableCell(withIdentifier: commentCellIdentifier) as! DetailUserCommentCell
            cell.avatar = model?.comment?[indexPath.row - 6].avatar.string
            cell.nickname = model?.comment?[indexPath.row - 6].nickname.string
            cell.comment = model?.comment?[indexPath.row - 6].detail.string
            cell.time = model?.comment?[indexPath.row - 6].createtime.string
            return cell
        }
        
        //如果没有投票内容
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: shareCellIdentifier) as! BaseShareBottomView
            cell.shareBlock = { type in
                let url = K_URL_Share + (self.model?.id.string ?? "0")
                if type == .qqShare { //QQ分享
                    QQShareInstance.share.shareQQ(title: self.model?.name.string ?? "", url: url)
                }
                if type == .weiboShare { //微博分享
                    ThirdPartyLogin.share.shareWebToSina(title: self.model?.name.string ?? "", url: url)
                }
                if type == .circleShare { //朋友圈
                    ThirdPartyLogin.share.shareWechatTimeline(title: self.model?.name.string ?? "", url: url)
                }
                if type == .wechatShare {
                    ThirdPartyLogin.share.shareWechatFriend(title: self.model?.name.string ?? "", url: url)
                }
            }
            return cell
        }
        
        
        //用户称赞数量和评论数量
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: likeCellIdentifier) as! DetailCommentLikeNumCell
            cell.comment = model?.commentNum.int
            cell.like = model?.likeNum.int
            return cell
        }
        
        //用户评论
        let cell = tableView.dequeueReusableCell(withIdentifier: commentCellIdentifier) as! DetailUserCommentCell
        cell.avatar = model?.comment?[indexPath.row - 5].avatar.string
        cell.nickname = model?.comment?[indexPath.row - 5].nickname.string
        cell.comment = model?.comment?[indexPath.row - 5].detail.string
        cell.time = model?.comment?[indexPath.row - 5].createtime.string
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120 * iPHONE_AUTORATIO
        }
        
        if indexPath.row == 1 {
            return 10 * iPHONE_AUTORATIO + (model?.name.string.ga_heightForComment(fontSize: 14 * iPHONE_AUTORATIO, width: K_SCREEN_WIDTH - 26 * iPHONE_AUTORATIO) ?? 0)
        }
        
        if indexPath.row == 2 {
            //判断是不是图片
            let count = model?.images.count ?? 0;
            if count <= 3 {
                return 140 * iPHONE_AUTORATIO
            } else if count <= 6 {
                return 280 * iPHONE_AUTORATIO;
            } else {
                return 420 * iPHONE_AUTORATIO
            }
        }
        
        //判断是不是有投票内容
        if let detailModel = model, detailModel.voteID.int != 0 {
            //有投票内容
            if indexPath.row == 3 {
                let height = 44 * iPHONE_AUTORATIO * CGFloat((detailModel.voteOption?.count ?? 0))
                return 80 * iPHONE_AUTORATIO + height
            }
            
            if indexPath.row == 4 {
                return 72 * iPHONE_AUTORATIO
            }
            
            if indexPath.row == 5 {
                return 59 * iPHONE_AUTORATIO;
            }
            
            return 59 * iPHONE_AUTORATIO + (model?.comment?[indexPath.row - 6].detail.string.ga_heightForComment(fontSize: 14 * iPHONE_AUTORATIO, width: K_SCREEN_WIDTH - 83 * iPHONE_AUTORATIO) ?? 0)
        }
        
        if indexPath.row == 3 {
            return 72 * iPHONE_AUTORATIO
        }
        
        if indexPath.row == 4 {
            return 59 * iPHONE_AUTORATIO;
        }
        
        return 59 * iPHONE_AUTORATIO + (model?.comment?[indexPath.row - 5].detail.string.ga_heightForComment(fontSize: 14 * iPHONE_AUTORATIO, width: K_SCREEN_WIDTH - 83 * iPHONE_AUTORATIO) ?? 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //判断是不是有投票内容
        if let detailModel = model, detailModel.voteID.int != 0 {
            if indexPath.row == 5 {
                let vc = CommentCommonController()
                vc.commentId = Int(id) ?? 0
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if indexPath.row == 4 {
                let vc = CommentCommonController()
                vc.commentId = Int(id) ?? 0
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

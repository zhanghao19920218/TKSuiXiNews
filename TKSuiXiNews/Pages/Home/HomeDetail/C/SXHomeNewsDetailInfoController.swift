//
//  HomeNewsDetailInfoController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/2.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let articleContentIdentifier = "HomeArticleContentWebCellIdentifier"
fileprivate let commentTitleIdentifier = "CommonDetailTitleNameCellIdentifier"
fileprivate let shareBottomCellIdentifier = "BaseShareBottomViewIdentifier"
fileprivate let commentLikeNumCellIdentifier = "DetailCommentLikeNumCellIdentifier"
fileprivate let detialCommentsIdentifier = "DetailUserCommentCellIdentifier"
fileprivate let voteSectionCellIdentifier = "DetailInfoVoteSectionCellIdentifier" //投票的Cell

class SXHomeNewsDetailInfoController: SXBaseViewController {
    //动态调整的webView高度
    fileprivate var _webViewHeight = 400 * iPHONE_AUTORATIO
    
    //设置右侧的navigationItem
    private lazy var _rightNavigatorItem: UIButton = {
        let button = UIButton(type: .custom);
        button.setSelectedImage("article_favorite")
        button.setImage("detail_unfavo_icon")
        button.frame = CGRect(x: 0, y: 0, width: 30 * iPHONE_AUTORATIO, height: 30 * iPHONE_AUTORATIO)
        button.addTarget(self, action: #selector(addFavoriteButton(_:)), for: .touchUpInside)
        return button;
    }();

    var model: SXDetailArticleData?
    
    var voteModel: SXVoteContentDetailModelResponse? = nil
    //获取详情的id
    var id: String = "0"
    
    //设置tableView
    private lazy var _tableView: UITableView = {
        let tableView = UITableView();
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none;
        tableView.register(SXHomeArticleContentWebCell.self, forCellReuseIdentifier: articleContentIdentifier)
        tableView.register(SXCommonDetailTitleNameCell.self, forCellReuseIdentifier: commentTitleIdentifier)
        tableView.register(BaseShareBottomView.self, forCellReuseIdentifier: shareBottomCellIdentifier);
        tableView.register(SXDetailCommentLikeNumCell.self, forCellReuseIdentifier: commentLikeNumCellIdentifier)
        tableView.register(SXDetailUserCommentCell.self, forCellReuseIdentifier: detialCommentsIdentifier)
        tableView.register(DetailInfoVoteSectionCell.self, forCellReuseIdentifier: voteSectionCellIdentifier) //投票的Cell
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
                        QQShareInstance.share.shareQQ(title: self?.model?.name.string ?? K_JT_normal_share_title, url: url)
                    }
                    if type == .weibo { //微博分享
                        ThirdPartyLogin.share.shareWebToSina(title: self?.model?.name.string ?? K_JT_normal_share_title, url: url)
                    }
                    if type == .circle { //朋友圈
                        ThirdPartyLogin.share.shareWechatTimeline(title: self?.model?.name.string ?? K_JT_normal_share_title, url: url)
                    }
                    if type == .wechat {
                        ThirdPartyLogin.share.shareWechatFriend(title: self?.model?.name.string ?? K_JT_normal_share_title, url: url)
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
        
        setupUI()
        
        loadDetailData(); //请求数据
        
        if title == "公告" {
            self._rightNavigatorItem.isHidden = true
        }
        
    }
    
    //请求定时器进行加分
    override func _counterAction() {
        super._counterAction()
        
        readGetScore()
    }
    
    //初始化页面
    private func setupUI() {
        
        view.addSubview(_tableView);
        _tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview();
            make.bottom.equalTo(-49 * iPHONE_AUTORATIO);
        }
        
        //底部评论
        view.addSubview(bottomView);
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview();
            make.height.equalTo(49 * iPHONE_AUTORATIO);
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: _rightNavigatorItem);
    }
    
    @objc private func addFavoriteButton(_ sender: UIButton){
        if sender.isSelected {
            deleteFavorte()
        } else {
            addFavorte()
        }
    }
    
}

extension SXHomeNewsDetailInfoController {
    //MARK: - 获取新闻详情
    private func loadDetailData() {
        HttpClient.shareInstance.request(target: BAAPI.articleDetail(id: id), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXDetailArticleResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.model = forceModel.data
            
            self?._tableView.reloadData();
            
            //判断是不是已经收藏
            if forceModel.data.collectStatus.int == 1 {
                self?._rightNavigatorItem.isSelected = true
            } else {
                self?._rightNavigatorItem.isSelected = false
            }
            
            self?.bottomView.isLike = forceModel.data.likeStatus.int
            
            //如果有投票请求投票接口
            if forceModel.data.voteID.int != 0 {
                self?.getVoteContent(id: forceModel.data.voteID.int)
            }
            
            //刷新详情页面的几个参数
            self?._commentNum = forceModel.data.commentNum.int
            self?._reviewNum = forceModel.data.visitNum.int
            self?._likeNum = forceModel.data.likeNum.int
            self?._isLike = (forceModel.data.likeStatus.int == 1)
            self?.parametersBlock(self?._commentNum ?? 0, self?._reviewNum ?? 0, self?._likeNum ?? 0, self?._isLike ?? false)
            
            }
        )
    }
    
    //MARK: - 上传新闻评论信息
    private func sendComment(_ msg: String) {
        //去掉评论的数据
        let message = msg.removeHeadAndTailSpacePro
        
        if message.isEmpty {
            TProgressHUD.show(text: "请输入评论")
            return
        }
        
        HttpClient.shareInstance.request(target: BAAPI.commentAdd(id: Int(id) ?? 0, detail: message), success: { [weak self] (json) in
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
    
    //MARK: - 添加收藏
    private func addFavorte(){
        HttpClient.shareInstance.request(target: BAAPI.addFavorite(id:  Int(id) ?? 0), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let baseModel = try? decoder.decode(BaseModel.self, from: json)
            TProgressHUD.show(text: baseModel?.msg ?? "点赞失败")
            self?.loadDetailData()
            }
        )
    }
    
    //MARK: - 取消收藏
    private func deleteFavorte() {
        HttpClient.shareInstance.request(target: BAAPI.cancelFavorite(articleId: Int(id) ?? 0), success: { [weak self] (json) in
            TProgressHUD.show(text: "取消收藏成功")
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
            let model = try? decoder.decode(SXVoteContentDetailModelResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.voteModel = forceModel
            self?._tableView.reloadData()
            
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

extension SXHomeNewsDetailInfoController: UITableViewDelegate, UITableViewDataSource {
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
            return 5 + (model?.comment?.count ?? 0)
        }
        return 4 + (model?.comment?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //视频信息界面
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: commentTitleIdentifier) as! SXCommonDetailTitleNameCell
            cell.title = model?.name.string
            cell.writer = model?.nickname.string
            cell.time = model?.begintime?.string
            cell.review = model?.visitNum.int
            return cell
        }
        
        //用户发表内容
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: articleContentIdentifier) as! SXHomeArticleContentWebCell
            cell.loadUrl = model?.content.string
            cell.block = { [weak self](height) in
                self?._webViewHeight = height
                self?._tableView.reloadData()
            }
            return cell
        }
        
        //判断是不是有投票内容
        if let detailModel = model, detailModel.voteID.int != 0 {
            //是不是用户投票的界面
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: voteSectionCellIdentifier) as! DetailInfoVoteSectionCell
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
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: shareBottomCellIdentifier) as! BaseShareBottomView
                cell.shareBlock = { type in
                    let url = K_URL_Share + (self.model?.id.string ?? "0")
                    if type == .qqShare { //QQ分享
                        QQShareInstance.share.shareQQ(title: self.model?.name.string ?? K_JT_normal_share_title, url: url)
                    }
                    if type == .weiboShare { //微博分享
                        ThirdPartyLogin.share.shareWebToSina(title: self.model?.name.string ?? K_JT_normal_share_title, url: url)
                    }
                    if type == .circleShare { //朋友圈
                        ThirdPartyLogin.share.shareWechatTimeline(title: self.model?.name.string ?? K_JT_normal_share_title, url: url)
                    }
                    if type == .wechatShare {
                        ThirdPartyLogin.share.shareWechatFriend(title: self.model?.name.string ?? K_JT_normal_share_title, url: url)
                    }
                }
                return cell
            }
            
            
            //用户称赞数量和评论数量
            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: commentLikeNumCellIdentifier) as! SXDetailCommentLikeNumCell
                cell.comment = model?.commentNum.int
                cell.like = model?.likeNum.int
                return cell
            }
            
            //用户评论
            let cell = tableView.dequeueReusableCell(withIdentifier: detialCommentsIdentifier) as! SXDetailUserCommentCell
            cell.avatar = model?.comment?[indexPath.row - 5].avatar.string
            cell.nickname = model?.comment?[indexPath.row - 5].nickname.string
            cell.comment = model?.comment?[indexPath.row - 5].detail.string
            cell.time = model?.comment?[indexPath.row - 5].createtime.string
            return cell
        }
        
        //如果没有投票内容
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: shareBottomCellIdentifier) as! BaseShareBottomView
            cell.shareBlock = { type in
                let url = K_URL_Share + (self.model?.id.string ?? "0")
                if type == .qqShare { //QQ分享
                    QQShareInstance.share.shareQQ(title: self.model?.name.string ?? K_JT_normal_share_title, url: url)
                }
                if type == .weiboShare { //微博分享
                    ThirdPartyLogin.share.shareWebToSina(title: self.model?.name.string ?? K_JT_normal_share_title, url: url)
                }
                if type == .circleShare { //朋友圈
                    ThirdPartyLogin.share.shareWechatTimeline(title: self.model?.name.string ?? K_JT_normal_share_title, url: url)
                }
                if type == .wechatShare {
                    ThirdPartyLogin.share.shareWechatFriend(title: self.model?.name.string ?? K_JT_normal_share_title, url: url)
                }
            }
            return cell
        }
        
        
        //用户称赞数量和评论数量
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: commentLikeNumCellIdentifier) as! SXDetailCommentLikeNumCell
            cell.comment = model?.commentNum.int
            cell.like = model?.likeNum.int
            return cell
        }
        
        //用户评论
        let cell = tableView.dequeueReusableCell(withIdentifier: detialCommentsIdentifier) as! SXDetailUserCommentCell
        cell.avatar = model?.comment?[indexPath.row - 4].avatar.string
        cell.nickname = model?.comment?[indexPath.row - 4].nickname.string
        cell.comment = model?.comment?[indexPath.row - 4].detail.string
        cell.time = model?.comment?[indexPath.row - 4].createtime.string
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120 * iPHONE_AUTORATIO
        }
        
        if indexPath.row == 1 {
            return _webViewHeight
        }
        
        //判断是不是有投票内容
        if let detailModel = model, detailModel.voteID.int != 0 {
            //有投票内容
            if indexPath.row == 2 {
                let height = 44 * iPHONE_AUTORATIO * CGFloat((detailModel.voteOption?.count ?? 0))
                return 80 * iPHONE_AUTORATIO + height
            }
            
            if indexPath.row == 3 {
                return 72 * iPHONE_AUTORATIO
            }
            
            if indexPath.row == 4 {
                return 59 * iPHONE_AUTORATIO;
            }
            
            return 59 * iPHONE_AUTORATIO + (model?.comment?[indexPath.row - 5].detail.string.ga_heightForComment(fontSize: 14 * iPHONE_AUTORATIO, width: K_SCREEN_WIDTH - 83 * iPHONE_AUTORATIO) ?? 0)
        }
        
        if indexPath.row == 2 {
            return 72 * iPHONE_AUTORATIO
        }
        
        if indexPath.row == 3 {
            return 59 * iPHONE_AUTORATIO;
        }
        
        return 59 * iPHONE_AUTORATIO + (model?.comment?[indexPath.row - 4].detail.string.ga_heightForComment(fontSize: 14 * iPHONE_AUTORATIO, width: K_SCREEN_WIDTH - 83 * iPHONE_AUTORATIO) ?? 0)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //进入评论页面
        //判断是不是有投票内容
        if let detailModel = model, detailModel.voteID.int != 0 {
            if indexPath.row == 4 {
                let vc = SXCommentCommonController()
                vc.articleCommentId = Int(id) ?? 0
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if indexPath.row == 3 {
                let vc = SXCommentCommonController()
                vc.articleCommentId = Int(id) ?? 0
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

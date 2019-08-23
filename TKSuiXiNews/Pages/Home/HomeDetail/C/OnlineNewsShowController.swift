//
//  OnlineNewsShowController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let videoPlayIdentifier = "VideoNewsDetailInfoCellIdentifier"
fileprivate let articleTitleIdentifier = "OnlineShowTitleReviewCellIdentifier"
fileprivate let likeCellIdentifier = "DetailCommentLikeNumCellIdentifier"
fileprivate let commentCellIdentifier = "DetailUserCommentCellIdentifier"
fileprivate let voteCellIdentifier = "DetailInfoVoteSectionCellIdentifier" //投票的Cell
fileprivate let articleWebContentIdentifier = "HomeArticleContentWebCellIdentifier" //新闻内容的Cell

///直播详情页面
class OnlineNewsShowController: BaseViewController {
    //动态调整的webView高度
    fileprivate var webViewHeight:CGFloat = 0

    var model: DetailArticleModel?
    //获取详情的id
    var id: String = "0"
    
    //获取当前投票的index
    private var _currentVoteIndex: Int?
    
    var voteModel: VoteContentDetailModelResponse?
    
    //设置tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView();
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none;
        tableView.register(VideoNewsDetailInfoCell.self, forCellReuseIdentifier: videoPlayIdentifier)
        tableView.register(OnlineShowTitleReviewCell.self, forCellReuseIdentifier: articleTitleIdentifier)
        tableView.register(DetailCommentLikeNumCell.self, forCellReuseIdentifier: likeCellIdentifier)
        tableView.register(DetailUserCommentCell.self, forCellReuseIdentifier: commentCellIdentifier)
        tableView.register(DetailInfoVoteSectionCell.self, forCellReuseIdentifier: voteCellIdentifier) //投票的Cell
        tableView.register(HomeArticleContentWebCell.self, forCellReuseIdentifier: articleWebContentIdentifier)
        //iOS 11Self-Sizing自动打开后，contentSize和contentOffset都可能发生改变。可以通过以下方式禁用
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView;
    }();
    
    private lazy var commentView: OnlineSendCommentView = {
        let view = OnlineSendCommentView()
        view.commentBlock = { [weak self] (comment) in
            self?.sendComment(comment)
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "直播"
        
        //请求定时器进行加分
        timerTravel = 360
        
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
            make.bottom.equalTo(-50 * iPHONE_AUTORATIO);
        }
        
        //底部评论
        view.addSubview(commentView);
        commentView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview();
            make.height.equalTo(50 * iPHONE_AUTORATIO);
        }
    }
    
}

extension OnlineNewsShowController {
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

extension OnlineNewsShowController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //没有为nil
        if model == nil {
            return 0;
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let detailModel = model, detailModel.voteID.int != 0 {
            return 5 + (model?.comment?.count ?? 0)
        }
        return 4 + (model?.comment?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //播放视频信息
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: videoPlayIdentifier) as! VideoNewsDetailInfoCell
            cell.imageUrl = model?.image.string
            return cell
        }
        
        //视频信息界面
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: articleTitleIdentifier) as! OnlineShowTitleReviewCell
            cell.title = model?.name.string
            cell.reviewNum = model?.visitNum.int
            return cell
        }
        
        //直播具体内容的信息
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: articleWebContentIdentifier) as! HomeArticleContentWebCell
            cell.loadUrl = model?.content.string
            cell.block = { [weak self](height) in
                self?.webViewHeight = height
                self?.tableView.reloadData()
            }
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
            
            //用户称赞数量和评论数量
            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: likeCellIdentifier) as! DetailCommentLikeNumCell
                cell.comment = model?.commentNum.int
                cell.like = model?.likeNum.int
                cell.isHiddenLike = true
                return cell
            }
            
            //用户评论
            let cell = tableView.dequeueReusableCell(withIdentifier: commentCellIdentifier) as! DetailUserCommentCell
            cell.avatar = model?.comment?[indexPath.row - 5].avatar.string
            cell.nickname = model?.comment?[indexPath.row - 5].nickname.string
            cell.comment = model?.comment?[indexPath.row - 5].detail.string
            cell.time = model?.comment?[indexPath.row - 5].createtime.string
            return cell
            
        } else {
            
            //用户称赞数量和评论数量
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: likeCellIdentifier) as! DetailCommentLikeNumCell
                cell.comment = model?.commentNum.int
                cell.like = model?.likeNum.int
                cell.isHiddenLike = true
                return cell
            }
            
            //用户评论
            let cell = tableView.dequeueReusableCell(withIdentifier: commentCellIdentifier) as! DetailUserCommentCell
            cell.avatar = model?.comment?[indexPath.row - 4].avatar.string
            cell.nickname = model?.comment?[indexPath.row - 4].nickname.string
            cell.comment = model?.comment?[indexPath.row - 4].detail.string
            cell.time = model?.comment?[indexPath.row - 4].createtime.string
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 188 * iPHONE_AUTORATIO
        }
        
        if indexPath.row == 1 {
            return 65 * iPHONE_AUTORATIO
        }
        
        if indexPath.row == 2 {
            return webViewHeight
        }
        
        //判断是不是有投票内容
        if let detailModel = model, detailModel.voteID.int != 0 {
            if indexPath.row == 3 {
                let height = 44 * iPHONE_AUTORATIO * CGFloat((detailModel.voteOption?.count ?? 0))
                return 80 * iPHONE_AUTORATIO + height
            }
            if indexPath.row == 4 {
                return 59 * iPHONE_AUTORATIO;
            }
            
            return 59 * iPHONE_AUTORATIO + (model?.comment?[indexPath.row - 5].detail.string.ga_heightForComment(fontSize: 14 * iPHONE_AUTORATIO, width: K_SCREEN_WIDTH - 83 * iPHONE_AUTORATIO) ?? 0)
        } else {
            if indexPath.row == 3 {
                return 59 * iPHONE_AUTORATIO;
            }
            
            return 59 * iPHONE_AUTORATIO + (model?.comment?[indexPath.row - 4].detail.string.ga_heightForComment(fontSize: 14 * iPHONE_AUTORATIO, width: K_SCREEN_WIDTH - 83 * iPHONE_AUTORATIO) ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = OnlineTVShowViewController(url: model?.video.string ?? "")
            vc.id = model?.id.int ?? 0
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        //判断是不是有投票内容
        if let detailModel = model, detailModel.voteID.int != 0 {
            if indexPath.row == 4 {
                let vc = CommentCommonController()
                vc.commentId = Int(id) ?? 0
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if indexPath.row == 3 {
                let vc = CommentCommonController()
                vc.commentId = Int(id) ?? 0
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK: - 滚动刷新页面数据，防止产生空白页面
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //滚动过程中强制渲染一下webView
        if tableView == scrollView {
            for cell in tableView.visibleCells {
                if cell is HomeArticleContentWebCell {
                    (cell as! HomeArticleContentWebCell).webView.setNeedsLayout()
                }
            }
        }
    }
}
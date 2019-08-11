//
//  ShowDetailImageViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 图文的Controller
 */

fileprivate let avatarIdentifier = "DetailUserInfoAvatarCellIdentifier"
fileprivate let nameCellIdentifier = "DetailUserInfoNameCellIdentifier"
fileprivate let imagesIdentifier = "ShowImagesCollectionCellCellIdentifier"
fileprivate let shareCellIdentifier = "BaseShareBottomViewIdentifier"
fileprivate let likeCellIdentifier = "DetailCommentLikeNumCellIdentifier"
fileprivate let commentCellIdentifier = "DetailUserCommentCellIdentifier"

class ShowDetailImageViewController: BaseViewController {
    var model: DetailArticleModel?
    //获取详情的id
    var id: String = "0"
    
    //设置tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView();
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none;
        tableView.register(DetailUserInfoAvatarCell.self, forCellReuseIdentifier: avatarIdentifier)
        tableView.register(DetailUserInfoNameCell.self, forCellReuseIdentifier: nameCellIdentifier)
        tableView.register(ShowImagesCollectionCell.self, forCellReuseIdentifier: imagesIdentifier)
        tableView.register(BaseShareBottomView.self, forCellReuseIdentifier: shareCellIdentifier);
        tableView.register(DetailCommentLikeNumCell.self, forCellReuseIdentifier: likeCellIdentifier)
        tableView.register(DetailUserCommentCell.self, forCellReuseIdentifier: commentCellIdentifier);
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
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "图文"
        
        setupUI()
        
        loadDetailData(); //请求数据
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

extension ShowDetailImageViewController {
    //MARK: - 获取新闻详情
    private func loadDetailData() {
        HttpClient.shareInstance.request(target: BAAPI.articleDetail(id: id), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(DetailArticleResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.model = forceModel.data
            
            self?.tableView.reloadData();
            self?.bottomView.isLike = forceModel.data.likeStatus.int
            }
        )
    }
    
    //MARK: - 上传新闻评论信息
    private func sendComment(_ msg: String) {
        HttpClient.shareInstance.request(target: BAAPI.commentAdd(id: Int(id) ?? 0, detail: msg), success: { [weak self] (json) in
            TProgressHUD.show(text: "发表评论成功")
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
}

extension ShowDetailImageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //没有为nil
        if model == nil {
            return 0;
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 + (model?.comment?.count ?? 0);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //用户头像时间
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: avatarIdentifier) as! DetailUserInfoAvatarCell
            cell.nickname = model?.nickname.string
            cell.time = model?.begintime.string
            cell.avatar = model?.avatar.string
            return cell;
        }
        
        //用户发表内容
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: nameCellIdentifier) as! DetailUserInfoNameCell
            cell.name = model?.name.string
            return cell
        }
        
        //用户视频页面
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: imagesIdentifier) as! ShowImagesCollectionCell
            cell.images = model?.images
            return cell
        }
        
        //用户分享的Cell
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: shareCellIdentifier) as! BaseShareBottomView
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
            return 72 * iPHONE_AUTORATIO;
        }
        if indexPath.row == 1 {
            //计算文本高度
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
        if indexPath.row == 3 {
            return 72 * iPHONE_AUTORATIO
        }
        if indexPath.row == 4 {
            return 59 * iPHONE_AUTORATIO;
        }
        
        return 59 * iPHONE_AUTORATIO + (model?.comment?[indexPath.row - 5].detail.string.ga_heightForComment(fontSize: 14 * iPHONE_AUTORATIO, width: K_SCREEN_WIDTH - 83 * iPHONE_AUTORATIO) ?? 0)
    }
}

//
//  HomeVVideoNormalCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/21.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let textStyle = kFont(13 * iPHONE_AUTORATIO);
fileprivate let fontColor = RGBA(153, 153, 153, 1);

//MARK: - 初始化V视频Item
class HomeVVideoNormalCell: BaseTableViewCell {
    var block = { () in }
    
    /// 显示删除
    var isShowDelete:Bool? {
        willSet(newValue) {
            if let value = newValue, value {
                deleteButton.isHidden = false
            } else {
                deleteButton.isHidden = true
            }
        }
    }
    
    var deleteBlock: () -> Void = {  }
    //MARK: -设置参数
    var describe: String? {
        willSet(value) {
            describeLabel.text = value ?? "";
        }
    }
    
    var imageUrl: String? {
        willSet(value) {
            if let url = value {
                videoImageView.kf.setImage(with: URL(string: url), placeholder: K_ImageName(PLACE_HOLDER_IMAGE));
            }
        }
    }
    
    //视频地址
    var videoUrl: String?
    
    var videoLength: String? {
        willSet(value) {
            videoLengthLabel.text = value ?? "00:00";
        }
    }
    
    var avatar: String? {
        willSet(value) {
            if let url = value {
                avatarImage.kf.setImage(with: URL(string: url), placeholder: K_ImageName(PLACE_HOLDER_IMAGE));
            }
        }
    }
    
    var nickname: String? {
        willSet(value) {
            nickNameL.text = value ?? "";
        }
    }
    
    var comment: String? {
        willSet(value) {
            commentLabel.text = value ?? "0";
        }
    }
    
    var like: String? {
        willSet(value) {
            likeLabel.text = value ?? "0";
        }
    }
    
    var isLike: Int? {
        willSet(value) {
            if let bool = value {
                likeIcon.image = K_ImageName(bool == 1 ? "like_list_icon" : "dislike_list_icon");
            }
        }
    }
    
    
    //照片
    private lazy var videoImageView: UIImageView = {
        let imageView = UIImageView();
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true;
        //增加一个变灰色的view
        let view = UIView();
        imageView.addSubview(view);
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview();
        });
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5);
        return imageView;
    }();
    
    //照片的描述
    private lazy var describeLabel: UILabel = {
        let label = UILabel.init();
        label.font = kFont(14 * iPHONE_AUTORATIO);
        label.textColor = .white;
        label.numberOfLines = 2; //最多两行
        return label;
    }();
    
    //播放按钮
    private lazy var playItem: UIButton = {
        let button = UIButton(type: .custom);
        button.setImage(K_ImageName("play_video"), for: .normal);
        button.imageEdgeInsets = UIEdgeInsets(top: 30 * iPHONE_AUTORATIO, left: 30 * iPHONE_AUTORATIO, bottom: 30 * iPHONE_AUTORATIO, right: 30 * iPHONE_AUTORATIO)
        button.addTarget(self,
                         action: #selector(didSelectedPlayItemBlock(_:)),
                         for: .touchUpInside)
        return button;
    }();
    
    //视频长度描述
    private lazy var videoLengthLabel: UILabel = {
        let label = UILabel.init();
        label.font = kFont(9 * iPHONE_AUTORATIO);
        label.textColor = .white;
        label.text = "00:00"
        return label;
    }();
    
    //用户的头像
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView.init();
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE);
        imageView.layer.cornerRadius = 15 * iPHONE_AUTORATIO;
        imageView.layer.masksToBounds = true;
        return imageView;
    }();
    
    //用户的昵称
    private lazy var nickNameL: UILabel = {
        let label = UILabel();
        label.font = kFont(14 * iPHONE_AUTORATIO);
        return label;
    }();
    
    //评论数量
    private lazy var commentIcon: UIImageView = {
        let imageView = UIImageView.init();
        imageView.image = K_ImageName("comment_list_icon");
        return imageView;
    }();
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel.init();
        label.font = textStyle;
        label.textColor = fontColor;
        label.text = "";
        return label;
    }();
    
    //点赞
    private lazy var likeIcon: UIImageView = {
        let imageView = UIImageView();
        imageView.image = K_ImageName("dislike_list_icon")
        return imageView;
    }();
    
    private lazy var likeLabel: UILabel = {
        let label = UILabel.init();
        label.font = textStyle;
        label.text = "0";
        label.textColor = fontColor;
        return label;
    }()
    
    //删除的按钮
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("删除")
        button.setTitleColor(appThemeColor)
        button.titleLabel?.font = textStyle
        button.isHidden = true
        button.addTarget(self,
                         action: #selector(didSelectedDeleteItemButton(_:)),
                         for: .touchUpInside)
        return button
    }()

    override func setupUI() {
        super.setupUI();
        
        //背景颜色
        let view = UIView();
        contentView.addSubview(view);
        view.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview();
            make.height.equalTo(10 * iPHONE_AUTORATIO);
        }
        view.backgroundColor = RGBA(244, 244, 244, 1);
        
        //照片
        contentView.addSubview(videoImageView);
        videoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(10 * iPHONE_AUTORATIO);
            make.left.right.equalToSuperview();
            make.height.equalTo(188 * iPHONE_AUTORATIO);
        };
        
        //描述
        videoImageView.addSubview(describeLabel);
        describeLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(15 * iPHONE_AUTORATIO);
            make.right.equalTo(-15 * iPHONE_AUTORATIO);
        };
        
        //播放按钮
        videoImageView.addSubview(playItem);
        playItem.snp.makeConstraints { (make) in
            make.center.equalToSuperview();
            make.size.equalTo(CGSize(width: 95 * iPHONE_AUTORATIO, height: 95 * iPHONE_AUTORATIO));
        };
        
        //视频长度
        videoImageView.addSubview(videoLengthLabel);
        videoLengthLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-21 * iPHONE_AUTORATIO);
            make.bottom.equalTo(-14 * iPHONE_AUTORATIO);
        };
        
        //头像
        contentView.addSubview(avatarImage);
        avatarImage.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO);
            make.bottom.equalTo(-11 * iPHONE_AUTORATIO);
            make.size.equalTo(CGSize(width: 30 * iPHONE_AUTORATIO, height: 30 * iPHONE_AUTORATIO));
        };
        
        //昵称
        contentView.addSubview(nickNameL);
        nickNameL.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImage.snp_right).offset(10 * iPHONE_AUTORATIO);
            make.centerY.equalTo(self.avatarImage.snp_centerY);
        };
        
        //评论
        contentView.addSubview(commentIcon);
        commentIcon.snp.makeConstraints { (make) in
            make.left.equalTo(243 * iPHONE_AUTORATIO);
            make.centerY.equalTo(self.avatarImage.snp_centerY);
            make.size.equalTo(CGSize(width: 13 * iPHONE_AUTORATIO, height: 12 * iPHONE_AUTORATIO));
        };
        
        //评论数量
        contentView.addSubview(commentLabel);
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.commentIcon.snp_right).offset(8 * iPHONE_AUTORATIO);
            make.centerY.equalTo(self.avatarImage.snp_centerY);
        };
        
        //点赞
        contentView.addSubview(likeIcon);
        likeIcon.snp.makeConstraints { (make) in
            make.left.equalTo(318 * iPHONE_AUTORATIO);
            make.centerY.equalTo(self.avatarImage.snp_centerY);
            make.size.equalTo(CGSize(width: 11 * iPHONE_AUTORATIO, height: 11 * iPHONE_AUTORATIO));
        };
        
        contentView.addSubview(likeLabel);
        likeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.likeIcon.snp_right).offset(5 * iPHONE_AUTORATIO);
            make.centerY.equalTo(self.avatarImage.snp_centerY);
        }
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(nickNameL.snp_centerY)
            make.left.equalTo(nickNameL.snp_right).offset(5 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 80 * iPHONE_AUTORATIO, height: 40 * iPHONE_AUTORATIO))
        }
    }
    
    //MARK: - 点击播放按钮的Block
    @objc private func didSelectedPlayItemBlock(_ sender: UIButton){
        print("点击了按钮");
        block();
    }
    
    //MARK: - 点击了删除按钮
    @objc private func didSelectedDeleteItemButton(_ sender: UIButton) {
        deleteBlock()
    }

}

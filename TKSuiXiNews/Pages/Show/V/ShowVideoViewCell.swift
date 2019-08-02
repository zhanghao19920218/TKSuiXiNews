//
//  ShowVideoViewCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/21.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class ShowVideoViewCell: BaseTableViewCell {
    var block: () -> Void = {}
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
            nicknameLabel.text = value ?? "";
        }
    }
    
    var comment: String? {
        willSet(value) {
            bottomView.comment = value
        }
    }
    
    var like: String? {
        willSet(value) {
            bottomView.like = value
        }
    }
    
    var isLike: Int? {
        willSet(value) {
            bottomView.isLike = value
        }
    }
    
    var beginTime:String? {
        willSet(value) {
            bottomView.time = value ?? "0小时前"
        }
    }
    
    //用户头像
    private lazy var avatarImage:BaseAvatarImageView = {
        let imageView = BaseAvatarImageView(frame: .zero);
        return imageView;
    }();
    
    //用户昵称
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(16 * iPHONE_AUTORATIO);
        label.numberOfLines = 3;
        return label;
    }();
    
    //用户的内容
    private lazy var describeLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(14 * iPHONE_AUTORATIO);
        return label;
    }();
    
    //用户下方的评论
    private lazy var bottomView: BaseTimeCommentLikeView = {
        let view = BaseTimeCommentLikeView();
        return view;
    }();
    
    //照片
    private lazy var videoImageView: UIImageView = {
        let imageView = UIImageView();
        //增加一个变灰色的view
        let view = UIView();
        imageView.addSubview(view);
        imageView.isUserInteractionEnabled = true
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview();
        });
        imageView.contentMode =  UIView.ContentMode.scaleToFill;
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5);
        return imageView;
    }();
    
    //播放按钮
    private lazy var playItem: UIButton = {
        let button = UIButton(type: .custom);
        button.setImage(K_ImageName("play_video"), for: .normal);
        button.addTarget(self,
                         action: #selector(tappedPlayItem(_:)),
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
    
    override func setupUI() {
        super.setupUI();
        
        addSubview(avatarImage);
        avatarImage.snp.makeConstraints { (make) in
            make.top.equalTo(15 * iPHONE_AUTORATIO);
            make.left.equalTo(13 * iPHONE_AUTORATIO);
            make.size.equalTo(CGSize(width: 42 * iPHONE_AUTORATIO, height: 42 * iPHONE_AUTORATIO));
        };
        
        addSubview(nicknameLabel);
        nicknameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImage.snp_right).offset(10 * iPHONE_AUTORATIO);
            make.top.equalTo(15 * iPHONE_AUTORATIO);
        }
        
        addSubview(describeLabel);
        describeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(44 * iPHONE_AUTORATIO);
            make.left.equalTo(65 * iPHONE_AUTORATIO);
        }
        
        //照片
        contentView.addSubview(videoImageView);
        videoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(97 * iPHONE_AUTORATIO);
            make.left.equalTo(65 * iPHONE_AUTORATIO);
            make.right.equalTo(-13 * iPHONE_AUTORATIO);
            make.height.equalTo(188 * iPHONE_AUTORATIO);
        };
        
        //播放按钮
        videoImageView.addSubview(playItem);
        playItem.snp.makeConstraints { (make) in
            make.center.equalToSuperview();
            make.size.equalTo(CGSize(width: 35 * iPHONE_AUTORATIO, height: 35 * iPHONE_AUTORATIO));
        };
        
        //视频长度
        videoImageView.addSubview(videoLengthLabel);
        videoLengthLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-21 * iPHONE_AUTORATIO);
            make.bottom.equalTo(-14 * iPHONE_AUTORATIO);
        };
        
        addSubview(bottomView);
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15 * iPHONE_AUTORATIO);
            make.left.equalTo(65 * iPHONE_AUTORATIO);
            make.right.equalTo(-13 * iPHONE_AUTORATIO);
        };
    }
    
    //MARK: - 点击播放按钮
    @objc private func tappedPlayItem(_ sender: UIButton) {
        block()
    }

}

//
//  DetailUserInfoAvatar.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 视频详情: 头像 + 昵称 + 时间
 */

class SXDetailUserInfoAvatarCell: BaseTableViewCell {
    //获取头像
    var avatar: String? {
        willSet(value) {
            avatarImg.imageName = value;
        }
    }
    
    //获取昵称
    var nickname:String? {
        willSet(value) {
            nicknameLabel.text = value ?? "";
        }
    }
    
    //获取小时
    var time:String? {
        willSet(value) {
            timeLabel.text = value ?? "0小时前";
        }
    }

    //头像
    private lazy var avatarImg: BaseAvatarImageView = {
        let imageView = BaseAvatarImageView(frame: .zero);
        return imageView;
    }();
    
    //昵称
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(16 * iPHONE_AUTORATIO);
        return label;
    }();
    
    //时间
    private lazy var timeLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(13 * iPHONE_AUTORATIO);
        label.textColor = RGBA(153, 153, 153, 1);
        label.text = "0小时前"
        label.textAlignment = .right;
        return label;
    }();
    
    override func setupUI() {
        super.setupUI();
        
        //头像
        contentView.addSubview(avatarImg);
        avatarImg.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 42 * iPHONE_AUTORATIO, height: 42 * iPHONE_AUTORATIO));
        }
        
        //昵称
        contentView.addSubview(nicknameLabel);
        nicknameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(65 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        //时间
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-14 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
    }
}

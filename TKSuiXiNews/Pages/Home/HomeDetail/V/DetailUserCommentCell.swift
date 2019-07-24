//
//  DetailUserCommentCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 用户评论的cell
 */

class DetailUserCommentCell: BaseTableViewCell {
    //获取头像
    var avatar: String? {
        willSet(value) {
            avatarImg.imageName = value;
        }
    }
    
    //获取昵称
    var nickname:String? {
        willSet(value) {
            nameLabel.text = value ?? "";
        }
    }
    
    //获取小时
    var time:String? {
        willSet(value) {
            timeLabel.text = value ?? "2019-01-01 00:00";
        }
    }
    
    //获取评论
    var comment:String? {
        willSet(value) {
            commentL.text = value ?? "";
        }
    }
    
    
    
    //用户头像
    private lazy var avatarImg: BaseAvatarImageView = {
        let view = BaseAvatarImageView(frame: .zero);
        return view;
    }()
    
    //用户姓名
    private lazy var nameLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(16 * iPHONE_AUTORATIO)
        return label;
    }()
    
    //评论时间
    private lazy var timeLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(12 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1);
        return label;
    }()
    
    //评论内容
    private lazy var commentL: UILabel = {
        let label = UILabel();
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.numberOfLines = 0;
        return label;
    }();
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(avatarImg);
        avatarImg.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(15 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 42 * iPHONE_AUTORATIO, height: 42 * iPHONE_AUTORATIO))
        }
        
        contentView.addSubview(nameLabel);
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(65 * iPHONE_AUTORATIO);
            make.top.equalTo(15 * iPHONE_AUTORATIO);
        }
        
        contentView.addSubview(timeLabel);
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO);
            make.centerY.equalTo(self.nameLabel.snp_centerY);
        }
        
        contentView.addSubview(commentL);
        commentL.snp.makeConstraints { (make) in
            make.top.equalTo(44 * iPHONE_AUTORATIO)
            make.left.equalTo(65 * iPHONE_AUTORATIO);
            make.right.equalTo(-18 * iPHONE_AUTORATIO);
        }
        
        contentView.addSubview(bottomLine);
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(65 * iPHONE_AUTORATIO);
            make.bottom.equalToSuperview();
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.height.equalTo(1);
        }
    }
}

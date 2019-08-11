//
//  BaseTimeCommentLikeView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/21.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let textStyle = kFont(13 * iPHONE_AUTORATIO);
fileprivate let fontColor = RGBA(153, 153, 153, 1);

class BaseTimeCommentLikeView: UIView {
    var block: () -> Void = {}
    
    var isShowDelete: Bool? {
        willSet(newValue) {
            if let value = newValue, value {
                deleteButton.isHidden = false
            } else {
                deleteButton.isHidden = true
            }
        }
    }
    
    var time:String? {
        willSet(value) {
            timeLabel.text = value ?? "0小时前";
        }
    }
    
    var comment: String? {
        willSet(value) {
            commentLabel.text = value ?? "0";
        }
    }
    
    var like:String? {
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
    
    //时间
    private lazy var timeLabel: UILabel = {
        let label = UILabel.init();
        label.textColor = fontColor;
        label.font = textStyle;
        label.text = "0小时前";
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
        label.text = "0";
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
    
    //显示删除按钮
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("删 除")
        button.setTitleColor(appThemeColor)
        button.titleLabel?.font = textStyle
        button.isHidden = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        //时间
        addSubview(timeLabel);
        timeLabel.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview();
        }
        
        //评论
        addSubview(commentIcon);
        commentIcon.snp.makeConstraints { (make) in
            make.left.equalTo(178 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 13 * iPHONE_AUTORATIO, height: 12 * iPHONE_AUTORATIO));
        };
        
        //评论数量
        addSubview(commentLabel);
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.commentIcon.snp_right).offset(8 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        };
        
        //点赞
        addSubview(likeIcon);
        likeIcon.snp.makeConstraints { (make) in
            make.left.equalTo(253 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 11 * iPHONE_AUTORATIO, height: 11 * iPHONE_AUTORATIO));
        };
        
        addSubview(likeLabel);
        likeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.likeIcon.snp_right).offset(5 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(50 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 80 * iPHONE_AUTORATIO, height: 40 * iPHONE_AUTORATIO))
        }
        
        deleteButton.addTarget(self,
                         action: #selector(deleteButtonTapped(_:)),
                         for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        block()
    }

}

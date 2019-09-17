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

///时间底部comment
class SXBaseTimeCommentLikeView: UIView {
    var block: () -> Void = {}
    
    var isShowDelete: Bool? {
        willSet(newValue) {
            if let value = newValue, value {
                _deleteButton.isHidden = false
            } else {
                _deleteButton.isHidden = true
            }
        }
    }
    
    var time:String? {
        willSet(value) {
            _timeLabel.text = value ?? "0小时前";
        }
    }
    
    var comment: String? {
        willSet(value) {
            _commentLabel.text = value ?? "0";
        }
    }
    
    var like:String? {
        willSet(value) {
            _likeLabel.text = value ?? "0";
        }
    }
    
    var isLike: Int? {
        willSet(value) {
            if let bool = value {
                _likeIcon.image = K_ImageName(bool == 1 ? "like_list_icon" : "dislike_list_icon");
            }
        }
    }
    
    //时间
    private lazy var _timeLabel: UILabel = {
        let label = UILabel.init();
        label.textColor = fontColor;
        label.font = textStyle;
        label.text = "0小时前";
        return label;
    }();
    
    //评论数量
    private lazy var _commentIcon: UIImageView = {
        let imageView = UIImageView.init();
        imageView.image = K_ImageName("comment_list_icon");
        return imageView;
    }();
    
    private lazy var _commentLabel: UILabel = {
        let label = UILabel.init();
        label.font = textStyle;
        label.textColor = fontColor;
        label.text = "0";
        return label;
    }();
    
    //点赞
    private lazy var _likeIcon: UIImageView = {
        let imageView = UIImageView();
        imageView.image = K_ImageName("dislike_list_icon")
        return imageView;
    }();
    
    private lazy var _likeLabel: UILabel = {
        let label = UILabel.init();
        label.font = textStyle;
        label.text = "0";
        label.textColor = fontColor;
        return label;
    }()
    
    //显示删除按钮
    private lazy var _deleteButton: UIButton = {
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
        addSubview(_timeLabel);
        _timeLabel.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview();
        }
        
        //评论
        addSubview(_commentIcon);
        _commentIcon.snp.makeConstraints { (make) in
            make.left.equalTo(178 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 13 * iPHONE_AUTORATIO, height: 12 * iPHONE_AUTORATIO));
        };
        
        //评论数量
        addSubview(_commentLabel);
        _commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self._commentIcon.snp_right).offset(8 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        };
        
        //点赞
        addSubview(_likeIcon);
        _likeIcon.snp.makeConstraints { (make) in
            make.left.equalTo(253 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 11 * iPHONE_AUTORATIO, height: 11 * iPHONE_AUTORATIO));
        };
        
        addSubview(_likeLabel);
        _likeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self._likeIcon.snp_right).offset(5 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        addSubview(_deleteButton)
        _deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(50 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 80 * iPHONE_AUTORATIO, height: 40 * iPHONE_AUTORATIO))
        }
        
        _deleteButton.addTarget(self,
                         action: #selector(deleteButtonTapped(_:)),
                         for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        block()
    }

}

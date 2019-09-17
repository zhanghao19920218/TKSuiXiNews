//
//  HomeNewsBottomTimeView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 下方显示时间, 观看次数, 点赞次数的bottom
 */
fileprivate let textStyle = kFont(13 * iPHONE_AUTORATIO);
fileprivate let fontColor = RGBA(153, 153, 153, 1);

class SXHomeNewsBottomTimeView: UIView {
    var time:String? {
        willSet(newValue) {
            _timeLabel.text = newValue ?? "0小时前";
        }
    }
    
    var review: Int? {
        willSet(newValue) {
            _reviewLabel.text = "\(newValue ?? 0)";
        }
    }
    
    var like: Int? {
        willSet(newValue) {
            _likeLabel.text = "\(newValue ?? 0)";
        }
    }
    
    var isLike: Int? {
        willSet(value) {
            if let bool = value {
                _likeIcon.image = K_ImageName(bool == 1 ? "like_list_icon" : "dislike_list_icon");
            }
        }
    }
    
    //几小时前
    private lazy var _timeLabel: UILabel = {
        let label = UILabel();
        label.font = textStyle
        label.textColor = fontColor
        return label;
    }();
    
    //查看次数
    private lazy var _timeIcon: UIImageView = {
        let imageView = UIImageView();
        imageView.image = K_ImageName("view_list_icon");
        return imageView;
    }();
    
    private lazy var _reviewLabel: UILabel = {
        let label = UILabel();
        label.font = textStyle
        label.textColor = fontColor
        return label;
    }();
    
    //点赞数量
    private lazy var _likeIcon: UIImageView = {
        let imageView = UIImageView();
        imageView.image = K_ImageName("dislike_list_icon");
        return imageView;
    }()
    
    private lazy var _likeLabel: UILabel = {
        let label = UILabel();
        label.font = textStyle
        label.textColor = fontColor
        return label;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _setupUI() {
        addSubview(_timeLabel);
        _timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        addSubview(_likeLabel);
        _likeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        addSubview(_likeIcon);
        _likeIcon.snp.makeConstraints { (make) in
            make.right.equalTo(-47 * iPHONE_AUTORATIO);
            make.size.equalTo(CGSize(width: 11 * iPHONE_AUTORATIO, height: 11 * iPHONE_AUTORATIO))
            make.centerY.equalToSuperview();
        }
        
        addSubview(_reviewLabel);
        _reviewLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-83 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        addSubview(_timeIcon)
        _timeIcon.snp.makeConstraints { (make) in
            make.right.equalTo(-120 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 15 * iPHONE_AUTORATIO, height: 10 * iPHONE_AUTORATIO))
        }
    }
}

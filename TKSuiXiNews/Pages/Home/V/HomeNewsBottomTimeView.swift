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

class HomeNewsBottomTimeView: UIView {
    var time:String? {
        willSet(newValue) {
            timeLabel.text = newValue ?? "0小时前";
        }
    }
    
    var review: Int? {
        willSet(newValue) {
            reviewLabel.text = "\(newValue ?? 0)";
        }
    }
    
    var like: Int? {
        willSet(newValue) {
            likeLabel.text = "\(newValue ?? 0)";
        }
    }
    
    var isLike: Int? {
        willSet(value) {
            if let bool = value {
                likeIcon.image = K_ImageName(bool == 1 ? "like_list_icon" : "dislike_list_icon");
            }
        }
    }
    
    //几小时前
    private lazy var timeLabel: UILabel = {
        let label = UILabel();
        label.font = textStyle
        label.textColor = fontColor
        return label;
    }();
    
    //查看次数
    private lazy var timeIcon: UIImageView = {
        let imageView = UIImageView();
        imageView.image = K_ImageName("view_list_icon");
        return imageView;
    }();
    
    private lazy var reviewLabel: UILabel = {
        let label = UILabel();
        label.font = textStyle
        label.textColor = fontColor
        return label;
    }();
    
    //点赞数量
    private lazy var likeIcon: UIImageView = {
        let imageView = UIImageView();
        imageView.image = K_ImageName("dislike_list_icon");
        return imageView;
    }()
    
    private lazy var likeLabel: UILabel = {
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
        addSubview(timeLabel);
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        addSubview(likeLabel);
        likeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        addSubview(likeIcon);
        likeIcon.snp.makeConstraints { (make) in
            make.right.equalTo(-47 * iPHONE_AUTORATIO);
            make.size.equalTo(CGSize(width: 11 * iPHONE_AUTORATIO, height: 11 * iPHONE_AUTORATIO))
            make.centerY.equalToSuperview();
        }
        
        addSubview(reviewLabel);
        reviewLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-83 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        addSubview(timeIcon)
        timeIcon.snp.makeConstraints { (make) in
            make.right.equalTo(-120 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 15 * iPHONE_AUTORATIO, height: 10 * iPHONE_AUTORATIO))
        }
    }
}

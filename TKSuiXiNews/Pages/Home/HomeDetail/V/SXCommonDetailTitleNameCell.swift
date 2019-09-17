//
//  CommonDetailTitleNameCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/2.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 发布标题和发布的时间
 */
fileprivate let fontSize = kFont(13 * iPHONE_AUTORATIO)
fileprivate let fontColor = RGBA(153, 153, 153, 1)

class SXCommonDetailTitleNameCell: BaseTableViewCell {
    var title:String? {
        willSet(newValue) {
            _titleLabel.text = newValue ?? ""
        }
    }
    
    var writer:String? {
        willSet(newValue) {
            _writeLabel.text = newValue ?? ""
        }
    }
    
    var time:String? {
        willSet(newValue) {
            _timeLabel.text = newValue ?? "0小时前"
        }
    }
    
    var review:Int? {
        willSet(newValue) {
            _reviewLabel.text = "\(newValue ?? 0)"
        }
    }

    //标题
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }()

    //发布者姓名
    private lazy var _writeLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        return label
    }()
    
    //发布者时间
    private lazy var _timeLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        label.text = "0小时前"
        return label
    }()
    
    private lazy var _reviewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("review_img")
        return imageView
    }()
    
    //浏览量
    private lazy var _reviewLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        label.text = "0"
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(25 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_writeLabel)
        _writeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(93 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_timeLabel)
        _timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-89 * iPHONE_AUTORATIO)
            make.centerY.equalTo(_writeLabel.snp_centerY)
        }
        
        contentView.addSubview(_reviewLabel)
        _reviewLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.centerY.equalTo(_writeLabel.snp_centerY)
        }
        
        contentView.addSubview(_reviewIcon)
        _reviewIcon.snp.makeConstraints { (make) in
            make.right.equalTo(_reviewLabel.snp_left).offset(-8 * iPHONE_AUTORATIO)
            make.centerY.equalTo(_writeLabel.snp_centerY)
            make.size.equalTo(CGSize(width: 15 * iPHONE_AUTORATIO, height: 10 * iPHONE_AUTORATIO))
        }
    }
}

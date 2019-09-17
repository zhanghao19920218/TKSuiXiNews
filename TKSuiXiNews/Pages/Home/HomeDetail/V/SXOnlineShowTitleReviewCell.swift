//
//  OnlineShowTitleReviewCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit


///显示新闻标题和浏览量

class SXOnlineShowTitleReviewCell: BaseTableViewCell {
    
    ///视频标题
    var title: String? {
        willSet(newValue) {
            _titleLabel.text = newValue ?? ""
        }
    }
    
    ///视频的浏览量
    var reviewNum: Int? {
        willSet(newValue) {
            _reviewNumLabel.text = "\(newValue ?? 0)"
        }
    }
    
    ///新闻标题
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        return label
    }()
    
    ///浏览的Icon
    private lazy var _reviewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("view_list_icon")
        return imageView
    }()
    
    ///浏览的次数
    private lazy var _reviewNumLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        label.text = "0"
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-80 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(_reviewNumLabel)
        _reviewNumLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(_reviewIcon)
        _reviewIcon.snp.makeConstraints { (make) in
            make.right.equalTo(_reviewNumLabel.snp_left).offset(-8 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 15 * iPHONE_AUTORATIO, height: 10 * iPHONE_AUTORATIO))
        }
        
    }

}

//
//  BoardCastVideoNewsCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class BoardCastVideoNewsCell: BaseTableViewCell {
    var title:String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? ""
        }
    }
    
    var isTv:Bool = false {
        willSet(newValue) {
            if !newValue {
                reviewIcon.image = K_ImageName("review_img")
            } else {
                reviewIcon.image = K_ImageName("audio_list_icon")
            }
        }
    }
    
    var review: Int? {
        willSet(newValue) {
            reviewNumLabel.text = "\(newValue ?? 0)"
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        return label
    }()

    private lazy var reviewIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var reviewNumLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        label.text = "0"
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(reviewNumLabel)
        reviewNumLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(reviewIcon)
        reviewIcon.snp.makeConstraints { (make) in
            make.right.equalTo(reviewNumLabel.snp_left).offset(-8 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 15 * iPHONE_AUTORATIO, height: 10 * iPHONE_AUTORATIO))
        }
    }
}

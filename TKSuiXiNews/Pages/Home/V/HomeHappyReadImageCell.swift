//
//  HomeHappyReadImageCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 悦读的cell
 */

class HomeHappyReadImageCell: UICollectionViewCell {
    var title:String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? ""
        }
    }
    
    var time:String? {
        willSet(newValue) {
            timeLabel.text = newValue ?? "0小时前"
        }
    }
    
    var reviewNum:Int? {
        willSet(newValue) {
            reviewNumL.text = "\(newValue ?? 0)"
        }
    }
    
    var imagename:String? {
        willSet(newValue) {
            if let value = newValue {
                imageView.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        label.text = "0小时前"
        return label
    }()
    
    private lazy var reviewIcon: UIImageView = {
       let imageView = UIImageView()
        imageView.image = K_ImageName("view_list_icon")
        return imageView
    }()
    
    private lazy var reviewNumL: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        label.text = "0"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _setupUI() {
        backgroundColor = .white
        
        imageView.frame = CGRect(x: 0, y: 0, width: 165 * iPHONE_AUTORATIO, height: 120 * iPHONE_AUTORATIO)
        contentView.addSubview(imageView)
        
        titleLabel.frame = CGRect(x: 11 * iPHONE_AUTORATIO, y: 130 * iPHONE_AUTORATIO, width: 140 * iPHONE_AUTORATIO, height: 40 * iPHONE_AUTORATIO)
        contentView.addSubview(titleLabel)
        
        timeLabel.frame = CGRect(x: 11 * iPHONE_AUTORATIO, y: 178 * iPHONE_AUTORATIO, width: 60 * iPHONE_AUTORATIO, height: 15 * iPHONE_AUTORATIO)
        contentView.addSubview(timeLabel)
        
        reviewIcon.frame = CGRect(x: 104 * iPHONE_AUTORATIO, y: 180 * iPHONE_AUTORATIO, width: 15 * iPHONE_AUTORATIO, height: 10 * iPHONE_AUTORATIO)
        contentView.addSubview(reviewIcon)
        
        reviewNumL.frame = CGRect(x: 126 * iPHONE_AUTORATIO, y: 178 * iPHONE_AUTORATIO, width: 40 * iPHONE_AUTORATIO, height: 15 * iPHONE_AUTORATIO)
        contentView.addSubview(reviewNumL)
    }
}

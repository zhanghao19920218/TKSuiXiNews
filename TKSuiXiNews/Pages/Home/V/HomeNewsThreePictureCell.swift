//
//  HomeNewsThreePictureCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class HomeNewsThreePictureCell: BaseTableViewCell {
    
    var isHiddenTop: Bool? {
        willSet(newValue) {
            if let value = newValue, !value {
                isTopLabelView.isHidden = false
                titleL.text = ("         " + (titleL.text ?? ""))
            } else {
                isTopLabelView.isHidden = true
            }
        }
    }

    var title:String? {
        willSet(newValue) {
            titleL.text = newValue ?? "";
        }
    }
    
    var imageName: String? {
        willSet(newValue) {
            if let value = newValue {
                imageIcon.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    var imageName2: String? {
        willSet(newValue) {
            if let value = newValue {
                imageIcon2.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    var imageName3: String? {
        willSet(newValue) {
            if let value = newValue {
                imageIcon3.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    var time:String? {
        willSet(newValue) {
            bottomView.time = newValue
        }
    }
    
    var review: Int? {
        willSet(newValue) {
            bottomView.review = newValue
        }
    }
    
    var like: Int? {
        willSet(newValue) {
            bottomView.like = newValue
        }
    }
    
    var isLike: Int? {
        willSet(value) {
            bottomView.isLike = value
        }
    }
    
    //标题信息
    private lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }();
    
    //照片信息
    private lazy var imageIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var imageIcon2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var imageIcon3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    //设置下方的评论列表
    private lazy var bottomView: HomeNewsBottomTimeView = {
        let view = HomeNewsBottomTimeView()
        return view
    }()
    
    //置顶
    private lazy var isTopLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(255, 74, 92, 1)
        view.layer.cornerRadius = 3 * iPHONE_AUTORATIO
        view.isHidden = true
        return view
    }()
    
    //置顶的Label
    private lazy var isTopLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(10 * iPHONE_AUTORATIO)
        label.textColor = .white
        label.text = "置顶"
        label.textAlignment = .center
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(titleL);
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(imageIcon)
        imageIcon.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(68 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 114 * iPHONE_AUTORATIO, height: 82 * iPHONE_AUTORATIO))
        }
        
        contentView.addSubview(imageIcon2)
        imageIcon2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(68 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 114 * iPHONE_AUTORATIO, height: 82 * iPHONE_AUTORATIO))
        }
        
        
        contentView.addSubview(imageIcon3)
        imageIcon3.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(68 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 114 * iPHONE_AUTORATIO, height: 82 * iPHONE_AUTORATIO))
        }
        
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(38 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(isTopLabelView)
        isTopLabelView.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(23 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 27 * iPHONE_AUTORATIO, height: 17 * iPHONE_AUTORATIO))
        }
        
        isTopLabelView.addSubview(isTopLabel)
        isTopLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

}

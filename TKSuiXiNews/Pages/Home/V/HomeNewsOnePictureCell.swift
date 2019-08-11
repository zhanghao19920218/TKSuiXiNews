//
//  HomeNewsOnePictureCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class HomeNewsOnePictureCell: BaseTableViewCell {
    
    var isHiddenTop: Bool? {
        willSet(newValue) {
            if let value = newValue, !value {
                isTopLabelView.isHidden = false
                titleL.text = ("         " + (titleL.text ?? ""))
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
    
    //设置下方的评论列表
    private lazy var bottomView: HomeNewsBottomTimeView = {
        let view = HomeNewsBottomTimeView()
        return view
    }()
    
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(titleL);
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(21 * iPHONE_AUTORATIO)
            make.right.equalTo(-153 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(imageIcon)
        imageIcon.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 114 * iPHONE_AUTORATIO, height: 82 * iPHONE_AUTORATIO))
        }
        
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.right.equalTo(-137 * iPHONE_AUTORATIO)
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

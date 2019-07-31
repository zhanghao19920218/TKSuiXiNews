//
//  HomeAskGovOnePicCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

//仅有一张图片的问政

class HomeAskGovOnePicCell: BaseTableViewCell {
    var title: String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? ""
        }
    }
    
    var imageName: String?{
        willSet(newValue) {
            if let value = newValue {
                photoImage.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    var time: String? {
        willSet(newValue) {
            bottomView.time = newValue
        }
    }
    
    var comment: Int? {
        willSet(newValue) {
            bottomView.comment = newValue
        }
    }
    
    //标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var photoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var bottomView: HomeAskGovBaseBottom = {
        let view = HomeAskGovBaseBottom()
        return view
    }()

    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(16 * iPHONE_AUTORATIO)
            make.right.equalTo(-153 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(photoImage)
        photoImage.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 114 * iPHONE_AUTORATIO, height: 82 * iPHONE_AUTORATIO))
        }
        
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.right.equalTo(-137 * iPHONE_AUTORATIO)
            make.height.equalTo(40 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

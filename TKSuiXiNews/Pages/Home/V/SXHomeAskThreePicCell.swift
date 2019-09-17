//
//  HomeAskThreePicCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class SXHomeAskThreePicCell: BaseTableViewCell {

    var title: String? {
        willSet(newValue) {
            _titleLabel.text = newValue ?? ""
        }
    }
    
    var imageName: String? {
        willSet(newValue) {
            if let value = newValue {
                _imageIcon.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    var imageName2: String? {
        willSet(newValue) {
            if let value = newValue {
                _imageIcon2.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    var imageName3: String? {
        willSet(newValue) {
            if let value = newValue {
                _imageIcon3.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    var time: String? {
        willSet(newValue) {
            _bottomView.time = newValue
        }
    }
    
    var comment: Int? {
        willSet(newValue) {
            _bottomView.comment = newValue
        }
    }
    
    //标题
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var _bottomView: SXHomeAskGovBaseBottom = {
        let view = SXHomeAskGovBaseBottom()
        return view
    }()
    
    //照片信息
    private lazy var _imageIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    private lazy var _imageIcon2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    private lazy var _imageIcon3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(16 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_imageIcon)
        _imageIcon.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(68 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 114 * iPHONE_AUTORATIO, height: 82 * iPHONE_AUTORATIO))
        }
        
        contentView.addSubview(_imageIcon2)
        _imageIcon2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(68 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 114 * iPHONE_AUTORATIO, height: 82 * iPHONE_AUTORATIO))
        }
        
        
        contentView.addSubview(_imageIcon3)
        _imageIcon3.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(68 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 114 * iPHONE_AUTORATIO, height: 82 * iPHONE_AUTORATIO))
        }
        
        contentView.addSubview(_bottomView)
        _bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
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

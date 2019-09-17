//
//  HomeNewsThreePictureCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class SXHomeNewsThreePictureCell: BaseTableViewCell {
    
    var isHiddenTop: Bool? {
        willSet(newValue) {
            if let value = newValue, !value {
                _isTopLabelView.isHidden = false
                _titleL.text = ("         " + (_titleL.text ?? ""))
            } else {
                _isTopLabelView.isHidden = true
            }
        }
    }

    var title:String? {
        willSet(newValue) {
            _titleL.text = newValue ?? "";
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
    
    var time:String? {
        willSet(newValue) {
            _bottomView.time = newValue
        }
    }
    
    var review: Int? {
        willSet(newValue) {
            _bottomView.review = newValue
        }
    }
    
    var like: Int? {
        willSet(newValue) {
            _bottomView.like = newValue
        }
    }
    
    var isLike: Int? {
        willSet(value) {
            _bottomView.isLike = value
        }
    }
    
    //标题信息
    private lazy var _titleL: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }();
    
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
    
    //设置下方的评论列表
    private lazy var _bottomView: SXHomeNewsBottomTimeView = {
        let view = SXHomeNewsBottomTimeView()
        return view
    }()
    
    //置顶
    private lazy var _isTopLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(255, 74, 92, 1)
        view.layer.cornerRadius = 3 * iPHONE_AUTORATIO
        view.isHidden = true
        return view
    }()
    
    //置顶的Label
    private lazy var _isTopLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(10 * iPHONE_AUTORATIO)
        label.textColor = .white
        label.text = "置顶"
        label.textAlignment = .center
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_titleL);
        _titleL.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(15 * iPHONE_AUTORATIO)
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
            make.height.equalTo(38 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.height.equalTo(1)
        }
        
        contentView.addSubview(_isTopLabelView)
        _isTopLabelView.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(15 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 27 * iPHONE_AUTORATIO, height: 17 * iPHONE_AUTORATIO))
        }
        
        _isTopLabelView.addSubview(_isTopLabel)
        _isTopLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

}

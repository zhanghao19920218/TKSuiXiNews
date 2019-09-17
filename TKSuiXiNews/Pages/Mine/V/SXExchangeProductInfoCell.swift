//
//  ExchangeProductInfoCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///兑换记录的Cell
class SXExchangeProductInfoCell: BaseTableViewCell {
    var imageName:String? {
        willSet(newValue) {
            if let value = newValue {
                _productImageView.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }

    var productTitle:String? {
        willSet(newValue) {
            _productTitleLabel.text = newValue ?? ""
        }
    }
    
    var score: Int? {
        willSet(newValue) {
            _productTotalCountLabel.text = "消耗: \(newValue ?? 0)分"
        }
    }
    
    var isHiddenPick: String? {
        willSet(newValue) {
            if let value = newValue {
                if value != "hidden" {
                    _readyToTakeLabelView.backgroundColor = RGBA(204, 204, 204, 1)
                    _readyLabel.text = "已领取"
                } else {
                    _readyToTakeLabelView.backgroundColor = RGBA(255, 74, 92, 1)
                    _readyLabel.text = "待领取"
                }
            }
        }
    }
    
    private lazy var _productImageBackView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(245, 245, 245, 1)
        return view
    }()
    
    //背景
    private lazy var _contentBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var _productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = RGBA(245, 245, 245, 1)
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.contentMode = ContentMode.scaleAspectFit
        return imageView
    }()
    
    private lazy var _productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var _productTotalCountLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        label.text = "消耗: 0分"
        return label
    }()
    
    private lazy var _readyToTakeLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(255, 74, 92, 1)
        return view
    }()
    
    private lazy var _readyLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(12 * iPHONE_AUTORATIO)
        label.textColor = .white
        label.text = "待领取"
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.backgroundColor = RGBA(245, 245, 245, 1)
        
        contentView.addSubview(_contentBackView)
        _contentBackView.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.top.equalTo(10 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-10 * iPHONE_AUTORATIO)
        }
        
        _contentBackView.addSubview(_productImageBackView)
        _productImageBackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 70 * iPHONE_AUTORATIO, height: 70 * iPHONE_AUTORATIO))
        }
        
        _productImageBackView.addSubview(_productImageView)
        _productImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 50 * iPHONE_AUTORATIO, height: 50 * iPHONE_AUTORATIO) )
        }
        
        _contentBackView.addSubview(_productTitleLabel)
        _productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(96 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.top.equalTo(15 * iPHONE_AUTORATIO)
        }
        
        _contentBackView.addSubview(_productTotalCountLabel)
        _productTotalCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(96 * iPHONE_AUTORATIO)
            make.top.equalTo(68 * iPHONE_AUTORATIO)
        }
        
        _readyToTakeLabelView.frame = CGRect(x: 284 * iPHONE_AUTORATIO, y: 61 * iPHONE_AUTORATIO, width: 61 * iPHONE_AUTORATIO, height: 24 * iPHONE_AUTORATIO)
        _contentBackView.addSubview(_readyToTakeLabelView)
        _readyToTakeLabelView.corner(byRoundingCorners: [.bottomLeft, .topLeft], radii: 12 * iPHONE_AUTORATIO)
        
        _readyToTakeLabelView.addSubview(_readyLabel)
        _readyLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

}

//
//  ExchangeProductInfoCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 兑换记录的Cell
 */

class ExchangeProductInfoCell: BaseTableViewCell {
    var imageName:String? {
        willSet(newValue) {
            if let value = newValue {
                productImageView.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }

    var productTitle:String? {
        willSet(newValue) {
            productTitleLabel.text = newValue ?? ""
        }
    }
    
    var score: Int? {
        willSet(newValue) {
            productTotalCountLabel.text = "消耗: \(newValue ?? 0)分"
        }
    }
    
    var isHiddenPick: String? {
        willSet(newValue) {
            if let value = newValue {
                if value != "hidden" {
                    readyToTakeLabelView.backgroundColor = RGBA(204, 204, 204, 1)
                    readyLabel.text = "已领取"
                } else {
                    readyToTakeLabelView.backgroundColor = RGBA(255, 74, 92, 1)
                    readyLabel.text = "待领取"
                }
            }
        }
    }
    
    private lazy var productImageBackView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(245, 245, 245, 1)
        return view
    }()
    
    //背景
    private lazy var contentBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = RGBA(245, 245, 245, 1)
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.contentMode = ContentMode.scaleAspectFit
        return imageView
    }()
    
    private lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var productTotalCountLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        label.text = "消耗: 0分"
        return label
    }()
    
    private lazy var readyToTakeLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(255, 74, 92, 1)
        return view
    }()
    
    private lazy var readyLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(12 * iPHONE_AUTORATIO)
        label.textColor = .white
        label.text = "待领取"
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.backgroundColor = RGBA(245, 245, 245, 1)
        
        contentView.addSubview(contentBackView)
        contentBackView.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.top.equalTo(10 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-10 * iPHONE_AUTORATIO)
        }
        
        contentBackView.addSubview(productImageBackView)
        productImageBackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 70 * iPHONE_AUTORATIO, height: 70 * iPHONE_AUTORATIO))
        }
        
        productImageBackView.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 50 * iPHONE_AUTORATIO, height: 50 * iPHONE_AUTORATIO) )
        }
        
        contentBackView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(96 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.top.equalTo(15 * iPHONE_AUTORATIO)
        }
        
        contentBackView.addSubview(productTotalCountLabel)
        productTotalCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(96 * iPHONE_AUTORATIO)
            make.top.equalTo(68 * iPHONE_AUTORATIO)
        }
        
        readyToTakeLabelView.frame = CGRect(x: 284 * iPHONE_AUTORATIO, y: 61 * iPHONE_AUTORATIO, width: 61 * iPHONE_AUTORATIO, height: 24 * iPHONE_AUTORATIO)
        contentBackView.addSubview(readyToTakeLabelView)
        readyToTakeLabelView.corner(byRoundingCorners: [.bottomLeft, .topLeft], radii: 12 * iPHONE_AUTORATIO)
//        readyToTakeLabelView.snp.makeConstraints { (make) in
//            make.right.equalToSuperview()
//            make.bottom.equalTo(-10 * iPHONE_AUTORATIO)
//            make.size.equalTo(CGSize(width: 61 * iPHONE_AUTORATIO, height: 24 * iPHONE_AUTORATIO))
//        }
        
        readyToTakeLabelView.addSubview(readyLabel)
        readyLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

}

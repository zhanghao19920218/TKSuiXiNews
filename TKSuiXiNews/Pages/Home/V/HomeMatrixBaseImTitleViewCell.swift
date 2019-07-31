//
//  HomeMatrixBaseImTitleView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 矩阵的基础的view
 */

class HomeMatrixBaseImTitleViewCell: BaseTableViewCell {
    var title:String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? "";
        }
    }
    
    //矩阵图片
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    //矩阵标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = kFont(12 * iPHONE_AUTORATIO)
        return label
    }()
    
    //初始化页面
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(25 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 50 * iPHONE_AUTORATIO, height: 50 * iPHONE_AUTORATIO))
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp_bottom).offset(13 * iPHONE_AUTORATIO)
            make.centerX.equalToSuperview()
        }
    }
}

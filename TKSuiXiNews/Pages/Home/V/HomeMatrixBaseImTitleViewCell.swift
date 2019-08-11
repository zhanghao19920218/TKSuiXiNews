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
    //是不是被选中
    var isChoose:Bool = false {
        willSet(newValue) {
            if newValue {
                backView.backgroundColor = RGBA(255, 74, 92, 0.1)
            } else {
                backView.backgroundColor = .white
            }
        }
    }
    
    var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10 * iPHONE_AUTORATIO
        return view
    }()
    
    var title:String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? "";
        }
    }
    
    var imagename:String? {
        willSet(newValue) {
            iconView.kf.setImage(with: URL(string: newValue ?? ""), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
        }
    }
    
    //矩阵图片
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
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
        contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(15 * iPHONE_AUTORATIO)
            make.left.right.bottom.equalToSuperview()
        }
        
        backView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 50 * iPHONE_AUTORATIO, height: 50 * iPHONE_AUTORATIO))
        }
        
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp_bottom).offset(13 * iPHONE_AUTORATIO)
            make.centerX.equalToSuperview()
        }
    }
}

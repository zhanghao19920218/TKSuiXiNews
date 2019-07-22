//
//  ServiceSingleNameCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 濉溪发布的服务页面Cell
 */

class ServiceSingleNameCell: UICollectionViewCell {
    var imageName: String? {
        willSet(value) {
            iconImage.image = K_ImageName(value ?? "")
        }
    }
    
    var title: String? {
        willSet(value) {
            titleLabel.text = value ?? ""
        }
    }
    
    var subTitle: String? {
        willSet(value) {
            subTitleLabel.text = value ?? ""
        }
    }
    
    
    //MARK: - 背景
    private lazy var collectionBackView: UIView = {
        let view = UIView();
        view.backgroundColor = RGBA(245, 245, 245, 1);
        view.layer.cornerRadius = 10 * iPHONE_AUTORATIO;
        return view;
    }();
    
    //图标
    private lazy var iconImage: UIImageView = {
        let imageView = UIImageView();
        return imageView;
    }()
    
    //标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(13 * iPHONE_AUTORATIO);
        label.textColor = RGBA(51, 51, 51, 1);
        return label;
    }();
    
    //副标题
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel();
        label.textColor = RGBA(153, 153, 153, 1);
        label.font = kFont(11 * iPHONE_AUTORATIO);
        return label;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionBackView);
        collectionBackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview();
            make.size.equalTo(CGSize(width: 165 * iPHONE_AUTORATIO, height: 75 * iPHONE_AUTORATIO))
        }
        
        collectionBackView.addSubview(iconImage);
        iconImage.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        collectionBackView.addSubview(titleLabel);
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImage.snp_right).offset(10 * iPHONE_AUTORATIO);
            make.top.equalTo(20 * iPHONE_AUTORATIO);
        }
        
        collectionBackView.addSubview(subTitleLabel);
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(5 * iPHONE_AUTORATIO);
            make.left.equalTo(self.iconImage.snp_right).offset(10 * iPHONE_AUTORATIO)
        }
    }
}

//
//  BaseNaviRightButton.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let fontSize = kFont(10 * iPHONE_AUTORATIO);

class BaseNaviRightButton: UIButton {
    private lazy var imageViews: UIImageView = {
        let imageView = UIImageView();
        return imageView;
    }();
    
    private lazy var titleL: UILabel = {
        let label = UILabel.init();
        label.font = fontSize;
        label.textColor = .white;
        label.textAlignment = .center;
        return label;
    }();
    
    var imageName: String? {
        willSet(val) {
            imageViews.image = K_ImageName(val ?? "");
        }
    }
    
    var title: String? {
        willSet(val) {
            titleL.text = val ?? "";
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化背景
    private func setupUI() {
        addSubview(imageViews);
        imageViews.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview();
            make.size.equalTo(CGSize(width: 20 * iPHONE_AUTORATIO, height: 16 * iPHONE_AUTORATIO));
        };
        
        addSubview(titleL);
        titleL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(self.imageViews.snp_bottom).offset(2 * iPHONE_AUTORATIO);
        };
    }
    
}

//
//  ServiceCollectionHeader.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/// 服务的列表sectionHeader
class SXServiceCollectionHeader: UICollectionReusableView {
    //设置图片
    var imageName: String? {
        willSet(value) {
            _imageView.image = K_ImageName(value ?? "")
        }
    }

    ///显示相册
    private lazy var _imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化页面
    private func setupUI() {
        addSubview(_imageView);
        _imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview();
            make.left.equalTo(10 * iPHONE_AUTORATIO);
            make.right.equalTo(-15 * iPHONE_AUTORATIO);
        }
    }

}

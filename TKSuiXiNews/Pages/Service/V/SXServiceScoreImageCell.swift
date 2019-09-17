//
//  ServiceScoreImageCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///服务界面分数的Cell
class SXServiceScoreImageCell: UICollectionViewCell {
    //设置图片
    var imageName: String? {
        willSet(value) {
            _imageView.image = K_ImageName(value ?? "")
        }
    }
    
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
            make.edges.equalToSuperview()
        }
    }
}

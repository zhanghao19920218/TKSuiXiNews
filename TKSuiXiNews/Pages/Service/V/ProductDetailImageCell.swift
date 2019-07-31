//
//  ProductDetailImageCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class ProductDetailImageCell: BaseTableViewCell {
    var imageName:String? {
        willSet(newValue) {
            if let value = newValue {
                _imageView.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }

    private lazy var _imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        return imageView
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_imageView)
        _imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

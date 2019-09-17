//
//  ErrorLoadCollectionCell.swift
//  TKSuiXiNews
//
//  Created by Mason on 2019/9/17.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class ErrorLoadCollectionCell: UICollectionViewCell {
    ///标题
    var title:String? {
        willSet(newValue) {
            _titleLabel.text = newValue ?? ""
        }
    }
    
    ///照片图片
    var imagename: String? {
        willSet(newValue) {
            if let value = newValue {
                _imageView.image = K_ImageName(value)
            }
        }
    }
    
    ///是不是被选中
    var isSelecteds: Bool? {
        willSet(newValue) {
            if let value = newValue, value {
                contentView.backgroundColor = RGBA(178, 178, 178, 1)
            } else {
                contentView.backgroundColor = RGBA(245, 245, 245, 1)
            }
        }
    }
    
    ///显示照片
    private lazy var _imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    ///显示标题
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///初始化界面
    private func setupUI() {
        contentView.addSubview(_imageView)
        _imageView.snp.makeConstraints { (make) in
            make.top.equalTo(10 * iPHONE_AUTORATIO)
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.height.equalTo(65 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(_imageView.snp_bottom).offset(10 * iPHONE_AUTORATIO)
            make.centerX.equalToSuperview()
        }
    }
}

//
//  HomeTVChannelNameView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class HomeTVChannelNameView: UIView {
    //设置新闻标题
    var title:String? {
        willSet(newValue) {
            _titleLabel.text = newValue ?? "";
        }
    }
    
    //设置照片
    var imageName:String? {
        willSet(newValue) {
            if let value = newValue {
                _imageView.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE));
            }
        }
    }
    
    //新闻图片
    private lazy var _imageView: UIImageView = {
        let imageView = UIImageView();
        imageView.image = K_ImageName("icon_logo_second");
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 20 * iPHONE_AUTORATIO;
        
        return imageView;
    }();
    
    //频道名称
    private lazy var _titleLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(13 * iPHONE_AUTORATIO);
        label.textAlignment = .center;
        return label;
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
        backgroundColor = RGBA(245, 245, 245, 1);
        
        layer.cornerRadius = 10 * iPHONE_AUTORATIO;
        
        //页面的图片
        addSubview(_imageView);
        _imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(18 * iPHONE_AUTORATIO);
            make.size.equalTo(CGSize(width: 40 * iPHONE_AUTORATIO, height: 40 * iPHONE_AUTORATIO));
        };
        
        //页面标题
        addSubview(_titleLabel);
        _titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(self._imageView.snp_bottom).offset(12 * iPHONE_AUTORATIO);
        }
    }
}

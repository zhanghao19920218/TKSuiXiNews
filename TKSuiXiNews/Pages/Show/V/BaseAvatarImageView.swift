//
//  BaseAvatarImageView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/21.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/// 基类的头像
class BaseAvatarImageView: UIImageView {
    //获取图片地址
    var imageName:String? {
        willSet(value) {
            if let imagename = value {
                kf.setImage(with: URL(string: imagename), placeholder: K_ImageName(PLACE_HOLDER_IMAGE));
            }
        }
    }

    //头像
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化
    private func setupUI(){
        layer.cornerRadius = 5 * iPHONE_AUTORATIO;
        layer.masksToBounds = true;
        image = K_ImageName(PLACE_HOLDER_IMAGE);
    }

}

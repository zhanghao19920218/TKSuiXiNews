//
//  ShareDetailButton.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/10.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class ShareDetailButton: UIButton {
    var imageName:String? {
        willSet(newValue) {
            if let value = newValue {
                imageViews.image = K_ImageName(value)
            }
        }
    }
    
    var title:String? {
        willSet(newValue) {
            iconTitleLabel.text = newValue ?? ""
        }
    }

    private lazy var imageViews: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var iconTitleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(10 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(imageViews)
        imageViews.snp.makeConstraints { (make) in
            make.top.equalTo(15 * iPHONE_AUTORATIO)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 50 * iPHONE_AUTORATIO, height: 50 * iPHONE_AUTORATIO))
        }
        
        addSubview(iconTitleLabel)
        iconTitleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(imageViews.snp_bottom).offset(10 * iPHONE_AUTORATIO)
            make.centerX.equalToSuperview()
        })
    }
    
    
}

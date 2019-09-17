//
//  ExchangeNewPersonCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///新人大礼包
class SXExchangeNewPersonCell: BaseTableViewCell {
    ///点击
    var block: () -> Void = {}
    
    ///标题
    var title: String? {
        willSet(newValue) {
            _button.setTitle(newValue ?? "")
        }
    }

    ///用户大礼包的背景
    private lazy var _personGiftBackView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("new_user_exchange_icon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    ///到达现场的button
    private lazy var _button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("我已现场领取")
        button.setTitleColor(.white)
        button.backgroundColor = RGBA(253, 138, 81, 1)
        button.titleLabel?.font = kFont(11 * iPHONE_AUTORATIO)
        button.layer.cornerRadius = 3
        button.addTarget(self,
                         action: #selector(personExchangeButton(_:)),
                         for: .touchUpInside)
        return  button
    }()

    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_personGiftBackView)
        _personGiftBackView.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.top.equalTo(15 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-15 * iPHONE_AUTORATIO)
        }
        
        _personGiftBackView.addSubview(_button)
        _button.snp.makeConstraints { (make) in
            make.left.equalTo(28 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-14 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 122 * iPHONE_AUTORATIO, height: 25 * iPHONE_AUTORATIO))
        }
    }
    
    @objc private func personExchangeButton(_ sender: UIButton) {
        block()
    }
}

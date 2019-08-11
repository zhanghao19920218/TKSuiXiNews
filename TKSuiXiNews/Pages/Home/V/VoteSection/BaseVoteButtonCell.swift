//
//  BaseVoteButtonCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class BaseVoteButtonCell: BaseTableViewCell {
    var title:String? {
        willSet(newValue) {
            button.title = newValue ?? ""
        }
    }
    
    var progress: Float = 0.0 {
        willSet(newValue) {
            button.progress = newValue
        }
    }
    
    var person: Int = 0 {
        willSet(newValue) {
            button.person = newValue
        }
    }
    
    var isCustomerIsSelected: Bool = false {
        willSet(newValue) {
            button.isCustomerIsSelected = newValue
        }
    }
    
    //是不是点击的属性
    var isCustomerShow:Bool = false {
        willSet(newValue) {
            button.isCustomerShow = newValue
        }
    }

    private lazy var button: BaseVoteButton = {
        let button = BaseVoteButton(type: .custom)
        button.isUserInteractionEnabled = false
        return button
    }()

    override func setupUI() {
        super.setupUI()
        
        contentView.backgroundColor = RGBA(245, 245, 245, 1)
        
        contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.height.equalTo(34 * iPHONE_AUTORATIO)
        }
    }
}

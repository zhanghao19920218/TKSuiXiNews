//
//  AskGovermentDetailNormalCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/10.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class AskGovermentDetailNormalCell: BaseTableViewCell {
    var title:String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? ""
        }
    }
    
    var placeholder:String? {
        willSet(newValue) {
            textField.placeholder = newValue ?? ""
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(14 * iPHONE_AUTORATIO)
        return label
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = kFont(14 * iPHONE_AUTORATIO)
        textField.textAlignment = .right
        return textField
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(17 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
            make.left.equalTo(80 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

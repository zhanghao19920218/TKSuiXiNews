//
//  DetailUserInfoNameCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 显示name里面参数的
 */

class SXDetailUserInfoNameCell: BaseTableViewCell {
    var name: String? {
        willSet(value) {
            _label.text = value ?? ""
        }
    }

    //里面的Label
    private lazy var _label: UILabel = {
        let label = UILabel();
        label.font = kFont(14 * iPHONE_AUTORATIO);
        label.numberOfLines = 0;
        return label;
    }();

    
    override func setupUI() {
        super.setupUI();
        
        addSubview(_label);
        _label.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO);
            make.right.equalTo(-13 * iPHONE_AUTORATIO);
            make.top.equalTo(10 * iPHONE_AUTORATIO);
        }
    }
}

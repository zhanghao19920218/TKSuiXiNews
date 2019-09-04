//
//  HYTelevisionProgramCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/9/4.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///节目表单的Cell
class HYTelevisionProgramCell: BaseTableViewCell {
    var isHiddened: Bool? {
        willSet(newValue) {
            if let value = newValue, value {
                _onlineLabel.isHidden = true
                _programLabel.textColor = .black
            } else {
                _onlineLabel.isHidden = false
                _programLabel.textColor = appThemeColor
            }
        }
    }
    
    ///标题
    var title:String? {
        willSet(newValue) {
            _programLabel.text = newValue ?? "'"
        }
    }
    
    ///直播中的Label
    private lazy var _onlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = kFont(10 * iPHONE_AUTORATIO)
        label.backgroundColor = appThemeColor
        label.text = "直播中"
        label.textAlignment = .center
        label.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    ///标题的Label
    private lazy var _programLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.textColor = .black
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_programLabel)
        _programLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14 * iPHONE_AUTORATIO)
            make.right.equalTo(-80 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(_onlineLabel)
        _onlineLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 45 * iPHONE_AUTORATIO, height: 20 * iPHONE_AUTORATIO))
        }
    }
}

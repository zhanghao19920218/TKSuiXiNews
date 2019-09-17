//
//  TelevisonButton.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let normalColor = RGBA(153, 153, 153, 1)
fileprivate let fontSize = kFont(14 * iPHONE_AUTORATIO)
fileprivate let selectedColor = RGBA(255, 74, 92, 1)

class SXTelevisonButton: UIButton {
    var title:String? {
        willSet(newValue) {
            _firstLabel.text = newValue ?? ""
        }
    }
    
    var subTitle:String? {
        willSet(newValue) {
            _secondLabel.text = newValue ?? ""
        }
    }
    
    var isPicked:Bool = false {
        willSet(newValue) {
            if newValue {
                _firstLabel.textColor = selectedColor
                _secondLabel.textColor = selectedColor
            } else {
                _firstLabel.textColor = normalColor
                _secondLabel.textColor = normalColor
            }
        }
    }

    private lazy var _firstLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = normalColor
        return label
    }()
    
    private lazy var _secondLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = normalColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化UI
    private func _setupUI() {
        addSubview(_firstLabel)
        _firstLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(15 * iPHONE_AUTORATIO)
        }
        
        addSubview(_secondLabel)
        _secondLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(_firstLabel.snp_bottom).offset(10 * iPHONE_AUTORATIO)
        }
    }

}

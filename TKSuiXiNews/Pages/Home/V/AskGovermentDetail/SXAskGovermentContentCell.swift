//
//  AskGovermentContentCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/10.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

///问政内容的Cell
class SXAskGovermentContentCell: BaseTableViewCell {

    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.text = "问政内容"
        return label
    }()
    
    lazy var _textView: KMPlaceholderTextView = {
        let textView = KMPlaceholderTextView()
        textView.layer.cornerRadius = 8 * iPHONE_AUTORATIO
        textView.backgroundColor = RGBA(245, 245, 245, 1)
        textView.font = kFont(14 * iPHONE_AUTORATIO)
        textView.placeholder = "请输入50字以内"
        return textView
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(17 * iPHONE_AUTORATIO)
            make.top.equalTo(20 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_textView)
        _textView.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.top.equalTo(53 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-15 * iPHONE_AUTORATIO)
        }
    }

}

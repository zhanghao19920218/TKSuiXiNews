//
//  HomeNewsSearchInfoCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 搜索新闻
 */
class SXHomeNewsSearchInfoCell: BaseTableViewCell {
    var block: () -> Void = { }
    //设置背景
    private lazy var _contentBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        view.backgroundColor = .white
        return view
    }();
    
    //搜索按钮
    private lazy var _searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("news_search_icon");
        return imageView;
    }();
    
    //搜索文本框
    private lazy var _textField: UITextField = {
        let textField = UITextField();
        textField.font = kFont(12 * iPHONE_AUTORATIO)
        textField.placeholder = DefaultsKitUtil.share.placeholder
        textField.clearButtonMode = .always
        textField.delegate = self
        return textField;
    }()

    override func setupUI() {
        super.setupUI();
        
        contentView.backgroundColor = RGBA(245, 245, 245, 1)
        
        contentView.addSubview(_contentBackView)
        _contentBackView.snp.makeConstraints { (make) in
            make.left.top.equalTo(5 * iPHONE_AUTORATIO)
            make.right.bottom.equalTo(-5 * iPHONE_AUTORATIO)
        }
        
        _contentBackView.addSubview(_searchIcon)
        _searchIcon.snp.makeConstraints { (make) in
            make.left.equalTo(8 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 11 * iPHONE_AUTORATIO, height: 11 * iPHONE_AUTORATIO))
        }
        
        _contentBackView.addSubview(_textField)
        _textField.snp.makeConstraints { (make) in
            make.left.equalTo(24 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
            make.right.equalTo(-10 * iPHONE_AUTORATIO)
        }
    }

}

extension SXHomeNewsSearchInfoCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        block()
        return false
    }
}

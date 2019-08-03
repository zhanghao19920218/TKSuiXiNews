//
//  BoardCastTVDatePickCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let normalColor = RGBA(153, 153, 153, 1)
fileprivate let fontSize = kFont(14 * iPHONE_AUTORATIO)
fileprivate let selectedColor = RGBA(255, 74, 92, 1)

class BoardCastTVDatePickCell: BaseTableViewCell {
    var firstDate:String? {
        willSet(newValue) {
            _lastDateButton.subTitle = newValue ?? ""
        }
    }
    
    var secondDate:String? {
        willSet(newValue) {
            _todayButton.subTitle = newValue ?? ""
        }
    }
    
    var thirdDate:String? {
        willSet(newValue) {
            _tomorrowButton.subTitle = newValue ?? ""
        }
    }
    
    var block: (Int) -> Void = { _ in }

    //顶部的阴影
    private lazy var _topView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(245, 245, 245, 1)
        return view
    }()
    
    //下方按钮
    private lazy var _lastDateButton: TelevisonButton = {
        let button = TelevisonButton(type: .custom)
        button.title = "昨天"
        button.tag = 1
        button.addTarget(self,
                         action: #selector(pickDateButtonClicked(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var _todayButton: TelevisonButton = {
        let button = TelevisonButton(type: .custom)
        button.title = "今天"
        button.isPicked = true
        button.tag = 2
        button.addTarget(self,
                         action: #selector(pickDateButtonClicked(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var _tomorrowButton: TelevisonButton = {
        let button = TelevisonButton(type: .custom)
        button.title = "明天"
        button.tag = 3
        button.addTarget(self,
                         action: #selector(pickDateButtonClicked(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var _tommrowBottomLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_topView)
        _topView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(15 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_lastDateButton)
        _lastDateButton.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(15 * iPHONE_AUTORATIO)
            make.width.equalTo(K_SCREEN_WIDTH/3)
        }
        
        contentView.addSubview(_todayButton)
        _todayButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(K_SCREEN_WIDTH/3)
            make.width.equalTo(K_SCREEN_WIDTH/3)
            make.top.equalTo(15 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_tomorrowButton)
        _tomorrowButton.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.width.equalTo(K_SCREEN_WIDTH/3)
            make.top.equalTo(15 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func pickDateButtonClicked(_ sender: UIButton){
        if sender.tag == 1 {
            _lastDateButton.isPicked = true
            _todayButton.isPicked = false
            _tomorrowButton.isPicked = false
        } else if sender.tag == 2 {
            _lastDateButton.isPicked = false
            _todayButton.isPicked = true
            _tomorrowButton.isPicked = false
        } else {
            _lastDateButton.isPicked = false
            _todayButton.isPicked = false
            _tomorrowButton.isPicked = true
        }
        
        block(sender.tag)
    }
}

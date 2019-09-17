//
//  TelevisionSectionView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/9/4.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///电视的节目表
class SXTelevisionSectionView: UIView {
    var selectedBlock: (Int) -> Void = { _ in }
    
    ///昨天
    var before: String? {
        willSet(newValue) {
            _yesterdayButton.subTitle = newValue ?? ""
        }
    }
    
    ///今天
    var today: String? {
        willSet(newValue) {
            _todayButton.subTitle = newValue ?? ""
        }
    }
    
    ///明天
    var after: String? {
        willSet(newValue) {
            _tomorrowButton.subTitle = newValue ?? ""
        }
    }
    
    
    ///昨天的按钮
    private lazy var _yesterdayButton: SXTelevisonButton = {
        let button = SXTelevisonButton(type: .custom)
        button.title = "昨天"
        button.tag = 1
        button.addTarget(self,
                         action: #selector(pickTelevisonChannelClick(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    ///今天的按钮
    private lazy var _todayButton: SXTelevisonButton = {
        let button = SXTelevisonButton(type: .custom)
        button.title = "今天"
        button.isPicked = true
        button.tag = 2
        button.addTarget(self,
                         action: #selector(pickTelevisonChannelClick(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    ///明天的按钮
    private lazy var _tomorrowButton: SXTelevisonButton = {
        let button = SXTelevisonButton(type: .custom)
        button.title = "明天"
        button.tag = 3
        button.addTarget(self,
                         action: #selector(pickTelevisonChannelClick(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    ///下方的横线
    private lazy var _bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(244, 244, 244, 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///初始化界面
    private func setupUI() {
        addSubview(_yesterdayButton)
        _yesterdayButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(K_SCREEN_WIDTH/3)
        }
        
        addSubview(_todayButton)
        _todayButton.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalTo(K_SCREEN_WIDTH/3)
        }
        
        addSubview(_tomorrowButton)
        _tomorrowButton.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(K_SCREEN_WIDTH/3)
        }
        
        addSubview(_bottomLine)
        _bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.height.equalTo(1)
        }
    }
    
    @objc private func pickTelevisonChannelClick(_ sender: UIButton) {
        if sender.tag ==  1 {
            _yesterdayButton.isPicked = true
            _todayButton.isPicked = false
            _tomorrowButton.isPicked = false
        } else if sender.tag == 2 {
            _yesterdayButton.isPicked = false
            _todayButton.isPicked = true
            _tomorrowButton.isPicked = false
        } else {
            _yesterdayButton.isPicked = false
            _todayButton.isPicked = false
            _tomorrowButton.isPicked = true
        }
        selectedBlock(sender.tag)
    }
}

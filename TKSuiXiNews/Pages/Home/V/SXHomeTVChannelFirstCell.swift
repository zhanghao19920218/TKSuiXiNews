//
//  HomeTVChannelFirstCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 频道信息
 */

fileprivate let boxSize = CGSize(width: 110 * iPHONE_AUTORATIO, height: 100 * iPHONE_AUTORATIO)

class SXHomeTVChannelFirstCell: BaseTableViewCell {
    var block:(Int) -> Void = { _ in }
    
    var firstImage:String? {
        willSet(newValue) {
            _newsChannel.imageName = newValue
        }
    }
    
    var secondImage:String? {
        willSet(newValue) {
            _movieChannel.imageName = newValue
        }
    }
    
    var thirdImage:String? {
        willSet(newValue) {
            _fmChannel.imageName = newValue
        }
    }
    
    var firstName:String? {
        willSet(newValue) {
            _newsChannel.title = newValue
        }
    }
    
    var movieName:String? {
        willSet(newValue) {
            _movieChannel.title = newValue
        }
    }
    
    var thirdName:String? {
        willSet(newValue) {
            _fmChannel.title = newValue
        }
    }

    private lazy var _newsChannel: SXHomeTVChannelNameView = {
        let view = SXHomeTVChannelNameView();
        view.tag = 1
        view.addTarget(self,
                       action: #selector(channelVersionTapped(_:)), for: .touchUpInside)
        return view;
    }();
    
    private lazy var _movieChannel: SXHomeTVChannelNameView = {
        let view = SXHomeTVChannelNameView();
        view.tag = 2
        view.addTarget(self,
                       action: #selector(channelVersionTapped(_:)), for: .touchUpInside)
        return view;
    }();
    
    private lazy var _fmChannel: SXHomeTVChannelNameView = {
        let view = SXHomeTVChannelNameView();
        view.tag = 3
        view.addTarget(self,
                       action: #selector(channelVersionTapped(_:)), for: .touchUpInside)
        return view;
    }();

    
    //MARK: - 初始化页面
    override func setupUI() {
        super.setupUI();
        
        contentView.addSubview(_movieChannel);
        _movieChannel.snp.makeConstraints { (make) in
            make.center.equalToSuperview();
            make.size.equalTo(boxSize)
        }
        
        contentView.addSubview(_newsChannel)
        _newsChannel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview();
            make.right.equalTo(self._movieChannel.snp_left).offset(-10 * iPHONE_AUTORATIO);
            make.size.equalTo(boxSize)
        }
        
        contentView.addSubview(_fmChannel)
        _fmChannel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview();
            make.left.equalTo(self._movieChannel.snp_right).offset(10 * iPHONE_AUTORATIO);
            make.size.equalTo(boxSize)
        }
    }
    
    @objc private func channelVersionTapped(_ sender: UIButton) {
        block(sender.tag)
    }
}

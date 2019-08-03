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

class HomeTVChannelFirstCell: BaseTableViewCell {
    var block:(Int) -> Void = { _ in }
    
    var firstImage:String? {
        willSet(newValue) {
            newsChannel.imageName = newValue
        }
    }
    
    var secondImage:String? {
        willSet(newValue) {
            movieChannel.imageName = newValue
        }
    }
    
    var thirdImage:String? {
        willSet(newValue) {
            fmChannel.imageName = newValue
        }
    }
    
    var firstName:String? {
        willSet(newValue) {
            newsChannel.title = newValue
        }
    }
    
    var movieName:String? {
        willSet(newValue) {
            movieChannel.title = newValue
        }
    }
    
    var thirdName:String? {
        willSet(newValue) {
            fmChannel.title = newValue
        }
    }

    private lazy var newsChannel: HomeTVChannelNameView = {
        let view = HomeTVChannelNameView();
        view.tag = 1
        view.addTarget(self,
                       action: #selector(channelVersionTapped(_:)), for: .touchUpInside)
        return view;
    }();
    
    private lazy var movieChannel: HomeTVChannelNameView = {
        let view = HomeTVChannelNameView();
        view.tag = 2
        view.addTarget(self,
                       action: #selector(channelVersionTapped(_:)), for: .touchUpInside)
        return view;
    }();
    
    private lazy var fmChannel: HomeTVChannelNameView = {
        let view = HomeTVChannelNameView();
        view.tag = 3
        view.addTarget(self,
                       action: #selector(channelVersionTapped(_:)), for: .touchUpInside)
        return view;
    }();

    
    //MARK: - 初始化页面
    override func setupUI() {
        super.setupUI();
        
        contentView.addSubview(movieChannel);
        movieChannel.snp.makeConstraints { (make) in
            make.center.equalToSuperview();
            make.size.equalTo(boxSize)
        }
        
        contentView.addSubview(newsChannel)
        newsChannel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview();
            make.right.equalTo(self.movieChannel.snp_left).offset(-10 * iPHONE_AUTORATIO);
            make.size.equalTo(boxSize)
        }
        
        contentView.addSubview(fmChannel)
        fmChannel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview();
            make.left.equalTo(self.movieChannel.snp_right).offset(10 * iPHONE_AUTORATIO);
            make.size.equalTo(boxSize)
        }
    }
    
    @objc private func channelVersionTapped(_ sender: UIButton) {
        block(sender.tag)
    }
}

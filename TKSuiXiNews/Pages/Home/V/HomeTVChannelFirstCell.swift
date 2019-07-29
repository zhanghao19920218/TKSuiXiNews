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

    private lazy var newsChannel: HomeTVChannelNameView = {
        let view = HomeTVChannelNameView();
        view.title = "新闻频道"
        return view;
    }();
    
    private lazy var movieChannel: HomeTVChannelNameView = {
        let view = HomeTVChannelNameView();
        view.title = "影视频道"
        return view;
    }();
    
    private lazy var fmChannel: HomeTVChannelNameView = {
        let view = HomeTVChannelNameView();
        view.title = "FM 93.7"
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
}

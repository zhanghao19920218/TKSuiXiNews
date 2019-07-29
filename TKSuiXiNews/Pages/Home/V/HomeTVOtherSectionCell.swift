//
//  HomeTVOtherSectionCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class HomeTVOtherSectionCell: BaseTableViewCell {
    var title:String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? "";
        }
    }
    
    var imageNameFirst: String? {
        willSet(newValue) {
            news_first.imageName = newValue;
        }
    }
    
    var imageNameSecond: String? {
        willSet(newValue) {
            news_second.imageName = newValue;
        }
    }
    
    var titleFirst:String? {
        willSet(newValue) {
            news_first.title = newValue ?? "";
        }
    }
    
    var titleSecond:String? {
        willSet(newValue) {
            news_second.title = newValue ?? "";
        }
    }
    
    var videoBlock: VideoTappedBlock = { }
    var videoSecondBlock: VideoTappedBlock = { }
    
    private lazy var upView: UIView = {
        let view = UIView();
        view.backgroundColor = RGBA(245, 245, 245, 1);
        return view;
    }();

    //MARK: - 濉溪新闻
    private lazy var titleLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(14 * iPHONE_AUTORATIO);
        return label;
    }();
    
    private lazy var line: UIView = {
        let line = UIView();
        line.backgroundColor = RGBA(244, 244, 244, 1);
        return line;
    }();
    
    //两个内容
    private lazy var news_first: HomeTVDetailPlayerView = {
        let view = HomeTVDetailPlayerView();
        view.title = "濉溪20年变化 10分钟回顾"
        return view;
    }();
    
    private lazy var news_second: HomeTVDetailPlayerView = {
        let view = HomeTVDetailPlayerView();
        view.title = "濉溪即将全面实行垃圾分类政策"
        return view;
    }();
    
    //全部按钮
    private lazy var indicationButton: UIButton = {
        let button = UIButton(type: .custom);
        return button;
    }();
    
    //全部的label
    private lazy var buttonTitleL: UILabel = {
        let label = UILabel();
        label.font = kFont(12 * iPHONE_AUTORATIO);
        label.text = "全部"
        label.textColor = RGBA(170, 170, 170, 1);
        return label;
    }();
    
    //全部的image
    private lazy var buttonImageV: UIImageView = {
        let imageView = UIImageView();
        imageView.image = K_ImageName("more_news_indicator");
        return imageView;
    }();
    
    override func setupUI() {
        super.setupUI();
        
        contentView.addSubview(upView)
        upView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview();
            make.height.equalTo(15 * iPHONE_AUTORATIO);
        }
        
        contentView.addSubview(titleLabel);
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10 * iPHONE_AUTORATIO);
            make.top.equalTo(30 * iPHONE_AUTORATIO);
            
        }
        
        contentView.addSubview(indicationButton)
        indicationButton.snp.makeConstraints { (make) in
            make.right.equalTo(0);
            make.centerY.equalTo(titleLabel.snp_centerY);
            make.size.equalTo(CGSize(width: 60 * iPHONE_AUTORATIO, height: 43 * iPHONE_AUTORATIO));
        }
        
        //增加标签和图片
        indicationButton.addSubview(buttonImageV)
        buttonImageV.snp.makeConstraints { (make) in
            make.right.equalTo(-10 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 7 * iPHONE_AUTORATIO, height: 12 * iPHONE_AUTORATIO));
        }
        
        indicationButton.addSubview(buttonTitleL)
        buttonTitleL.snp.makeConstraints { (make) in
            make.right.equalTo(buttonImageV.snp_left).offset(-5 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        contentView.addSubview(line);
        line.snp.makeConstraints { (make) in
            make.left.equalTo(10 * iPHONE_AUTORATIO);
            make.right.equalTo(-10 * iPHONE_AUTORATIO);
            make.top.equalTo(58 * iPHONE_AUTORATIO);
            make.height.equalTo(1);
        }
        
        contentView.addSubview(news_first);
        news_first.snp.makeConstraints { (make) in
            make.left.equalToSuperview();
            make.top.equalTo(self.line.snp_bottom);
            make.bottom.equalToSuperview();
            make.width.equalTo(K_SCREEN_WIDTH/2)
        }
        
        news_first.videoBlock = { [weak self] () in
            self?.videoBlock();
        }
        
        contentView.addSubview(news_second);
        news_second.snp.makeConstraints { (make) in
            make.right.equalToSuperview();
            make.top.equalTo(self.line.snp_bottom);
            make.bottom.equalToSuperview();
            make.width.equalTo(K_SCREEN_WIDTH/2)
        }
        
        news_second.videoBlock = { [weak self] () in
            self?.videoSecondBlock();
        }
    }

}

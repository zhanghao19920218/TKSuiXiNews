//
//  BaseShareBottomView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

public enum ShareButtonType: Int {
    case weiboShare = 1, wechatShare, circleShare, qqShare
}

typealias ShareButtonBlock = (ShareButtonType) -> Void

class BaseShareBottomView: BaseTableViewCell {
    //设置点击的Block
    var shareBlock:ShareButtonBlock?
    
    //分享标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(14 * iPHONE_AUTORATIO);
        label.textColor = RGBA(170, 170, 170, 1);
        label.text = "分享到"
        return label
    }();
    
    //微博分享
    private lazy var weiboShareItem: UIButton = {
        let button = UIButton(type: .custom);
        button.setImage(K_ImageName("weibo_share_icon"), for: .normal);
        button.addTarget(self,
                         action: #selector(shareButtonTapped(_:)),
                         for: .touchUpInside)
        button.tag = 1;
        return button;
    }();
    
    //微信分享
    private lazy var wechatShareItem: UIButton = {
        let button = UIButton(type: .custom);
        button.setImage(K_ImageName("wechat_share_icon"), for: .normal);
        button.addTarget(self,
                         action: #selector(shareButtonTapped(_:)),
                         for: .touchUpInside)
        button.tag = 2;
        return button;
    }();
    
    //微博分享
    private lazy var circleShareItem: UIButton = {
        let button = UIButton(type: .custom);
        button.setImage(K_ImageName("circle_share_icon"), for: .normal);
        button.addTarget(self,
                         action: #selector(shareButtonTapped(_:)),
                         for: .touchUpInside)
        button.tag = 3;
        return button;
    }();
    
    //微博分享
    private lazy var qqShareItem: UIButton = {
        let button = UIButton(type: .custom);
        button.setImage(K_ImageName("qq_share_icon"), for: .normal);
        button.addTarget(self,
                         action: #selector(shareButtonTapped(_:)),
                         for: .touchUpInside)
        button.tag = 4;
        return button;
    }();
    
    //初始化页面
    override func setupUI() {
        super.setupUI();
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(26 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        //微博分享
        addSubview(weiboShareItem);
        weiboShareItem.snp.makeConstraints { (make) in
            make.left.equalTo(142 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 23 * iPHONE_AUTORATIO, height: 19 * iPHONE_AUTORATIO))
        }
        
        //微信分享
        addSubview(wechatShareItem);
        wechatShareItem.snp.makeConstraints { (make) in
            make.left.equalTo(self.weiboShareItem.snp_right).offset(40 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 22 * iPHONE_AUTORATIO, height: 18 * iPHONE_AUTORATIO))
        }
        
        //朋友圈分享
        addSubview(circleShareItem);
        circleShareItem.snp.makeConstraints { (make) in
            make.left.equalTo(self.wechatShareItem.snp_right).offset(40 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 22 * iPHONE_AUTORATIO, height: 22 * iPHONE_AUTORATIO))
        }
        
        //微信分享
        addSubview(qqShareItem);
        qqShareItem.snp.makeConstraints { (make) in
            make.left.equalTo(self.circleShareItem.snp_right).offset(40 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 21 * iPHONE_AUTORATIO, height: 22 * iPHONE_AUTORATIO))
        }
    }
    
    //点击了分享按钮
    @objc private func shareButtonTapped(_ sender: UIButton) {
        guard let block = shareBlock else {
            print("没有分享数据")
            return;
        }
        
        //微博分享
        if sender.tag == 1 {
            block(ShareButtonType.weiboShare);
        } else if sender.tag == 2 {
            block(ShareButtonType.wechatShare);
        } else if sender.tag == 3 {
            block(ShareButtonType.circleShare);
        } else {
            block(ShareButtonType.qqShare)
        }
    }

}

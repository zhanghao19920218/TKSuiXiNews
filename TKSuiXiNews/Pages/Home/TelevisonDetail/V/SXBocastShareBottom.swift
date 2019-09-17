//
//  BocastShareBottom.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let textFont: UIFont = kFont(14 * iPHONE_AUTORATIO)

class SXBocastShareBottom: UIView {

    //按钮点击
    var bottomBlock: BottomButtonBlock?
    
    //是不是已经点赞
    var isLike:Int? {
        willSet(newValue) {
            if let value = newValue {
                likeButton.isSelected = (value == 1)
            }
        }
    }
    
    var isTappedBlock: (Bool) -> Void = { _ in }
    
    //评论按钮
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .custom);
        button.setTitleColor(RGBA(153, 153, 153, 1))
        button.setImage("comment_button_icon")
        button.setTitle(" 评论")
        button.titleLabel?.font = textFont
        button.tag = 1;
        button.addTarget(self,
                         action: #selector(bottomButtonTapped(_:)),
                         for: .touchUpInside)
        return button;
    }();
    
    //转发按钮
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom);
        button.setTitleColor(RGBA(153, 153, 153, 1))
        button.setImage("unlike_button_icon")
        button.setSelectedImage("like")
        button.setTitle(" 赞")
        button.titleLabel?.font = textFont
        button.tag = 2;
        button.addTarget(self,
                         action: #selector(bottomButtonTapped(_:)),
                         for: .touchUpInside)
        return button;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化页面
    private func setupUI() {
        //设置阴影
        layer.shadowOffset = CGSize(width: 0 , height: -10)
        layer.shadowOpacity = 1;
        layer.shadowRadius = 20;
        layer.shadowColor = RGBA(0, 0, 0, 0.05).cgColor
        backgroundColor = .white
        
        //评论按钮
        addSubview(commentButton);
        commentButton.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview()
            make.width.equalTo(K_SCREEN_WIDTH/2)
        }
        
        //赞按钮
        addSubview(likeButton);
        likeButton.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(K_SCREEN_WIDTH/2)
        }
        
        let line2 = UIView();
        addSubview(line2);
        line2.backgroundColor = RGBA(204, 204, 204, 1);
        line2.snp.makeConstraints { (make) in
            make.right.equalTo(-K_SCREEN_WIDTH/2)
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 1, height: 20 * iPHONE_AUTORATIO))
        }
    }
    
    //点击底部按钮
    @objc private func bottomButtonTapped(_ sender: UIButton) {
        guard let block = bottomBlock else {
            print("没有分享数据")
            return;
        }
        
        //转发
        if sender.tag == 1 {
            block(BottomButtonType.comment);
        } else {
            isTappedBlock(sender.isSelected)
        }
    }
}

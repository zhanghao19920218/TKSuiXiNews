//
//  ResendButtonBottom.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import FaveButton

//MARK: - 设置font
fileprivate let textFont: UIFont = kFont(14 * iPHONE_AUTORATIO)

public enum BottomButtonType: Int {
    case resend = 1, comment, like
}

typealias BottomButtonBlock = (BottomButtonType) -> Void

class ResendButtonBottom: UIView {
    //按钮点击
    var bottomBlock: BottomButtonBlock?
    
    //是不是已经点赞
    var isLike:Int? {
        willSet(newValue) {
            if let value = newValue {
                likeButton.isSelected = (value == 1)
                //设置动画效果
                let status = likeButton.isSelected
                faveButton.setSelected(selected: status, animated: true)
//                likeButton.isEnabled = true
            }
        }
    }
    
    var isTappedBlock: (Bool) -> Void = { _ in }
    
    //转发按钮
    private lazy var resendButton: UIButton = {
        let button = UIButton(type: .custom);
        button.setTitleColor(RGBA(153, 153, 153, 1))
        button.setImage("detail_bottom_share")
        button.setTitle(" 转发")
        button.titleLabel?.font = textFont
        button.tag = 1;
        button.addTarget(self,
                         action: #selector(bottomButtonTapped(_:)),
                         for: .touchUpInside)
        return button;
    }();
    
    //评论按钮
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .custom);
        button.setTitleColor(RGBA(153, 153, 153, 1))
        button.setImage("comment_button_icon")
        button.setTitle(" 评论")
        button.titleLabel?.font = textFont
        button.tag = 2;
        button.addTarget(self,
                         action: #selector(bottomButtonTapped(_:)),
                         for: .touchUpInside)
        return button;
    }();
    
    //转发按钮
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(RGBA(153, 153, 153, 1))
        button.setTitle(" 赞")
        button.titleLabel?.font = textFont
        button.tag = 3;
        button.addTarget(self,
                         action: #selector(bottomButtonTapped(_:)),
                         for: .touchUpInside)
        return button;
    }()
    
    //设置点击点赞按钮
    private lazy var faveButton: FaveButton = {
        let faveButton = FaveButton(frame: .zero, faveIconNormal: K_ImageName("like"))
        faveButton.setImage("dislike")
        faveButton.setSelectedImage("like")
        faveButton.isUserInteractionEnabled = false
        return faveButton
    }()
    
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

        //转发按钮
        addSubview(resendButton);
        resendButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview();
            make.width.equalTo(K_SCREEN_WIDTH/3)
        }
        
        //评论按钮
        addSubview(commentButton);
        commentButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview();
            make.left.equalTo(K_SCREEN_WIDTH/3);
            make.width.equalTo(K_SCREEN_WIDTH/3);
        }
        
        //赞按钮
        addSubview(likeButton);
        likeButton.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview();
            make.width.equalTo(K_SCREEN_WIDTH/3);
        }
        
        let line1 = UIView();
        line1.backgroundColor = RGBA(204, 204, 204, 1);
        addSubview(line1);
        line1.snp.makeConstraints { (make) in
            make.left.equalTo(K_SCREEN_WIDTH/3)
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 1, height: 20 * iPHONE_AUTORATIO))
        }
        
        let line2 = UIView();
        addSubview(line2);
        line2.backgroundColor = RGBA(204, 204, 204, 1);
        line2.snp.makeConstraints { (make) in
            make.right.equalTo(-K_SCREEN_WIDTH/3)
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 1, height: 20 * iPHONE_AUTORATIO))
        }
        
        //点赞按钮添加
        likeButton.addSubview(faveButton)
        faveButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(30 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 17 * iPHONE_AUTORATIO, height: 15 * iPHONE_AUTORATIO))
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
            block(BottomButtonType.resend);
        } else if sender.tag == 2 {
            block(BottomButtonType.comment);
        } else {
            print("点击按钮\(sender.isSelected)")
            isTappedBlock(sender.isSelected)
        }
    }
}

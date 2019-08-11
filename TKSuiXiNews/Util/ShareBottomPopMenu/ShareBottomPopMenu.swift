//
//  ShareBottomPopMenu.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/10.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 分享的弹窗
 */

enum ShareBottomPopMenuType:Int {
    case weibo = 1, wechat, circle, qq
}

fileprivate let buttonWidth = 93 * iPHONE_AUTORATIO

class ShareBottomPopMenu: UIView {
    private var block: (ShareBottomPopMenuType) -> Void = { _ in }

    //弹窗背景
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(12 * iPHONE_AUTORATIO)
        label.text = "分享到"
        label.textColor = RGBA(153, 153, 153, 1)
        return label
    }()
    
    private lazy var weiboIcon: ShareDetailButton = {
        let button = ShareDetailButton()
        button.imageName = "weibo_bottom_share_icon"
        button.title = "新浪微博"
        button.tag = 1
        button.addTarget(self,
                         action: #selector(tappedShareButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var wechatIcon: ShareDetailButton = {
        let button = ShareDetailButton()
        button.imageName = "wechat_bottom_share_icon"
        button.title = "微信"
        button.tag = 2
        button.addTarget(self,
                         action: #selector(tappedShareButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var wechatCircleIcon: ShareDetailButton = {
        let button = ShareDetailButton()
        button.imageName = "circle_bottom_share_icon"
        button.title = "朋友圈"
        button.tag = 3
        button.addTarget(self,
                         action: #selector(tappedShareButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var qqIcon: ShareDetailButton = {
        let button = ShareDetailButton()
        button.imageName = "qq_bottom_share_icon"
        button.title = "QQ"
        button.tag = 4
        button.addTarget(self,
                         action: #selector(tappedShareButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var lightGrayLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(244, 244, 244, 1)
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("取消")
        button.titleLabel?.font = kFont(16 * iPHONE_AUTORATIO)
        button.setTitleColor(.black)
        return button
    }()
    
    //初始化页面
    private override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI(frame: frame)
    }
    
    @objc private func tapGestureRecognizerAction(_ sender:UITapGestureRecognizer) {
        tappedCancel();
    }
    
    //取消
    private func tappedCancel() {
        self.removeFromSuperview();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(frame: CGRect) {
        let alertBgView = UIView.init(frame: frame);
        alertBgView.tag = 100;
        alertBgView.backgroundColor = RGBA(0, 0, 0, 0.6);
        alertBgView.isUserInteractionEnabled = true;
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureRecognizerAction(_:)))
        alertBgView.addGestureRecognizer(tap);
        addSubview(alertBgView);
        
        //背景
        addSubview(backView);
        backView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(201 * iPHONE_AUTORATIO)
        }
        
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(25 * iPHONE_AUTORATIO)
        }
        
        backView.addSubview(weiboIcon)
        weiboIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(45 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: buttonWidth, height: buttonWidth))
        }
        
        backView.addSubview(wechatIcon)
        wechatIcon.snp.makeConstraints { (make) in
            make.left.equalTo(buttonWidth)
            make.top.equalTo(45 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: buttonWidth, height: buttonWidth))
        }
        
        backView.addSubview(wechatCircleIcon)
        wechatCircleIcon.snp.makeConstraints { (make) in
            make.left.equalTo(2 * buttonWidth)
            make.top.equalTo(45 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: buttonWidth, height: buttonWidth))
        }
        
        backView.addSubview(qqIcon)
        qqIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalTo(45 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: buttonWidth, height: buttonWidth))
        }
        
        backView.addSubview(lightGrayLine)
        lightGrayLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(-50 * iPHONE_AUTORATIO)
            make.left.right.equalToSuperview()
            make.height.equalTo(5 * iPHONE_AUTORATIO)
        }
        
        backView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(50 * iPHONE_AUTORATIO)
        }
        cancelButton.addTarget(self,
                               action: #selector(tapGestureRecognizerAction(_:)), for: .touchUpInside)
    }
    
    /// 显示提醒的界面
    ///
    /// - Parameter title: 标题, detail: 具体内容, confirmTitle: 确认按钮的标题,
    /// - Returns: return void
    public static func show(success:@escaping (ShareBottomPopMenuType) -> Void){
        //获取当前页面
        let vc = UIViewController.current()
        
        let view = ShareBottomPopMenu(frame: CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT))
        vc?.navigationController?.view.addSubview(view)
        view.block = { (type) in
            success(type)
        }
    }
    
    //点击分享按钮
    @objc private func tappedShareButton(_ sender: UIButton) {
        if sender.tag == 1 {
            block(.weibo)
        }
        if sender.tag == 2 {
            block(.wechat)
        }
        if sender.tag == 3 {
            block(.circle)
        }
        if sender.tag == 4 {
            block(.qq)
        }
        tappedCancel()
    }
}

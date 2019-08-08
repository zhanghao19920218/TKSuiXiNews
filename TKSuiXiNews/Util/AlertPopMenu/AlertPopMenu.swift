//
//  AlertPopMenu.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/8.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 项目通用弹窗
 */
fileprivate let fontSize = kFont(13 * iPHONE_AUTORATIO)

typealias VoidCallBackBlock = () -> Void

class AlertPopMenu: UIView {
    private var confirmBlock: VoidCallBackBlock = { }
    
    private var cancelBlock: VoidCallBackBlock = { }
    
    //弹窗背景
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10 * iPHONE_AUTORATIO
        return view
    }()
    
    //弹窗标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kBoldFont(14 * iPHONE_AUTORATIO)
        label.textAlignment = .center
        return label
    }()
    
    //弹窗内容
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(11 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        label.textColor = RGBA(102, 102, 102, 1)
        label.textAlignment = .center
        return label
    }()
    
    //单按钮
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 17 * iPHONE_AUTORATIO
        button.backgroundColor = RGBA(255, 74, 92, 1)
        button.titleLabel?.font = fontSize
        button.setTitleColor(.white)
        button.addTarget(self,
                         action: #selector(tappedConfirmButton),
                         for: .touchUpInside)
        return button
    }()
    
    //双按钮
    private lazy var doubleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = fontSize
        button.setTitleColor(RGBA(255, 74, 92, 1))
        button.isHidden = true
        button.addTarget(self,
                         action: #selector(tappedDoubleButton(_:)),
                         for: .touchUpInside)
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
    
    //初始化界面
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
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 205 * iPHONE_AUTORATIO, height: 195 * iPHONE_AUTORATIO))
        };
        
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(25 * iPHONE_AUTORATIO)
            make.centerX.equalToSuperview()
        }
        
        backView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(62 * iPHONE_AUTORATIO)
            make.left.equalTo(17 * iPHONE_AUTORATIO)
            make.right.equalTo(-17 * iPHONE_AUTORATIO)
        }
        
        backView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(116 * iPHONE_AUTORATIO)
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.height.equalTo(34 * iPHONE_AUTORATIO)
        }
        
        backView.addSubview(doubleButton)
        doubleButton.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.top.equalTo(150 * iPHONE_AUTORATIO)
            make.height.equalTo(34 * iPHONE_AUTORATIO)
        }
    }

    /// 显示提醒的界面
    ///
    /// - Parameter title: 标题, detail: 具体内容, confirmTitle: 确认按钮的标题,
    /// - Returns: return void
    public static func show(title: String, detail:String, confirmTitle:String, doubleTitle: String?, confrimBlock: @escaping VoidCallBackBlock, doubleBlock: @escaping VoidCallBackBlock){
        //获取当前页面
        let vc = UIViewController.current()
        
        let view = AlertPopMenu(frame: CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT))
        vc?.navigationController?.view.addSubview(view)
        view.titleLabel.text = title
        view.detailLabel.text = detail
        view.confirmButton.setTitle(confirmTitle)
        if let _ = doubleTitle { view.doubleButton.isHidden = false ;view.doubleButton.setTitle(doubleTitle ?? "") }
        view.confirmBlock = {
            confrimBlock()
        }
        
        view.cancelBlock = {
            doubleBlock()
        }
    }
    
    //MARK: - 点击第一个按钮
    @objc private func tappedConfirmButton(_ sender: UIButton) {
        tappedCancel()
        confirmBlock()
    }
    
    //MARK: - 点击第二个按钮
    @objc private func tappedDoubleButton(_ sender: UIButton) {
        tappedCancel()
        cancelBlock()
    }
}

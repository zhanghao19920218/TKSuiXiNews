//
//  MallPopMenu.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class MallPopMenu: UIView {
    var string = "转盘送积分活动获得积分"
    var string2 = "是否消耗0分兑换\nIPhone Xs ?"
    var newString = ""
    
    //上面的view
    private lazy var backView: UIImageView = {
        let view = UIImageView();
        return view;
    }();
    
    var score: Int? {
        willSet(newValue) {
            string.append("\(newValue ?? 0)分")
            newString = "\(newValue ?? 0)分"
        }
    }
    
    var isLottery:Bool? {
        willSet(newValue) {
            if let value = newValue {
                backView.image = K_ImageName(value ? "lottery_pop_menu" : "exchange_gift_menu")
                titleLabel.text = value ? "新 增 积 分" : "商 品 兑 换"
                if value {
                    let attrStr = NSMutableAttributedString.init(string: string)
                    attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:RGBA(102, 102, 102, 1), range:NSRange.init(location:0, length: 11))
                    attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:RGBA(255, 74, 92, 1), range:NSRange.init(location:11, length: newString.count - 1))
                    attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:RGBA(102, 102, 102, 1), range:NSRange.init(location:10 + newString.count, length: 1))
                    describeLabel.attributedText = attrStr
                } else {
                    let attrStr = NSMutableAttributedString.init(string: "是否消耗56789分兑换\nIPhone Xs ?")
                    attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:RGBA(102, 102, 102, 1), range:NSRange.init(location:0, length: 4))
                    attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:RGBA(255, 74, 92, 1), range:NSRange.init(location:4, length: 5))
                    attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:RGBA(102, 102, 102, 1), range:NSRange.init(location:9, length: 15))
                    describeLabel.attributedText = attrStr
                }
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kBoldFont(16 * iPHONE_AUTORATIO)
        label.textColor = .white
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage("close_menu_button")
        return button
    }()
    
    private lazy var describeLabel: UILabel = {
        let label = UILabel()
        label.font = kBoldFont(12 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var knowButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white)
        button.setTitle("知道了")
        button.backgroundColor = RGBA(255, 74, 92, 1)
        button.layer.cornerRadius = 15 * iPHONE_AUTORATIO
        button.titleLabel?.font = kFont(12 * iPHONE_AUTORATIO)
        return button
    }()
    
    //初始化页面
    override init(frame: CGRect) {
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
            make.size.equalTo(CGSize(width: 214 * iPHONE_AUTORATIO, height: 249 * iPHONE_AUTORATIO))
        };
        
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(65 * iPHONE_AUTORATIO)
            make.centerX.equalToSuperview()
        }
        
        backView.addSubview(describeLabel)
        describeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(31 * iPHONE_AUTORATIO)
            make.right.equalTo(-31 * iPHONE_AUTORATIO)
            make.top.equalTo(144 * iPHONE_AUTORATIO)
        }
        
        backView.addSubview(knowButton)
        knowButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-19 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 125 * iPHONE_AUTORATIO, height: 30 * iPHONE_AUTORATIO))
        }
        
        backView.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalTo(-4 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 18 * iPHONE_AUTORATIO, height: 18 * iPHONE_AUTORATIO))
        }
    }

}

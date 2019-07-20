//
//  SXLoginTextField.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import SnapKit

//MARK: 登录模块的textField
class SXLoginTextField: UIView {
    //前面的Logo
    lazy var prefix: UIImageView = {
        let imageView = UIImageView();
        return imageView;
    }();
    
    //后面的Logo
    lazy var suffix: UIImageView = {
        let imageView = UIImageView();
        imageView.isHidden = true;
        imageView.image = K_ImageName("true")
        return imageView;
    }();
    
    //显示发送验证码的按钮
    lazy var suffixButton: CounterButton = {
        let button = CounterButton.init(normalTitle: "发送验证码");
        return button;
    }();
    
    //是否隐藏后面的suffix
    var isSuffixHidden: Bool {
        willSet(value) {
            if value {
                suffix.isHidden = true;
            } else {
                suffix.isHidden = false;
            }
        }
    }
    
    //是否显示按钮
    var isShowButton: Bool {
        willSet(value) {
            if value { //如果显示按钮
                rebuild(); //重新更新页面
            }
        }
    }
    
    //占位内容
    var placeholder: String {
        willSet(value) {
            textField.placeholder = value;
        }
    }
    
    //里面的textField
    lazy var textField: UITextField = {
        let textField = UITextField.init();
        textField.font = kFont(14 * iPHONE_AUTORATIO);
        return textField;
    }();
    
    override init(frame: CGRect) {
        isSuffixHidden = true; //初始化hiiden
        placeholder = ""; //初始化占位符号
        isShowButton = false; //初始化是否显示按钮
        super.init(frame: frame);
        
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化界面
    private func setupUI() {
        //背景颜色
        backgroundColor = loginTextFColor;
        
        //设置边角
        layer.cornerRadius = 22 * iPHONE_AUTORATIO;
        
        //前面的Logo
        addSubview(prefix);
        prefix.snp.makeConstraints { (make) in
            make.left.equalTo(20 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 10 * iPHONE_AUTORATIO, height: 14 * iPHONE_AUTORATIO));
        };
        
        //后面的背景
        addSubview(suffix);
        suffix.snp.makeConstraints { (make) in
            make.right.equalTo(-20 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 13 * iPHONE_AUTORATIO, height: 13 * iPHONE_AUTORATIO));
        }
        
        //textField
        addSubview(textField);
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(self.prefix.snp_right).offset(10 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.right.equalTo(self.suffix.snp_left).offset(-10 * iPHONE_AUTORATIO);
        };
        
    }
    
    //重新更新页面
    private func rebuild(){
        addSubview(suffixButton);
        suffixButton.snp.makeConstraints { (make) in
            make.right.equalTo(-21 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 90 * iPHONE_AUTORATIO, height: 20 * iPHONE_AUTORATIO));
        };
        
        //重新更新textField
        textField.snp.remakeConstraints { (make) in
            make.left.equalTo(self.prefix.snp_right).offset(10 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.right.equalTo(self.suffixButton.snp_left).offset(-10 * iPHONE_AUTORATIO);
        };
    }
}

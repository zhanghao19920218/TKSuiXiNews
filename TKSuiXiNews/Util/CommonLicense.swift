//
//  CommonLicense.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

//MARK: - 点击注册及同意的协议
fileprivate let K_BASE_license = "濉溪发布用户服务协议";
fileprivate let K_BASE_font = kFont(12 * iPHONE_AUTORATIO);
class CommonLicense: UIView {
    var block: () -> Void = { }

    //MARK: -按钮
    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom);
        button.setImage(K_ImageName("unchoose"), for: .normal); //未选中
        button.setImage(K_ImageName("choose"), for: .selected); //选中的logo
        button.imageEdgeInsets = UIEdgeInsets.init(top: 3 * iPHONE_AUTORATIO, left: 3 * iPHONE_AUTORATIO, bottom: 3 * iPHONE_AUTORATIO, right: 3 * iPHONE_AUTORATIO)
        button.addTarget(self,
                         action: #selector(chooseButton(_:)),
                         for: .touchUpInside);
        return button;
    }();

    //MARK: -标题
    lazy var titleL: UILabel = {
        let label = UILabel.init();
        label.font = K_BASE_font;
        label.textColor = RGBA(153, 153, 153, 1);
        label.text = "注册即同意";
        return label;
    }();
    
    //MARK: -点击跳转
    lazy var licenseB: UIButton = {
        let button = UIButton.init(type: .custom);
        button.setTitle(K_BASE_license, for: .normal);
        button.setTitleColor(RGBA(61, 143, 234, 1), for: .normal);
        button.titleLabel?.font = K_BASE_font;
        button.addTarget(self,
                         action: #selector(licenseButton(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化界面
    private func setupUI(){
        //同意的按钮
        addSubview(button);
        button.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 20 * iPHONE_AUTORATIO, height: 20 * iPHONE_AUTORATIO));
        };
        
        //注册及同意
        addSubview(titleL);
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(self.button.snp_right);
            make.centerY.equalToSuperview();
        };
        
        //用户协议
        addSubview(licenseB);
        licenseB.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleL.snp_right).offset(0);
            make.centerY.equalToSuperview();
            make.height.equalTo(20 * iPHONE_AUTORATIO);
        };
    }
    
    @objc private func chooseButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected;
        print("点击了同意按钮");
    }
    
    @objc private func licenseButton(_ sender: UIButton) {
        print("点击了服务协议");
        block()
    }
}

//
//  BaseLoginViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class BaseLoginViewController: BaseViewController {
    
    //登录界面的Logo
    private lazy var logo: UIImageView = {
        let imageView = UIImageView.init();
        imageView.image = K_ImageName("logo");
        return imageView;
    }();
    
    //下面的按钮
    lazy var button: SXLoginBaseButton = {
        let button = SXLoginBaseButton.init(type: .custom);
        button.addTarget(self,
                         action: #selector(buttonAction(_:)),
                         for: .touchUpInside);
        return button;
    }();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI(); //初始化页面
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
    

    //初始化标题
    private func setupUI() {
        
        //初始化界面
        view.addSubview(self.logo);
        self.logo.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(60 * iPHONE_AUTORATIO);
            make.size.equalTo(CGSize(width: 70 * iPHONE_AUTORATIO, height: 59 * iPHONE_AUTORATIO));
        };
        
        
    }

    
    //给按钮增加点击事件
    @objc private func buttonAction(_ sender: UIButton) {
        buttonTapped(sender);
    }
    
    func buttonTapped(_ sender: UIButton) {
        
    }
}

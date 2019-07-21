//
//  MineViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController {
    //设置背景的view
    private lazy var backImageView: UIImageView = {
        let imageView = UIImageView.init();
        imageView.image = K_ImageName("mine_info_back");
        return imageView;
    }();
    
    //头像
//    private lazy var 
    
    //昵称
    
    //号码
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createNavigationBarLogo();
        
        //设置背景透明
        setupTransaleBar();
        
        setupUI()
    }
    
    //MARK: - 设置透明NavigationBar
    private func setupTransaleBar(){
        navigationController?.navigationBar.isTranslucent = true;
    }
    

    //MARK: -更新个人页面背景
    private func setupUI(){
        
        view.addSubview(backImageView);
        backImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview();
            make.top.equalTo(0);
            make.height.equalTo(311 * iPHONE_AUTORATIO);
        };
    }
}

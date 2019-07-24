//
//  BaseViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI();
        
        loadData();
    }
    

    //MARK: 设置全局的背景颜色
    private func setupUI(){
        view.backgroundColor = UIColor.white;
        
        //设置导航栏的NavigationBar
        if (navigationController?.viewControllers.count ?? 0 > 1) {
            addBackImageBtnInTopBar();
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated);
//        
//        loadData();
//    }
    
    //初始化NavigationBar的Logo
    func createNavigationBarLogo()
    {
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 97 * iPHONE_AUTORATIO, height: 19 * iPHONE_AUTORATIO))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 97 * iPHONE_AUTORATIO, height: 19 * iPHONE_AUTORATIO))
        imageView.contentMode = .scaleAspectFit
        let image = K_ImageName("logo_top");
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
    }

    
    // MARK: 修改返回按钮
    private func addBackImageBtnInTopBar ()
    {
        let backB = UIButton.init();
        if StaticMethod.share.isUserLogin {
            backB.setImage("token_back_main");
        } else {
            backB.setImage("back_main");
        }
        backB.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -30, bottom: 0, right: 0);
        backB.frame = CGRect(x: 0, y: 0, width: 44, height: 44);
        backB.addTarget(self,
                        action: #selector(self.popViewControllerBtnPressed),
                        for: .touchUpInside);
        let barButton = UIBarButtonItem.init(customView: backB);
        self.navigationItem.leftBarButtonItem = barButton;
    }
    
    @objc func popViewControllerBtnPressed() {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    //基类进行网络请求
    func loadData() {

    }

}

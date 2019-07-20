//
//  BaseTabBarController.swift
//  OodsOwnMore
//
//  Created by Barry Allen on 2019/5/8.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController, tabBarDelegate {
    
    private var costomTabBar:BATabBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTabBar();

        //添加子控制器
        setupAddChildViewController()
        
        self.tabBar.backgroundImage = UIImage.init();
        self.tabBar.shadowImage = UIImage.init();
    }
    
    func tabBar(_ tabBar: BATabBar, didSelectedButtonFrom from: Int, toIndex to: Int) {
        print("\(from), \(to)");
        self.selectedIndex = to;
        print("\(self.selectedIndex)");
    }

    //取出系统自带的tabbar并把里面的按钮删除掉
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        for child in self.tabBar.subviews {
            if (child.isKind(of: UIControl.self)) {
                child.isHidden = true;
            }
        }
    }
    
    private func setupTabBar() {
        let customTabBar:BATabBar = BATabBar.init();
        self.tabBar.backgroundColor = RGBA(255, 255, 255, 1);
        customTabBar.delegate = self;
        customTabBar.frame = self.tabBar.bounds;
        self.costomTabBar = customTabBar;
        self.tabBar.addSubview(customTabBar);
    }
    
    private func setupAddChildViewController() {
        let homeVC = HomeViewController.init();
        self.setupChildViewController(homeVC, title: "首页", imageName: "home_tab", selectedImageName: "home_selected_tab", withTag: 0);
        
        let orderVC = ShowViewController.init();
        self.setupChildViewController(orderVC, title: "随手拍", imageName: "camera_tab", selectedImageName: "camera_selected_tab", withTag: 1);
        
        let carVC = ServiceViewController.init();
        self.setupChildViewController(carVC, title: "服务", imageName: "server_tab", selectedImageName: "server_tab_selected", withTag: 2);
        
        let mineVC = MineViewController.init();
        self.setupChildViewController(mineVC, title: "我的", imageName: "mine_tab", selectedImageName: "mine_selected_tab", withTag: 3);
    }
    
    private func setupChildViewController(_ controller: UIViewController,
                                          title: String,
                                          imageName: String,
                                          selectedImageName: String,
                                          withTag tag:NSInteger)
    {
        controller.tabBarItem.title = title; //跟上面的效果一样
        controller.tabBarItem.image = K_ImageName(imageName);
        controller.tabBarItem.selectedImage = K_ImageName(selectedImageName);
        
        //包装导航栏控制器
        let nav: BANavigationController = BANavigationController.init(rootViewController: controller);
        self.addChild(nav);
        
        self.costomTabBar.addTabBarButtonWithItem(controller.tabBarItem, withTag: tag);
    }
}

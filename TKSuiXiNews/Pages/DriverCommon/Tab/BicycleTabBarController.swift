//
//  BicycleTabBarController.swift
//  TKSuiXiNews
//
//  Created by Mason on 2019/9/16.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///设置主题颜色
public let bicycleAppThemeColor = RGBA(27, 119, 245, 1)

class BicycleTabBarController: UITabBarController, tabBarDelegate {
    
    private var costomTabBar:BATabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupTabBar();
        
        //添加子控制器
        setupAddChildViewController()
        
        self.tabBar.backgroundImage = UIImage.init();
        self.tabBar.shadowImage = UIImage.init();
        
        tabBar.isTranslucent = false
    }
    
    func tabBar(_ tabBar: BATabBar, didSelectedButtonFrom from: Int, toIndex to: Int) {
        print("\(from), \(to)")
        self.selectedIndex = to
        print("\(self.selectedIndex)")
    }
    
    //取出系统自带的tabbar并把里面的按钮删除掉
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        for child in self.tabBar.subviews {
            if child is UIControl {
                child.isHidden = true
            }
        }
    }
    
    private func setupTabBar() {
        let customTabBar:BATabBar = BATabBar.init();
        self.tabBar.backgroundColor = RGBA(255, 255, 255, 1)
        customTabBar.delegate = self;
        customTabBar.frame = self.tabBar.bounds;
        self.costomTabBar = customTabBar;
        self.tabBar.addSubview(customTabBar);
    }
    
    private func setupAddChildViewController() {
        let homeVC = BicycleHomeController()
        self.setupChildViewController(homeVC, title: "出行", imageName: "bicy_home_tab_normal", selectedImageName: "bicy_home_tab_selected", withTag: 0);
        
        let orderVC = CommunicationController()
        self.setupChildViewController(orderVC, title: "分享", imageName: "bicy_station_tab_normal", selectedImageName: "bicy_station_tab_selected", withTag: 1);
        
        let carVC = SXMineWalletController();
        self.setupChildViewController(carVC, title: "钱包", imageName: "bicy_wallet_tab_normal", selectedImageName: "bicy_wallet_tab_selected", withTag: 2);
        
        let mineVC = BicycleMineController();
        self.setupChildViewController(mineVC, title: "我的", imageName: "bicy_mine_tab_normal", selectedImageName: "bicy_mine_tab_selected", withTag: 3);
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

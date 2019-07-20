//
//  BATabBar.swift
//  OodsOwnMore
//
//  Created by Barry Allen on 2019/5/8.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

@objc protocol tabBarDelegate {
    @objc optional func tabBar(_ tabBar: BATabBar, didSelectedButtonFrom from:Int, toIndex to:Int);
}

class BATabBar: UIView {
    
    weak var selectedButton: BATabBarButton?
    
    weak var delegate: tabBarDelegate!
    
    //懒加载
    fileprivate lazy var tabBarItemArr: Array<BATabBarButton> = {
        let array = Array<BATabBarButton> ();
        return array;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        UITabBar.appearance().tintColor = RGBA(255, 255, 255, 1);
    }
    
    /**
     * protected方法: 给自定义的tabbar添加按钮
     */
    func addTabBarButtonWithItem(_ item: UITabBarItem, withTag tag: NSInteger) {
        //1.创建按钮
        let button: BATabBarButton = BATabBarButton.init();
        self.addSubview(button);
        
        //设置数据把buttonItem模型传给button
        button.item = item;
        button.tag = tag;
        //监听点击button
        button.addTarget(self,
                         action: #selector(buttonClick(_:)),
                         for: .touchDown);
        
        self.tabBarItemArr.append(button); //完成数据添加如数组,方便后期修改
        //默认选中后
        if (self.subviews.count == 1) {
            self.buttonClick(button);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     * button监听事件
     */
    @objc fileprivate func buttonClick(_ button: BATabBarButton) {
        guard let method = self.delegate.tabBar else {
            print("委托方法不存在");
            return;
        }
        
        if let selectedBtn = selectedButton {
            method(self, selectedBtn.tag, button.tag);
            selectedBtn.isSelected = false;
            button.isSelected = true;
            self.selectedButton = button;
        } else {
            print("按钮暂时不存在");
            button.isSelected = true;
            self.selectedButton = button;
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        let buttonW:CGFloat = self.frame.size.width / CGFloat(self.subviews.count);
        let buttonH:CGFloat = self.frame.size.height;
        let buttonY:CGFloat = 0;
        
        for (index, subview) in self.subviews.enumerated() {
            //1.取出按钮
            let button:BATabBarButton = subview as! BATabBarButton;
            
            //2.设置按钮的frame
            let buttonX:CGFloat = CGFloat(index) * buttonW;
            
            button.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH);
            
            //3.绑定tag
            button.tag = index;
        }
    }
}

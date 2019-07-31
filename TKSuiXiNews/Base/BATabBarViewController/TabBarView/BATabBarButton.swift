//
//  BATabBarButton.swift
//  OodsOwnMore
//
//  Created by Barry Allen on 2019/5/8.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

let TGTabBarButtonImageRatio:CGFloat = 0.6;

class BATabBarButton: UIButton {
    fileprivate var newItem: UITabBarItem!;

    var item: UITabBarItem! {
        get {
            return self.newItem;
        }
        set (newValue) {
            self.setTitle(newValue.title, for: .normal);
            self.setImage(newValue.image, for: .normal);
            self.setImage(newValue.selectedImage, for: .selected);
            self.newItem = newValue;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        //图片居中
        self.imageView?.contentMode = .center;
        //文字居中
        self.titleLabel?.textAlignment = .center;
        //字体居中
        self.titleLabel?.font = kFont(11);
        //文字颜色
        self.setTitleColor(RGBA(208, 208, 208, 1), for: .normal);
        self.setTitleColor(appThemeColor, for: .selected);
        
        //添加一个提醒数字按钮
        let badgeButton = UIButton.init();
        self.addSubview(badgeButton);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW = contentRect.size.width;
        var imageH = contentRect.size.height;
        imageH = contentRect.size.height * TGTabBarButtonImageRatio;
        return CGRect(x: 0, y: 0, width: imageW, height: imageH);
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleY = contentRect.size.height * TGTabBarButtonImageRatio;
        let titleW = contentRect.size.width;
        let titleH = contentRect.size.height - titleY;
        return CGRect(x: 0, y: titleY, width: titleW, height: titleH);
    }
}

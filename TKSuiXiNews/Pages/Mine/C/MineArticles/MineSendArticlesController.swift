//
//  MineSendArticlesController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import DNSPageView

/*
 * 我的帖子
 */
//PageView的frame
fileprivate let pageViewRect = CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT);
fileprivate let pageViewNormalTitleColor = RGBA(255, 132, 143, 1)
fileprivate let pageViewSelectedTitleColor = UIColor.white
fileprivate let pageViewFontSize = kBoldFont(14 * iPHONE_AUTORATIO);
//标题栏高度
fileprivate let pageViewTitleHeight = 40 * iPHONE_AUTORATIO;

class MineSendArticlesController: BaseViewController {
    
    //初始化页面选择器
    lazy var pageViewManager: DNSPageViewManager = {
        let style = DNSPageStyle();
        //可以滑动的ScrollViews
        style.isTitleViewScrollEnabled = false
        style.titleColor = pageViewNormalTitleColor;
        style.titleSelectedColor = pageViewSelectedTitleColor;
        style.titleFont = pageViewFontSize;
        style.titleViewHeight = pageViewTitleHeight
        style.titleViewBackgroundColor = appThemeColor
        //消除系统默认的offset
        automaticallyAdjustsScrollViewInsets = false
        
        
        // 设置标题内容
        let titles = ["拍客", "V视"];
        
        // 创建每一页对应的controller
        let childViewControllers: [UIViewController] = titles.enumerated().map { (index, _) -> UIViewController in
            //V视频
            var controller: UIViewController!
            if index == 0 {
                controller = MineVShootVideoController()
                controller.viewWillAppear(true)
            } else {
                controller = MineVVideoShootController()
            }
            addChild(controller);
            return controller;
        }
        let pageView = DNSPageViewManager(style: style, titles: titles, childViewControllers: childViewControllers, startIndex: 0);
        return pageView;
    }();
    
    //MARK: - 更新StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "我的帖子"
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        child
    }
    
    //初始化页面
    private func setupUI() {
        // 单独设置titleView的frame
        let titleView = pageViewManager.titleView;
        view.addSubview(pageViewManager.titleView)
        titleView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview();
            maker.height.equalTo(40 * iPHONE_AUTORATIO);
        }
        
        // 单独设置contentView的大小和位置，可以使用autolayout或者frame
        let contentView = pageViewManager.contentView
        view.addSubview(pageViewManager.contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(40 * iPHONE_AUTORATIO);
        }
    }

}

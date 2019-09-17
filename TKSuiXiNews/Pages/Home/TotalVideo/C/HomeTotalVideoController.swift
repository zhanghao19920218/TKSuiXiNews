//
//  HomeTotalVideoController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import DNSPageView

/*
 * 全部视频的Controller
 */
//PageView的frame
fileprivate let pageViewRect = CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT);
fileprivate let pageViewNormalTitleColor = RGBA(136, 136, 136, 1);
fileprivate let pageViewSelectedTitleColor = RGBA(255, 74, 92, 1);
fileprivate let pageViewFontSize = kFont(16 * iPHONE_AUTORATIO);
//标题栏高度
fileprivate let pageViewTitleHeight = 40 * iPHONE_AUTORATIO;

class HomeTotalVideoController: SXBaseViewController {
    //初始化
    var startIndex:Int = 0
    
    //初始化页面选择器
    lazy var pageViewManager: DNSPageViewManager = {
        let style = DNSPageStyle();
        //可以滑动的ScrollViews
        style.isTitleViewScrollEnabled = true;
        style.titleColor = pageViewNormalTitleColor;
        style.titleSelectedColor = pageViewSelectedTitleColor;
        style.titleFont = pageViewFontSize;
        style.titleViewHeight = pageViewTitleHeight;
        //消除系统默认的offset
        automaticallyAdjustsScrollViewInsets = false
        
        
        // 设置标题内容
        let titles = ["濉溪新闻", "乡音乡事", "政务直通车", "聚焦问政", "旗帜", "法治栏目"];
        
        // 创建每一页对应的controller
        let childViewControllers: [UIViewController] = titles.enumerated().map { (index, _) -> UIViewController in
            //V视频
            var controller: HomeTotalChildVideoController!
            controller = HomeTotalChildVideoController();
            controller.secondModule = titles[index]
            addChild(controller);
            return controller;
        }
        let pageView = DNSPageViewManager(style: style, titles: titles, childViewControllers: childViewControllers, startIndex: startIndex);
        return pageView;
    }()
    
    //MARK: - 更新StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = appThemeColor;
        
        navigationItem.title = "全部视频"
        
        setupUI()
    }
    
    //初始化页面
    private func setupUI() {
        // 单独设置contentView的大小和位置，可以使用autolayout或者frame
        let contentView = pageViewManager.contentView
        view.addSubview(pageViewManager.contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(40 * iPHONE_AUTORATIO);
        }
        
        // 单独设置titleView的frame
        let titleView = pageViewManager.titleView
        //设置阴影
        titleView.layer.shadowOffset = CGSize(width:0 , height: -10)
        titleView.layer.shadowOpacity = 1;
        titleView.layer.shadowRadius = 20;
        titleView.layer.shadowColor = RGBA(0, 0, 0, 0.5).cgColor
        titleView.backgroundColor = .white
        view.addSubview(pageViewManager.titleView)
        titleView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview();
            maker.height.equalTo(40 * iPHONE_AUTORATIO);
        }
        
    }
    
}

//
//  HomeViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import DNSPageView
import FWPopupView
import ZLPhotoBrowser

//PageView的frame
fileprivate let pageViewRect = CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT);
fileprivate let pageViewNormalTitleColor = RGBA(136, 136, 136, 1);
fileprivate let pageViewSelectedTitleColor = RGBA(255, 74, 92, 1);
fileprivate let pageViewFontSize = kFont(16 * iPHONE_AUTORATIO);
//标题栏高度
fileprivate let pageViewTitleHeight = 40 * iPHONE_AUTORATIO;

class HomeViewController: BaseViewController {
    //设置右侧的navigationItem
    private lazy var rightNavigatorItem: BaseNaviRightButton = {
        let button = BaseNaviRightButton(type: .custom);
        button.imageName = "send_home_v_icon"
        button.title = "V视"
        button.frame = CGRect(x: 0, y: 0, width: 30 * iPHONE_AUTORATIO, height: 30 * iPHONE_AUTORATIO)
        button.addTarget(self,
                         action: #selector(didSelectedVVideo),
                         for: .touchUpInside);
        return button;
    }();
    
    
    //初始化页面选择器
    private lazy var pageViewManager: DNSPageViewManager = {
        let style = DNSPageStyle();
        //可以滑动的ScrollViews
        style.isTitleViewScrollEnabled = true;
        style.titleColor = pageViewNormalTitleColor;
        style.titleSelectedColor = pageViewSelectedTitleColor;
        style.titleFont = pageViewFontSize;
        style.titleViewHeight = pageViewTitleHeight;
        
        // 设置标题内容
        let titles = ["V视频", "濉溪TV", "新闻", "视讯", "问政"];
        
        // 创建每一页对应的controller
        let childViewControllers: [UIViewController] = titles.enumerated().map { (index, _) -> UIViewController in
            //V视频
            if index == 0 {
                let controller = HomeVVideoController();
                return controller;
            }
            let controller = UIViewController();
            addChild(controller);
            return controller;
        }
        let pageView = DNSPageViewManager(style: style, titles: titles, childViewControllers: childViewControllers);
        return pageView;
    }();
    
    //轮播右侧的增加按钮
    private lazy var button: UIButton = {
        let button = UIButton.init(type: .custom);
        button.setImage(K_ImageName("add"), for: .normal);
        button.imageEdgeInsets = UIEdgeInsets(top: 6 * iPHONE_AUTORATIO, left: 6 * iPHONE_AUTORATIO, bottom: 6 * iPHONE_AUTORATIO, right: 6 * iPHONE_AUTORATIO);
        button.backgroundColor = .white;
        return button;
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createNavigationBarLogo();
        
        navigationController?.navigationBar.barTintColor = appThemeColor;
        
        setupUI()
        
        configureNavigationBar()
    }
    
    //初始化navigationBar
    private func configureNavigationBar()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigatorItem);
    }
    
    //初始化页面
    private func setupUI() {
        // 单独设置titleView的frame
        let titleView = pageViewManager.titleView;
        view.addSubview(pageViewManager.titleView)
        titleView.snp.makeConstraints { (maker) in
            maker.left.top.equalToSuperview();
            maker.right.equalTo(-40 * iPHONE_AUTORATIO);
            maker.height.equalTo(40 * iPHONE_AUTORATIO);
        }
        
        // 单独设置contentView的大小和位置，可以使用autolayout或者frame
        let contentView = pageViewManager.contentView
        view.addSubview(pageViewManager.contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(40 * iPHONE_AUTORATIO);
        }
        
        //增加更多频道按钮
        view.addSubview(button);
        button.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview();
            make.size.equalTo(CGSize(width: pageViewTitleHeight, height: pageViewTitleHeight));
        }
    }
    
    //MARK: - 点击V视频sheet(title: nil, itemTitles: ["拍摄", "从手机相册选择"], itemBlock: )
    @objc private func didSelectedVVideo(){
        let sheetView = FWSheetView.sheet(title: nil, itemTitles:  ["拍摄", "从手机相册选择"], itemBlock: { [weak self](_, index, _) in
            if index == 0 {
                let camera = ZLCustomCamera();
                camera.doneBlock = { (image, videoUrl) in
                    
                }
                
                self?.present(camera, animated: true, completion: nil);
            }
        })
        sheetView.backgroundColor = RGBA(244, 244, 244, 1);
        sheetView.show()
    }

}

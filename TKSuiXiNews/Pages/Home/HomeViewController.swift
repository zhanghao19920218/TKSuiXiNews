//
//  HomeViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import DNSPageView
import DefaultsKit

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
        //获取用户是不是管理员
        let groupId =  Defaults.shared.get(for: userGroupId)
        if let groupid = groupId, groupid == 2 {
            button.isHidden = false
        } else {
            button.isHidden = true
        }
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
        //消除系统默认的offset
        automaticallyAdjustsScrollViewInsets = false
        
        
        // 设置标题内容
        let titles = ["V视频", "濉溪TV", "新闻", "视讯", "问政", "矩阵", "原创", "悦读", "悦听","公告", "党建", "专栏"];
        
        // 创建每一页对应的controller
        let childViewControllers: [UIViewController] = titles.enumerated().map { (index, _) -> UIViewController in
            //V视频
            var controller: UIViewController!
            if index == 0 {
                //V视频
                controller = HomeVVideoController();
            } else if index == 1 {
                //濉溪TV
                controller = HomeTVViewController()
            } else if index == 2 {
                //濉溪新闻
                controller = HomeNewsListViewController()
            } else if index == 3 {
                //视讯
                controller = HomeVideoNewsListController()
            } else if index == 4 {
                //问政
                controller = HomeAskGovController()
            } else if index == 5 {
                //矩阵
                controller = HomeMatrixListController()
            } else if index == 6 {
                //原创
                controller = HomeOriginalCircleViewController()
            } else if index == 7 {
                //悦读
                controller = HomeHappyReadViewController()
                
            } else if index == 8 {
                //悦听
                controller = HomeHappyListenController()
            } else if index == 9 {
                //公告
                controller = HomeAnnoncementViewController()
            } else if index == 10 {
                //党建
                controller = HomePartyBuildViewController()
            } else if index == 11 {
                //专栏
                controller = HomeSpecialColumnChildController()
            } else {
                controller = UIViewController();
            }
            addChild(controller);
            return controller;
        }
        let pageView = DNSPageViewManager(style: style, titles: titles, childViewControllers: childViewControllers)
        return pageView;
    }()
    
    //MARK: - 更新StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createNavigationBarLogo();
        
        navigationController?.navigationBar.barTintColor = appThemeColor;
        
        setupUI()
        
        configureNavigationBar()
        
        //请求系统参数
        requestSystemConfigure()
    }
    
    //初始化navigationBar
    private func configureNavigationBar()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigatorItem);
        //设置标题为白色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
        let titleView = pageViewManager.titleView;
        view.addSubview(pageViewManager.titleView)
        
        //设置阴影
        titleView.layer.shadowOffset = CGSize(width:0 , height: -10)
        titleView.layer.shadowOpacity = 1;
        titleView.layer.shadowRadius = 20;
        titleView.layer.shadowColor = RGBA(0, 0, 0, 0.5).cgColor
        titleView.backgroundColor = .white
        
        titleView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview()
            maker.height.equalTo(40 * iPHONE_AUTORATIO);
        }

    }
    
    //MARK: - 点击V视频sheet
    @objc private func didSelectedVVideo(){
        YPImagePickerUtil.share.singleVideoPicker();
        YPImagePickerUtil.share.delegate = self
        
    }
    
    //跳转到发送视频页面
    private func jumpVideoDetailVC(videoUrl:String, imageUrl:String, videoLength:Int) {
        let vc = VVideoShootViewController();
        vc.isVideo = true;
        vc.videoImageUrl = imageUrl;
        vc.videoUrl = videoUrl
        vc.videoLength = videoLength;
        vc.isVVideo = true;
        navigationController?.pushViewController(vc, animated: true)
        //发布成功刷新页面
        vc.successBlock = { [weak self] () in
            let vc = self?.children[0] as! HomeVVideoController
            vc.pullDownRefreshData() //刷新页面
        }
    }

}

//MARK: - YPImagePickerUtilDelegate
extension HomeViewController: YPImagePickerUtilDelegate {
    func imagePicker(images: [String], isSuccess: Bool) {
    }
    
    func imagePicker(imageUrl: String, videoUrl: String, videoLength: Int, isSuccess:Bool) {
        if isSuccess {
            //跳转页面
            jumpVideoDetailVC(videoUrl: videoUrl, imageUrl: imageUrl, videoLength: videoLength);
        }
    }
    
    func imagePicker(imageUrl: String, isSuccess: Bool) {
        
    }
}

extension HomeViewController {
    //MARK: - 请求系统参数
    private func requestSystemConfigure() {
        HttpClient.shareInstance.request(target: BAAPI.sysconfigure, success: { (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SystemConfigModel.self, from: json)
            if let cofigure = model {
                Defaults.shared.set(cofigure.data.defaultSearch.string, for: placeholderKey)
            }
        })
    }
    
    //MARK: - 请求标题栏目
    private func requestTitlesInfo() {
        HttpClient.shareInstance.request(target: BAAPI.homePageChannels, success: { (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeChannelListModel.self, from: json)
            if let jsonModel = model {
                
            }
        })
    }
}

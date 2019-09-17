//
//  HomeViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import DNSPageView
//import DefaultsKit

//PageView的frame
fileprivate let pageViewRect = CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT);
fileprivate let pageViewNormalTitleColor = RGBA(136, 136, 136, 1);
fileprivate let pageViewSelectedTitleColor = RGBA(255, 74, 92, 1);
fileprivate let pageViewFontSize = kFont(16 * iPHONE_AUTORATIO);
//标题栏高度
fileprivate let pageViewTitleHeight = 40 * iPHONE_AUTORATIO;

class HomeViewController: SXBaseViewController {
    //设置标题的数据
    private lazy var titles: [String] = {
        return [String]()
    }()
    
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
        if DefaultsKitUtil.share.groupId == 2 {
            button.isHidden = false
        } else {
            button.isHidden = true
        }
        return button;
    }();
    
    
    //初始化页面选择器
    private var pageViewManager: DNSPageView?
    
    //MARK: - 更新StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNaviBarLogo();
        
        navigationController?.navigationBar.barTintColor = appThemeColor;
        
        configureNavigationBar()
        
        requestTitlesInfo()
        
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
    public func setupUI() {
        let style = DNSPageStyle();
        //可以滑动的ScrollViews
        style.isTitleViewScrollEnabled = true;
        style.titleColor = pageViewNormalTitleColor;
        style.titleSelectedColor = pageViewSelectedTitleColor;
        style.titleFont = pageViewFontSize;
        style.titleViewHeight = pageViewTitleHeight;
        //消除系统默认的offset
        automaticallyAdjustsScrollViewInsets = false
        
        // 创建每一页对应的controller
        let childViewControllers: [UIViewController] = titles.enumerated().map { (index, name) -> UIViewController in
            //V视频
            var controller: UIViewController!
            if name == "V视频" {
                //V视频
                controller = HomeVVideoController();
            } else if name == "濉溪TV" {
                //濉溪TV
                controller = HomeTVViewController()
            } else if name == "新闻" {
                //濉溪新闻
                controller = HomeNewsListViewController()
            } else if name == "视讯" {
                //视讯
                controller = HomeVideoNewsListController()
            } else if name == "问政" {
                //问政
                controller = HomeAskGovController()
            } else if name == "新闻网" {
                //矩阵
                controller = HomeMatrixListController()
            } else if name == "原创" {
                //原创
                controller = HomeOriginalCircleViewController()
            } else if name == "悦读" {
                //悦读
                controller = HomeHappyReadViewController()
                
            } else if name == "悦听" {
                //悦听
                controller = HomeHappyListenController()
            } else if name == "公告" {
                //公告
                controller = HomeAnnoncementViewController()
            } else if name == "党建" {
                //党建
                controller = HomePartyBuildViewController()
            } else if name == "专栏" {
                //专栏
                controller = HomeSpecialColumnChildController()
            } else if name == "直播" {
                //直播
                controller = HomeOnlineVideoNewsController()
            } else {
                controller = HomeDefaultListController(name)
            }
            addChild(controller);
            return controller;
        }
        pageViewManager = DNSPageView(frame: CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT - TAB_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT), style: style, titles: titles, childViewControllers: childViewControllers)
//        pageViewManager?.titleView.delegate = self
        view.addSubview(pageViewManager!)

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
                DefaultsKitUtil.share.storeKeyboardPlaceHolder(cofigure.data.defaultSearch.string)
                DefaultsKitUtil.share.storeQRAddress(url: cofigure.data.qrcode.string)
                DefaultsKitUtil.share.storeServerShow(cofigure.data.iosUp.int)
            }
        })
    }
    
    //MARK: - 请求标题栏目
    private func requestTitlesInfo() {
        HttpClient.shareInstance.requestCache(target: BAAPI.homePageChannels, success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeChannelListModel.self, from: json)
            if let jsonModel = model {
                self?.titles = jsonModel.data
                self?.setupUI()
            }
        })
    }
}

extension HomeViewController: DNSPageContentViewDelegate, DNSPageTitleViewDelegate {
    func contentView(_ contentView: DNSPageContentView, didEndScrollAt index: Int) {
        
    }
    
    func contentView(_ contentView: DNSPageContentView, scrollingWith sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        
    }
    
    func titleView(_ titleView: DNSPageTitleView, didSelectAt index: Int) {
//        pageViewManager?.contentView.currentIndex = index
//        //获取用户是不是管理员
//        let groupId =  Defaults.shared.get(for: userGroupId)
//        if let groupid = groupId, groupid == 2 {
//            if index == 0 {
//                rightNavigatorItem.isHidden = false
//            } else {
//                rightNavigatorItem.isHidden = true
//            }
//        }
//        pageViewManager?.childViewControllers
    }
}

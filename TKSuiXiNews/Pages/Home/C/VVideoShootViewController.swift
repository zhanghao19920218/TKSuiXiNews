//
//  VVideoShootViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

/*
 * 录制V视频和拍摄的Controller
 */

fileprivate let fontSize = kFont(14 * iPHONE_AUTORATIO);

class VVideoShootViewController: BaseViewController {
    //左侧的取消按钮,右侧的发表按钮
    private lazy var leftNavigationBarItem: UIButton = {
        let button = UIButton(type: .custom);
        button.setTitle("取消", for: .normal);
        button.titleLabel?.font = fontSize
        button.setTitleColor(.black, for: .normal);
        button.frame = CGRect(x: 0, y: 0, width: 55 * iPHONE_AUTORATIO, height: 30 * iPHONE_AUTORATIO)
        button.addTarget(self,
                         action: #selector(popViewControllerBtnPressed),
                         for: .touchUpInside);
        return button;
    }();
    
    private lazy var rightNavigationBarItem: UIButton = {
        let button = UIButton(type: .custom);
        button.setTitle("发表", for: .normal);
        button.backgroundColor = RGBA(255, 74, 92, 1);
        button.titleLabel?.font = fontSize
        button.frame = CGRect(x: 0, y: 0, width: 55 * iPHONE_AUTORATIO, height: 30 * iPHONE_AUTORATIO)
        return button;
    }();
    
    private lazy var describeTextView: KMPlaceholderTextView = {
        let textView = KMPlaceholderTextView();
        textView.placeholder = "发布内容..."
        textView.font = fontSize;
        return textView;
    }();
    
    //播放的界面
    private lazy var videoPlayerScreen: HomeVVideoBaseView = {
        let view = HomeVVideoBaseView(frame: .zero)
        return view;
    }();
    
    //确定是不是视频
    private lazy var isVideo: Bool = {
        return false
    }();
    
    //显示图片的界面
    private lazy var imagesScreen: HomeVSendCollectionView = {
        let view = HomeVSendCollectionView();
        view.images = []
        return view;
    }();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        navigationController?.navigationBar.barTintColor = appThemeColor;
    }
    
    //初始化NavigationBar
    private func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white;
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftNavigationBarItem);
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigationBarItem);
    }
    
    //初始化页面
    private func setupUI(){
        //初始化描述
        view.addSubview(describeTextView)
        describeTextView.snp.makeConstraints { (make) in
            make.left.equalTo(30 * iPHONE_AUTORATIO);
            make.right.equalTo(-30 * iPHONE_AUTORATIO);
            make.top.equalTo(20 * iPHONE_AUTORATIO);
            make.height.equalTo(110 * iPHONE_AUTORATIO);
        }
        
        if isVideo {
            view.addSubview(videoPlayerScreen)
            videoPlayerScreen.snp.makeConstraints { (make) in
                make.top.equalTo(self.describeTextView.snp_bottom).offset(30 * iPHONE_AUTORATIO);
                make.left.equalTo(30 * iPHONE_AUTORATIO)
                make.right.equalTo(-30 * iPHONE_AUTORATIO)
                make.size.equalTo(CGSize(width: 315 * iPHONE_AUTORATIO, height: 208 * iPHONE_AUTORATIO))
            }
        } else {
            view.addSubview(imagesScreen)
            imagesScreen.snp.makeConstraints { (make) in
                make.top.equalTo(self.describeTextView.snp_bottom).offset(30 * iPHONE_AUTORATIO);
                make.centerX.equalToSuperview();
                make.size.equalTo(CGSize(width: 315 * iPHONE_AUTORATIO, height: 315 * iPHONE_AUTORATIO))
            }
        }
    }

}

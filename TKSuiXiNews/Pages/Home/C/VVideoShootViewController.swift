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

fileprivate let fontSize = kFont(14 * iPHONE_AUTORATIO)

class VVideoShootViewController: BaseViewController {
    //发布完刷新页面
    var successBlock: () -> Void = { }
    
    //判断是不是发V视频
    lazy var isVVideo:Bool = {
        return false;
    }()
    
    //判断到底是照片还是录制视频
    lazy var isVideo: Bool = {
        return false
    }();
    
    //获取视频长度
    lazy var videoLength: Int = {
        return 0;
    }();
    lazy var videoUrl: String = {
        return "";
    }();
    lazy var videoImageUrl: String = {
        return "";
    }();
    
    //获取照片的对象
    lazy var images:[String] = {
        return [String]();
    }()
    
    //获取发表内容的信息
    lazy var describe:String = {
        return "";
    }();
    
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
        button.addTarget(self,
                         action: #selector(didTappedSendVideoButton(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    private lazy var describeTextView: KMPlaceholderTextView = {
        let textView = KMPlaceholderTextView();
        textView.placeholder = "发布内容..."
        textView.font = fontSize;
        textView.delegate = self;
        return textView;
    }();
    
    //播放的界面
    private lazy var videoPlayerScreen: HomeVVideoBaseView = {
        let view = HomeVVideoBaseView(frame: .zero);
        return view
    }();
    
    //显示图片的界面
    private lazy var imagesScreen: HomeVSendCollectionView = {
        let view = HomeVSendCollectionView();
        view.images = []
        //点击选择更多照片
        view.block = { [weak self] () in
            //选择更多照片
            self?.selectedMorePhotos();
        }
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
            
            //更新视图
            videoPlayerScreen.kf.setImage(with: URL(string: videoImageUrl), placeholder: K_ImageName(PLACE_HOLDER_IMAGE));
        } else {
            view.addSubview(imagesScreen)
            imagesScreen.snp.makeConstraints { (make) in
                make.top.equalTo(self.describeTextView.snp_bottom).offset(30 * iPHONE_AUTORATIO);
                make.centerX.equalToSuperview();
                make.size.equalTo(CGSize(width: 315 * iPHONE_AUTORATIO, height: 315 * iPHONE_AUTORATIO))
            }
            
            //更新collection界面
            imagesScreen.images = images
            imagesScreen.deleteBlock = { [weak self] (index) in
                self?.images.remove(at: index)
            }
        }
    }

    //MARK: - 点击发表按钮
    @objc private func didTappedSendVideoButton(_ sender: UIButton) {
        if describe.isEmpty {
            TProgressHUD.show(text: "请输入发表内容");
            return;
        }
        
        
        
        if isVVideo && isVideo {
            HttpClient.shareInstance.request(target: BAAPI.sendVVideoInfo(name: describe, video: videoUrl, image: videoImageUrl, time: videoLength), success: { [weak self] (json) in
                self?.navigationController?.popViewController(animated: true)
                TProgressHUD.show(text: "发表V视频成功")
                self?.successBlock()
                }
            )
        } else if isVideo {
            HttpClient.shareInstance.request(target: BAAPI.addsCausualPhotos(name: describe, video: videoUrl, images: images, image: videoImageUrl, time: videoLength), success: { [weak self] (json) in
                self?.navigationController?.popViewController(animated: true)
                TProgressHUD.show(text: "发表随手拍成功")
                self?.successBlock()
                }
            )
        } else {
            if images.count == 0 {
                TProgressHUD.show(text: "请选择照片")
                return
            }
            
            HttpClient.shareInstance.request(target: BAAPI.addsCausualPhotos(name: describe, video: nil, images: images, image: videoImageUrl, time: videoLength), success: { [weak self] (json) in
                self?.navigationController?.popViewController(animated: true)
                TProgressHUD.show(text: "发表随手拍成功")
                self?.successBlock()
                }
            )
        }
        
        
    }
    
    //MARK: - 选择更多照片
    private func selectedMorePhotos() {
        let maxCount = 9 - images.count; //确定最大的照片数量
        YPImagePickerUtil.share.multiPickerPhotosLibary(maxCount: maxCount);
        YPImagePickerUtil.share.delegate = self;
    }
}


extension VVideoShootViewController: UITextViewDelegate {
    //限制70个字
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 70 {
            if let str = textView.text {
                //截取前20个字符
                let subStr = str.prefix(70)
                textView.text = String(subStr)
                describe = String(subStr)
            }
        } else {
            describe = textView.text ?? ""
        }
    }
}

extension VVideoShootViewController: YPImagePickerUtilDelegate {
    func imagePicker(imageUrl: String, videoUrl: String, videoLength: Int, isSuccess: Bool) {
    }
    
    func imagePicker(imageUrl: String, isSuccess: Bool) {
    }
    
    //选择增加照片
    func imagePicker(images: [String], isSuccess: Bool) {
        //更新照片图库
        self.images += images
        self.imagesScreen.images = self.images;
    }
    
    
}

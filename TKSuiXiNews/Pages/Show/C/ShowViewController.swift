//
//  ShowViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let textImageIdentifier = "ShowImageTextCellIdentifier";
fileprivate let videoIdentifier = "ShowVideoViewCellIdentifier";

/*
 * 随手拍
 */

class ShowViewController: BaseTableViewController {
    //设置右侧的navigationItem
    private lazy var rightNavigatorItem: BaseNaviRightButton = {
        let button = BaseNaviRightButton(type: .custom);
        button.imageName = "send_video_icon"
        button.title = "发布"
        button.frame = CGRect(x: 0, y: 0, width: 30 * iPHONE_AUTORATIO, height: 30 * iPHONE_AUTORATIO)
        button.addTarget(self,
                         action: #selector(rightNavigationBarItemTapped(_:)),
                         for: .touchUpInside);
        return button;
    }();

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
        //设置标题为白色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    //MARK: - 更新StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func loadData() {
        super.loadData();
        
        requestData(); //请求数据
    }
    
    //初始化页面
    private func setupUI() {
        tableView.register(ShowImageTextCell.self, forCellReuseIdentifier: textImageIdentifier);
        tableView.register(ShowVideoViewCell.self, forCellReuseIdentifier: videoIdentifier)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "随手拍", page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(ShowListResponseModel.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.es.stopPullToRefresh();
            self?.tableView.reloadData();
            }, failure:{ [weak self] () in
                self?.tableView.es.stopPullToRefresh();
                self?.tableView.reloadData();
            }
        )
    };
    
    
    override func pullUpLoadMoreData() {
        super.pullUpLoadMoreData()
        
        page = (page == 1 ? 2 : page);
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "随手拍", page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(ShowListResponseModel.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            if forceModel.data.data.count != 0 {
                //页数+1
                self?.page += 1;
                self?.dataSource += forceModel.data.data;
                self?.tableView.es.stopLoadingMore();
                self?.tableView.reloadData();
            } else {
                //没有更多数据
                self?.tableView.es.noticeNoMoreData();
                self?.tableView.reloadData();
            }
            
            }, failure:{ [weak self] () in
                self?.tableView.es.stopLoadingMore();
                self?.tableView.reloadData();
            }
        )
    }

    
    //MARK: - 点击右上角的弹窗
    @objc private func rightNavigationBarItemTapped(_ sender: UIButton) {
        FWPopupViewUtil.share.popAlert()
        FWPopupViewUtil.share.delegate = self;
    }
}

extension ShowViewController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "随手拍", page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(ShowListResponseModel.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.reloadData();
            }
        )
    }
}

extension ShowViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row] as! ShowListItemModel;
        
        if model.images.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: videoIdentifier) as! ShowVideoViewCell;
            cell.describe = model.name.string;
            cell.imageUrl = model.image?.string;
            cell.videoUrl = model.video.string;
            cell.avatar = model.avatar.string;
            cell.nickname = model.nickname.string;
            cell.comment = model.commentNum.string;
            cell.isLike = model.likeStatus.int;
            cell.like = model.likeNum.string;
            cell.videoLength = model.time?.string;
            cell.beginTime = model.begintime.string;
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: textImageIdentifier) as! ShowImageTextCell;
            cell.images = model.images;
            cell.describe = model.name.string;
            cell.avatar = model.avatar.string;
            cell.nickname = model.nickname.string;
            cell.comment = model.commentNum.string;
            cell.isLike = model.likeStatus.int;
            cell.like = model.likeNum.string;
            cell.beginTime = model.begintime.string;
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row] as! ShowListItemModel;
        
        if model.images.isEmpty {
            return 335 * iPHONE_AUTORATIO;
        } else {
            var height:CGFloat = 0;
            if model.images.count <= 3 {
                height = 108 * iPHONE_AUTORATIO;
            } else if model.images.count <= 6 {
                height = 216 * iPHONE_AUTORATIO;
            } else {
                height = 324 * iPHONE_AUTORATIO;
            }
            return 140 * iPHONE_AUTORATIO + height ;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as! ShowListItemModel;
        
        if model.images.count == 0 {
            //进入视频页面
            let vc = DetailVideoInfoController()
            vc.id = model.id.string
            navigationController?.pushViewController(vc, animated: true)
        } else {
            //进入图文页面
            let vc = ShowDetailImageViewController();
            vc.id = model.id.string
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


//MARK: - 点击跳转拍摄V视频和拍照
extension ShowViewController: FWPopupViewUtilDelegate {
    func didSelectedPopIndex(index: Int) {
        if index == 0 {
            YPImagePickerUtil.share.cameraOrVideo();
            YPImagePickerUtil.share.delegate = self
        } else {
            //最大的照片数量
            YPImagePickerUtil.share.multiPickerPhotosLibary(maxCount: 9)
            YPImagePickerUtil.share.delegate = self
        }
    }
}

//MARK: - YPImagePickerUtilDelegate
extension ShowViewController: YPImagePickerUtilDelegate {
    func imagePicker(images: [String], isSuccess: Bool) {
        if isSuccess {
            //跳转页面
            let vc = VVideoShootViewController();
            vc.isVideo = false;
            vc.images = images
            navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    func imagePicker(imageUrl: String, videoUrl: String, videoLength: Int, isSuccess:Bool) {
        print(videoUrl);
        print(imageUrl);
        if isSuccess {
            //跳转页面
            let vc = VVideoShootViewController();
            vc.isVideo = true;
            vc.videoImageUrl = imageUrl;
            vc.videoUrl = videoUrl
            vc.videoLength = videoLength;
            navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    func imagePicker(imageUrl: String, isSuccess: Bool) {
        if isSuccess {
            //跳转页面
            let vc = VVideoShootViewController();
            vc.isVideo = false;
            vc.images = [imageUrl]
            navigationController?.pushViewController(vc, animated: true);
        }
    }
}


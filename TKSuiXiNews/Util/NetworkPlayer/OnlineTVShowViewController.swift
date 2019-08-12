//
//  OnlineTVShowViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import PLPlayerKit

/*
 * 濉溪TV直播的Controller
 */

class OnlineTVShowViewController: BaseViewController {

    //时间的进度
    private var playerTimer: Timer?
    
    //播放器的控制UI
    private lazy var controlView: NEPlayerControlView = {
        let view = NEPlayerControlView()
        view.isRemove = true
        return view;
    }();
    
    //方法内实例化PLPlayOption
    private lazy var option:PLPlayerOption = {
        let option = PLPlayerOption.default()
        option.setOptionValue(15, forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets) //播放器所用 RTMP 连接的超时断开时间长度，单位为秒。小于等于 0 表示无超时限制
        option.setOptionValue(1000, forKey: PLPlayerOptionKeyMaxL1BufferDuration) //一级缓存大小，单位为 ms，默认为 1000ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟。
        option.setOptionValue(1000, forKey: PLPlayerOptionKeyMaxL2BufferDuration) //二级缓存大小，单位为 ms，默认为 1000ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟
        option.setOptionValue(false, forKey: PLPlayerOptionKeyVideoToolbox)  //使用 video toolbox 硬解码
        return option
    }()
    
    //播放器的url
    private var _url:String = "";
    
    //懒加载播放器
    private var player: PLPlayer?
    
    //进度条
    private var timer: DispatchSource?
    
    init(url:String) {
        super.init(nibName: nil, bundle:nil);
        _url = url;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        view.backgroundColor = .black
        
        configurePlayer()
        
    }
    
    //返回如果是横屏先竖屏再返回
    override func popViewControllerBtnPressed() {
        if UIDevice.current.orientation != .portrait {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
        super.popViewControllerBtnPressed()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isTranslucent = true;
        //在视图出现的时候，将allowRotate改为1，
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowrRotate = 1
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        //设置标题为isTransport false
        navigationController?.navigationBar.isTranslucent = false
        //更新标题为默认
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowrRotate = 0
        
        //销毁播放器
        doDestoryPlayer()
    }
    
    //MARK: - 初始化播放器
    private func configurePlayer() {
        //初始化播放器
        player = PLPlayer.init(url: URL(string: _url), option: option)
        print("播放地址: \(_url)")
        player?.delegate = self
        view.addSubview(player!.playerView!);
        player?.playerView?.snp.makeConstraints({ (make) in
            make.left.equalTo(STATUS_BAR_HEIGHT)
            make.right.equalTo(-STATUS_BAR_HEIGHT)
            make.top.equalTo(15 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-15 * iPHONE_AUTORATIO)
        })
        
        //重复播放
        player?.loopPlay = true
        //线程
        player?.delegateQueue = DispatchQueue.main
        
        view.addSubview(controlView)
        controlView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        player?.play()
    }
    
    //MARK: - 摧毁播放器
    private func doDestoryPlayer() {
        player?.stop()
        player = nil;
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}


//MARK: - 支持七牛云播放器的Delegate
extension OnlineTVShowViewController: PLPlayerDelegate {
    // 实现 <PLPlayerDelegate> 来控制流状态的变更
    func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        if state == .statusCaching {
            controlView.startLoading()
        }

        if state == .statusPlaying {
            controlView.stopLoading()
        }
    }
}

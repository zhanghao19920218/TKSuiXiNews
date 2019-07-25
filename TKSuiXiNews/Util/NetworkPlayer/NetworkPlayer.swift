//
//  NetworkPlayer.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/25.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import NELivePlayerFramework

//播放器的Controller
class NetworkPlayerController: BaseViewController {
    //播放器的url
    private var _url:String = "";
    
    //懒加载播放器
    private var player: NELivePlayerController?
    
    //播放视频的界面
    private var playerContainerView: UIView = {
        let view = UIView();
        view.backgroundColor = .black;
        return view;
    }()
    
    
    
    init(url:String) {
        super.init(nibName: nil, bundle:nil);
        _url = url;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("[NELivePlayer Demo] NELivePlayerVC 已经释放！")
        NotificationCenter.default.removeObserver(self);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //设置标题为isTransport false
        navigationController?.navigationBar.isTranslucent = true;
        
        setupUI()
        
        configurePlayer()
        
        doInitPlayerNotification()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        //设置标题为isTransport false
        navigationController?.navigationBar.isTranslucent = false;
        //销毁播放器
        doDestoryPlayer()
    }
    
    //MARK: - 初始化页面
    private func setupUI() {
        //初始化播放图层
        view.addSubview(playerContainerView);
        playerContainerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        
    }
    
    //MARK: - 初始化播放器
    private func configurePlayer() {
        //配置缓存
        let config = NELPUrlConfig()
        config.cacheConfig?.isCache = true
        
        //初始化播放器
        player = try? NELivePlayerController.init(contentURL: URL(string: _url), config: config);
        
        player?.setScalingMode(.none);
        player?.shouldAutoplay = true;
        player?.setHardwareDecoder(true); //用硬编码
        player?.setPauseInBackground(false);
        player?.setPlaybackTimeout(15 * 1000);
        
        player?.prepareToPlay();
        
        playerContainerView.addSubview(player?.view ?? UIView());
        
    }
    
    //MARK: - 初始化播放器通知
    private func doInitPlayerNotification() {
        //准备播放视频
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NELivePlayerDidPreparedToPlay(notification:)),
                                               name: .NELivePlayerDidPreparedToPlay,
                                               object: player);
        //播放状态发生改变
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NELivePlayerPlaybackStateChanged(notification:)),
                                               name: .NELivePlayerPlaybackStateChanged,
                                               object: player);
        
        //播放器加载状态发生改变时的消息通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NeLivePlayerloadStateChanged(notification:)),
                                               name: .NELivePlayerLoadStateChanged,
                                               object: player);
        
        //播放器播放完成
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NELivePlayerPlayBackFinished(notification:)),
                                               name: .NELivePlayerPlaybackFinished,
                                               object: player);
    }
    
    //MARK: - 播放器通知事件
    @objc private func NELivePlayerDidPreparedToPlay(notification: Notification) {
        //准备好播放视频
        print("[NELivePlayer Demo] 收到 NELivePlayerDidPreparedToPlayNotification 通知");
        
        //获取视频信息，主要是为了告诉界面的可视范围，方便字幕显示
        var info: NELPVideoInfo = NELPVideoInfo();
        memset(&info, 0, MemoryLayout.size(ofValue: NELPVideoInfo.self))
        player?.getVideoInfo(&info);
        
        player?.play();
        //开
        player?.setRealTimeListenerWithIntervalMS(500, callback: { (realTime) in
            print("当前时间戳: [\(realTime)]");
        })
        
        //关
        player?.setRealTimeListenerWithIntervalMS(500, callback: nil);
        
        //设置同步播放器
        
    }
    
    //MARK: - 播放状态改变
    @objc private func NELivePlayerPlaybackStateChanged(notification: Notification) {
        print("[NELivePlayer Demo] 收到 NELivePlayerPlaybackStateChangedNotification 通知");
    }
    
    //MARK: - 播放器加载状态改变
    @objc private func NeLivePlayerloadStateChanged(notification: Notification) {
        print("[NELivePlayer Demo] 收到 NELivePlayerLoadStateChangedNotification 通知");
        
        let nelpLoadState = NELPMovieLoadState.playthroughOK;
        
        if nelpLoadState == .playthroughOK {
            print("完成缓冲");
        } else if nelpLoadState == .stalled {
            print("开始缓冲")
        }
    }
    
    //MARK: - 播放器播放完毕后状态改变
    @objc private func NELivePlayerPlayBackFinished(notification: Notification) {
        print("[NELivePlayer Demo] 收到 NELivePlayerPlaybackFinishedNotification 通知");
        
        let alertController:UIAlertController?
        let action: UIAlertAction?
        if let userInfo = notification.userInfo as? [String: Any] {
            if let value = userInfo[NELivePlayerPlaybackDidFinishReasonUserInfoKey] as? Int {
                //比较是不是这些情况
                switch value {
                    //播放结束
                    case NELPMovieFinishReason.playbackEnded.rawValue:
                        print("播放完成");
                        //重复播放
                        player?.prepareToPlay();
                        player?.play();
                case NELPMovieFinishReason.playbackError.rawValue:
                    alertController = UIAlertController.init(title: "注意", message: "播放失败", preferredStyle: .alert);
                    action = UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
                        self?.doDestoryPlayer();
                        self?.navigationController?.popViewController(animated: true);
                    })
                    alertController?.addAction(action!);
                    self.present(alertController!, animated: true, completion: nil);
                    
                default:
                    print("监听失败");
                    break;
                }
            }
        }
        
    }
    
    //MARK: - 摧毁播放器
    private func doDestoryPlayer() {
        player?.shutdown();
        player = nil;
    }
}

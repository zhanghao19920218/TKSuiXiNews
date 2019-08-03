//
//  AudioPlayerSample.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import AVKit
import AVFoundation

class AudioPlayerSample:NSObject {
    static let share = AudioPlayerSample()
    
    private var currentTime:Double = {
        return 0.0
    }()
    
    //播放的地址
    var url:String?  {
        willSet(newValue) {
            if let url = URL(string: newValue ?? "") {
                let item = AVPlayerItem(url: url)
                self.player = AVPlayer(playerItem: item)
            }
        }
        didSet {
            if url != (oldValue ?? ""){
                //重新恢复播放地点
                currentTime = 0.0
            }
        }
    }
    
    private var player: AVPlayer?
    
    private override init() {
        super.init()
        
        setupPlayerNoti()
    }
    
    //MAKR: - 开始播放
    open func play(timeChangeBlock: @escaping (Int) -> Void) {
        //跳转到当前指定时间
        player?.seek(to: CMTime(seconds: currentTime, preferredTimescale: 1))
        player?.play()
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(1.0)), queue: DispatchQueue.main, using: { [weak self](time) in
            //当前播放的时间
            let current = time.seconds
            self?.currentTime = current
            timeChangeBlock(Int(self?.currentTime ?? 0))
        })
    }
    
    //MARK: - 停止播放
    open func pause() -> Int {
        player?.pause()
        return Int(currentTime)
    }
    
    private func setupPlayerNoti(){
        //在准备播放前，通过KVO添加播放状态改变监听
        player?.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        
        player?.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
    }
    
    deinit {
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
        player?.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
    }
    
    //处理KVO回调事件
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let player = player {
                switch player.status {
                case .unknown:
                    print("未知状态")
                case .readyToPlay:
                    print("准备播放")
                case .failed:
                    print("加载失败")
                default:
                    break
                }
            }
        }
        
        if keyPath == "loadedTimeRanges" {
            let timeRanges = player?.currentItem?.loadedTimeRanges;
            //本次缓冲的时间范围
            let timeRange = timeRanges?.first?.timeRangeValue
            //缓冲总长度
            let totalLoadTime = timeRange?.start.seconds ?? 0.0 + (timeRange?.duration.seconds ?? 0.0)
            //音乐的总时间
            let duration = player?.currentItem?.duration.seconds ?? 1
            //计算缓冲百分比例
            let scale = totalLoadTime/duration
        }
    }
}

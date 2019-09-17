//
//  BoardCastAudioPlayerCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import PLPlayerKit //播放器

class SXBoardCastAudioPlayerCell: BaseTableViewCell {
    ///懒加载播放器
    private var _player: PLPlayer?
    
    ///封面图片的地址
    var audioImageUrl: String? {
        willSet(newValue) {
            if let value = newValue {
                _audioImageView.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    ///播放器的url
    var audioPlayerUrl:String? {
        willSet(newValue) {
            //初始化播放器
            _player = PLPlayer.init(url: URL(string: newValue ?? ""), option: option)
            print("播放地址: \(audioPlayerUrl)")
            _player?.delegate = self
            //线程
            _player?.delegateQueue = DispatchQueue.main
        }
    }

    //方法内实例化PLPlayOption
    private lazy var option:PLPlayerOption = {
        let option = PLPlayerOption.default()
        option.setOptionValue(15, forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets) //播放器所用 RTMP 连接的超时断开时间长度，单位为秒。小于等于 0 表示无超时限制
        option.setOptionValue(1000, forKey: PLPlayerOptionKeyMaxL1BufferDuration) //一级缓存大小，单位为 ms，默认为 1000ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟。
        option.setOptionValue(1000, forKey: PLPlayerOptionKeyMaxL2BufferDuration) //二级缓存大小，单位为 ms，默认为 1000ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟
        option.setOptionValue(false, forKey: PLPlayerOptionKeyVideoToolbox)  //使用 video toolbox 硬解码
        return option
    }()
    
    ///播放器封面背景
    private lazy var _audioImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    ///播放器的按钮
    private lazy var _playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(K_ImageName("video_pause_btn"), for: .selected)
        button.setImage(K_ImageName("video_play_btn"), for: .normal)
        button.addTarget(self,
                         action: #selector(_playAudioButtonPressed(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_audioImageView)
        _audioImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(_playButton)
        _playButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 27 * iPHONE_AUTORATIO, height: 30 * iPHONE_AUTORATIO))
        }
    }
    
    deinit {
        //销毁播放器
        doDestoryPlayer()
    }

    /// - 摧毁播放器
    private func doDestoryPlayer() {
        _player?.stop()
        _player = nil;
    }
    
    /// 初始化播放器
//    private func configurePlayer() {
//        //初始化播放器
//        player = PLPlayer.init(url: URL(string: audioPlayerUrl), option: option)
//        print("播放地址: \(audioPlayerUrl)")
//        player?.delegate = self
//        //线程
//        player?.delegateQueue = DispatchQueue.main
//
//        player?.play()
//    }
    
    /// 点击播放音频的按钮
    @objc private func _playAudioButtonPressed(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            if let _ = _player {
                _player?.stop()
            }
        } else {
            sender.isSelected = true
            if let _ = _player {
                _player?.play()
            }
        }
    }
}

extension SXBoardCastAudioPlayerCell: PLPlayerDelegate {
    
}

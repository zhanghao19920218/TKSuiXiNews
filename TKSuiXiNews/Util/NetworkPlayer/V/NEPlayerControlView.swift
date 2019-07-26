//
//  NEPlayerControlView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/26.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

protocol NEPlayerControlViewDelegate {
    //点击更新播放和暂停按钮
    func controlViewOnClickPlay(_ controlView: NEPlayerControlView, isPlay: Bool)
    
    //点击更新播放进度条
    func controlViewOnClickSeek(_ controlView: NEPlayerControlView, dstTime:Float)
}

class NEPlayerControlView: UIView {
    var delegate: NEPlayerControlViewDelegate?
    
    //设置总时长
    var duration: TimeInterval? {
        willSet(value) {
            if let value = value {
                let time = secondsToHoursMinutesSeconds(seconds: Int(value));
                durationTimeLabel.text = "\(time.hour):\(time.min):\(time.sec)"
                videoProgress.maximumValue = Float(value);
            } else {
                videoProgress.maximumValue = 0
            }
        }
    }
    
    //当前的时间
    var currentPos: TimeInterval? {
        willSet(value) {
            if let value = value {
                videoProgress.value = Float(value);
//                let time = secondsToHoursMinutesSeconds(seconds: Int(value));
//                durationTimeLabel.text = "\(time.hour):\(time.min):\(time.sec)"
//                videoProgress.maximumValue = Float(value);
            } else {
                videoProgress.value = 0;
            }
        }
    }
    
    private var isDragging:Bool {
        get {
            return false;
        }
    }
    
    //增加控制点击的效果
    private lazy var control: UIControl = {
        let control = UIControl();
        control.addTarget(self,
                          action: #selector(tappedControlView),
                          for: .touchUpInside);
        return control;
    }();
    
    //确定是不是隐藏
    private lazy var isControlHidden:Bool = {
        return true;
    }();
    
    //设置爱奇艺按钮
    private lazy var playButton: LYCopyQIYButton = {
        let button = LYCopyQIYButton(frame: CGRect(x: K_SCREEN_WIDTH/2 - 15 * iPHONE_AUTORATIO , y: K_SCREEN_HEIGHT/2 - 15 * iPHONE_AUTORATIO, width: 30 * iPHONE_AUTORATIO, height: 30 * iPHONE_AUTORATIO), color: .white)
        button.isHidden = true;
        button.addTarget(self,
                         action: #selector(tappedPlayOrPause(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    //总时间
    private lazy var durationTimeLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(14 * iPHONE_AUTORATIO);
        label.textColor = .white;
        label.text = "--:--"
        return label;
    }();
    
    
    //播放器进度条
    private lazy var videoProgress: UISlider = {
        let slide = UISlider();
        slide.tintColor = appThemeColor
        slide.isHidden = true;
        slide.setMaximumTrackImage(K_ImageName("btn_player_slider_all"), for: .normal);
        slide.setMinimumTrackImage(K_ImageName("btn_player_slider_played"), for: .normal);
        slide.addTarget(self, action: #selector(onClickSeekTouchUpOutside(_:)), for: .touchUpOutside)
        return slide;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化页面
    private func setupUI(){
        backgroundColor = RGBA(51, 51, 51, 0.3);
        
        addSubview(control);
        control.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview();
            make.bottom.equalTo(-60 * iPHONE_AUTORATIO);
        }
        
        addSubview(playButton);
        
        
        //进度条按钮
        addSubview(videoProgress)
        videoProgress.snp.makeConstraints { (make) in
            make.left.equalTo(10 * iPHONE_AUTORATIO);
            make.right.equalTo(-10 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-50 * iPHONE_AUTORATIO);
            make.height.equalTo(5);
        }
        
        //总时间
        addSubview(durationTimeLabel);
        durationTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15 * iPHONE_AUTORATIO);
            make.bottom.equalTo(self.videoProgress.snp_top).offset(-10 * iPHONE_AUTORATIO);
        }
    }
    
    //MARK: - 点击跳转控制文件
    @objc private func tappedControlView(){
        isControlHidden = !isControlHidden;
        
        playButton.isHidden = isControlHidden;
        videoProgress.isHidden = isControlHidden;
    }
    
    //MARK: - 点击播放还是暂停
    @objc private func tappedPlayOrPause(_ sender: LYCopyQIYButton) {
        if let delegate = delegate {
            delegate.controlViewOnClickPlay(self, isPlay: sender.isSelected);
        }
    }
    
    //MARK: - 更新进度条
    @objc private func onClikcSeekAction(_ slider: UISlider) {
        let currentPlayTime = slider.value;
        let mCurrentPosition = Int(currentPlayTime);
        
    }
    
    //MARK: - 点击更新进度条
    @objc private func onClickSeekTouchUpOutside(_ slider: UISlider) {
        if let delegate = delegate {
            delegate.controlViewOnClickSeek(self, dstTime: slider.value)
        }
    }
    
    //MARK: - 移动进度条
    @objc private func onClickSeekAction(_ slider: UISlider) {
        let currentPlayTime = slider.value;
    }
    
    //MARK: - 讲TimeInterval转为小时
    func secondsToHoursMinutesSeconds(seconds : Int) -> (hour:String, min:String, sec: String) {
        return (seconds / 3600 < 10 ? "0\(seconds / 3600)" : "\(seconds / 3600)",
            (seconds % 3600) / 60 < 10 ? "0\((seconds % 3600) / 60)" : "\((seconds % 3600) / 60)",
            (seconds % 3600) % 60 < 10 ? "0\((seconds % 3600) % 60)" : "\((seconds % 3600) % 60)")
    }
}

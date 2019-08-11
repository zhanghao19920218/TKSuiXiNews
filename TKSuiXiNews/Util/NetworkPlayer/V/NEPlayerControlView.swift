//
//  NEPlayerControlView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/26.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CoreMedia

protocol NEPlayerControlViewDelegate {
    //点击更新播放和暂停按钮
    func controlViewOnClickPlay(_ controlView: NEPlayerControlView, isPlay: Bool)
    
    //点击更新播放进度条
    func controlViewOnClickSeek(_ controlView: NEPlayerControlView, dstTime:Float)
    
    //拖动更新界面进度
    func controlViewOnSeekTouch(_ controlView: NEPlayerControlView, dstTime:CMTime)
}

class NEPlayerControlView: UIView {
    var delegate: NEPlayerControlViewDelegate?
    
    var isRemove: Bool? {
        willSet(newValue) {
            if let value = newValue, value {
                playButton.removeFromSuperview()
                durationTimeLabel.removeFromSuperview()
                currentTimeLabel.removeFromSuperview()
                slider.removeFromSuperview()
                videoProgress.removeFromSuperview()
            }
        }
    }
    
    //设置总时长
    var duration: TimeInterval? {
        willSet(value) {
            if let value = value {
                let time = secondsToHoursMinutesSeconds(seconds: Int(value));
                durationTimeLabel.text = "\(time.hour):\(time.min):\(time.sec)"
            }
        }
    }
    
    //当前的时间
    var currentPos: TimeInterval? {
        willSet(value) {
            if let value = value {
                slider.value = Float(value);
                let time = secondsToHoursMinutesSeconds(seconds: Int(value));
                currentTimeLabel.text = "\(time.hour):\(time.min):\(time.sec)"
                videoProgress.progress = Float((value / (duration ?? 1)))
            }
        }
    }
    
    private var isDragging:Bool {
        get {
            return false;
        }
    }
    
    //设置当前加载的动画
    private lazy var cacheLoading: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .white)
        return view
    }()
    
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
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true;
        button.setSelectedImage("video_play_btn")
        button.setImage("video_pause_btn")
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
        return label
    }();
    
    //目前播放的时间
    private lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(14 * iPHONE_AUTORATIO);
        label.textColor = .white;
        label.text = "--:--"
        return label
    }()
    
    //设置slider
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.isContinuous = false
        slider.setThumbImage(K_ImageName("slider_thumb"), for: .normal)
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = appThemeColor
        slider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
        return slider
    }()
    
    
    //播放器进度条
    private lazy var videoProgress: UIProgressView = {
        let slide = UIProgressView();
        slide.tintColor = appThemeColor
        slide.isHidden = true;
//        slide.setThumbImage(K_ImageName("btn_player_slider_thumb"), for: .normal);
//        slide.setMaximumTrackImage(K_ImageName("btn_player_slider_all"), for: .normal);
//        slide.setMinimumTrackImage(K_ImageName("btn_player_slider_played"), for: .normal);
//        slide.addTarget(self, action: #selector(onClickSeekTouchUpOutside(_:)), for: .touchUpInside)
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
        playButton.snp.makeConstraints { (make) in
            make.left.equalTo(5 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-30 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 40 * iPHONE_AUTORATIO, height: 40 * iPHONE_AUTORATIO))
        }
        
        //加载框
        addSubview(cacheLoading)
        cacheLoading.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 50 * iPHONE_AUTORATIO, height: 50 * iPHONE_AUTORATIO))
        }
        
        //进度条按钮
        addSubview(videoProgress)
        videoProgress.snp.makeConstraints { (make) in
            make.left.equalTo(50 * iPHONE_AUTORATIO);
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
        
        //目前的时间
        addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO + STATUS_BAR_HEIGHT)
            make.bottom.equalTo(self.videoProgress.snp_top).offset(-10 * iPHONE_AUTORATIO)
        }
        
        addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(50 * iPHONE_AUTORATIO);
            make.right.equalTo(-10 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-50 * iPHONE_AUTORATIO);
            make.height.equalTo(5);
        }
    }
    
    //MARK: - 缓冲加载
    func startLoading() {
        cacheLoading.startAnimating()
    }
    
    //MARK: - 缓冲加载完成
    func stopLoading() {
        cacheLoading.stopAnimating()
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
            sender.isSelected = !sender.isSelected
        }
    }
    
    //MARK: - 更新进度条
    @objc private func onClikcSeekAction(_ slider: UISlider) {
        let currentPlayTime = slider.value;
        let mCurrentPosition = Int(currentPlayTime);
        
    }
    
    //MARK: - 点击更新进度条
    @objc private func onClickSeekTouchUpOutside(_ slider: UISlider) {
        print("更新进度条");
        if let delegate = delegate {
            delegate.controlViewOnClickSeek(self, dstTime: slider.value)
        }
    }
    
    @objc private func sliderValueChange() {
        if let delegate = delegate {
            delegate.controlViewOnSeekTouch(self, dstTime: CMTimeMake(value: Int64(self.slider.value * 1000), timescale: 1000))
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

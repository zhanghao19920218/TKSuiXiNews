//
//  DetailHappyMusicListenCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/3.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 悦听详细的Cell
 */
fileprivate let fontSize = kFont(13 * iPHONE_AUTORATIO)
fileprivate let fontColor = RGBA(153, 153, 153, 1)

class SXDetailHappyMusicListenCell: BaseTableViewCell {
    var block:(Bool)->Void = { _ in }
    
    var title:String? {
        willSet(newValue) {
            _titleLabel.text = newValue ?? ""
        }
    }
    
    var writer: String? {
        willSet(newValue) {
            _writerNameLabel.text = newValue ?? ""
        }
    }
    
    var time:String? {
        willSet(newValue) {
            _timeLabel.text = newValue ?? "0小时前"
        }
    }
    
    var review: Int? {
        willSet(newValue) {
            _listenNumLabel.text = "\(newValue ?? 0)"
        }
    }
    
    var musicLength:Int? {
        willSet(newValue) {
            if let value = newValue {
                let result = value.secondsToHoursMinutesSeconds()
                _audioPlayLabel.text = "\(result.min):\(result.sec)"
            }
        }
    }
    
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        return label
    }()
    
    private lazy var _writerNameLabel:UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        return label
    }()
    
    private lazy var _timeLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        return label
    }()
    
    private lazy var _listenNumLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        label.text = "0"
        return label
    }()
    
    private lazy var _listenIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("audio_list_icon")
        return imageView
    }()
    
    //音频播放的背景
    private lazy var _videoPlayerBack: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        view.backgroundColor = RGBA(255, 237, 238, 1)
        return view
    }()
    
    //音频的图标
    private lazy var _audioIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("audio_play_indi_icon")
        return imageView
    }()
    
    //音频播放的时间
    private lazy var _audioPlayLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBA(255, 74, 92, 1)
        label.text = "0"
        label.font = kBoldFont(12 * iPHONE_AUTORATIO)
        return label
    }()
    
    //音频播放的UIButton
    private lazy var _playVideoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage("audio_music_play")
        button.setSelectedImage("audio_play_pause")
        button.imageEdgeInsets = UIEdgeInsets(top: 14.5 * iPHONE_AUTORATIO, left: 29 * iPHONE_AUTORATIO, bottom: 14.5 * iPHONE_AUTORATIO, right: 0)
        button.addTarget(self,
                         action: #selector(didTappedPlayerButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(25 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_writerNameLabel)
        _writerNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(93 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_listenNumLabel)
        _listenNumLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.centerY.equalTo(_writerNameLabel.snp_centerY)
        }
        
        contentView.addSubview(_listenIcon)
        _listenIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(_writerNameLabel.snp_centerY)
            make.right.equalTo(_listenNumLabel.snp_left).offset(-8 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 14 * iPHONE_AUTORATIO, height: 10 * iPHONE_AUTORATIO))
        }
        
        contentView.addSubview(_timeLabel)
        _timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(_writerNameLabel.snp_centerY)
            make.right.equalTo(_listenIcon.snp_left).offset(-27 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_videoPlayerBack)
        _videoPlayerBack.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(130 * iPHONE_AUTORATIO)
            make.height.equalTo(44 * iPHONE_AUTORATIO)
        }
        
        _videoPlayerBack.addSubview(_audioIcon)
        _audioIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 18 * iPHONE_AUTORATIO, height: 14 * iPHONE_AUTORATIO))
        }
        
        _videoPlayerBack.addSubview(_audioPlayLabel)
        _audioPlayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(44 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
        }
        
        _videoPlayerBack.addSubview(_playVideoButton)
        _playVideoButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 44 * iPHONE_AUTORATIO, height: 44 * iPHONE_AUTORATIO))
        }
    }
    
    @objc private func didTappedPlayerButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        block(sender.isSelected)
    }
}

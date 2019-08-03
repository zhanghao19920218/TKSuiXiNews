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

class DetailHappyMusicListenCell: BaseTableViewCell {
    var block:(Bool)->Void = { _ in }
    
    var title:String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? ""
        }
    }
    
    var writer: String? {
        willSet(newValue) {
            writerNameLabel.text = newValue ?? ""
        }
    }
    
    var time:String? {
        willSet(newValue) {
            timeLabel.text = newValue ?? "0小时前"
        }
    }
    
    var review: Int? {
        willSet(newValue) {
            listenNumLabel.text = "\(newValue ?? 0)"
        }
    }
    
    var musicLength:Int? {
        willSet(newValue) {
            audioPlayLabel.text = "\(newValue ?? 0)"
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        return label
    }()
    
    private lazy var writerNameLabel:UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        return label
    }()
    
    private lazy var listenNumLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        label.text = "0"
        return label
    }()
    
    private lazy var listenIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("audio_list_icon")
        return imageView
    }()
    
    //音频播放的背景
    private lazy var videoPlayerBack: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        view.backgroundColor = RGBA(255, 237, 238, 1)
        return view
    }()
    
    //音频的图标
    private lazy var audioIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("audio_play_indi_icon")
        return imageView
    }()
    
    //音频播放的时间
    private lazy var audioPlayLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBA(255, 74, 92, 1)
        label.text = "0"
        label.font = kBoldFont(12 * iPHONE_AUTORATIO)
        return label
    }()
    
    //音频播放的UIButton
    private lazy var playVideoButton: UIButton = {
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
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(25 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(writerNameLabel)
        writerNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(93 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(listenNumLabel)
        listenNumLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.centerY.equalTo(writerNameLabel.snp_centerY)
        }
        
        contentView.addSubview(listenIcon)
        listenIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(writerNameLabel.snp_centerY)
            make.right.equalTo(listenNumLabel.snp_left).offset(-8 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 14 * iPHONE_AUTORATIO, height: 10 * iPHONE_AUTORATIO))
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(writerNameLabel.snp_centerY)
            make.right.equalTo(listenIcon.snp_left).offset(-27 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(videoPlayerBack)
        videoPlayerBack.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(130 * iPHONE_AUTORATIO)
            make.height.equalTo(44 * iPHONE_AUTORATIO)
        }
        
        videoPlayerBack.addSubview(audioIcon)
        audioIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 18 * iPHONE_AUTORATIO, height: 14 * iPHONE_AUTORATIO))
        }
        
        videoPlayerBack.addSubview(audioPlayLabel)
        audioPlayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(44 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
        }
        
        videoPlayerBack.addSubview(playVideoButton)
        playVideoButton.snp.makeConstraints { (make) in
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

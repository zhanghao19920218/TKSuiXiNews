//
//  HomeHappyListenCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 悦听列表
 */
fileprivate let fontSize = kFont(13 * iPHONE_AUTORATIO)
fileprivate let fontColor = RGBA(153, 153, 153, 1)

class HomeHappyListenCell: BaseTableViewCell {
    var block:(Bool)->Void = { _ in }
    
    var title:String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? ""
        }
    }
    
    var audioLength: Int? {
        willSet(newValue) {
            audioPlayLabel.text = "\(newValue ?? 0)"
        }
    }
    
    var isPlay: Bool? {
        willSet(newValue) {
            playVideoButton.isSelected = newValue ?? false
        }
    }
    
    var beginTime: String? {
        willSet(newValue) {
            timeLabel.text = newValue ?? "0小时前"
        }
    }
    
    var review:Int? {
        willSet(newValue) {
            audioTimesLabel.text = "\(newValue ?? 0)"
        }
    }
    
    var likeNum:Int? {
        willSet(newValue) {
            likeNumLabel.text = "\(newValue ?? 0)"
        }
    }
    
    var isLike: Int? {
        willSet(value) {
            if let bool = value {
                isLikeIcon.image = K_ImageName(bool == 1 ? "like_list_icon" : "dislike_list_icon");
            }
        }
    }

    //背景
    private lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        view.backgroundColor = .white
        return view
    }()
    
    //标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
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
        label.font = fontSize
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
    
    //时间的icon
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        label.text = "0小时前"
        return label
    }()
    
    //音频的icon
    private lazy var audioListIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("audio_list_icon")
        return imageView
    }()
    
    private lazy var audioTimesLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        label.text = "0"
        return label
    }()
    
    //点赞的icon
    private lazy var isLikeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("dislike_list_icon")
        return imageView
    }()
    
    private lazy var likeNumLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        label.text = "0"
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.backgroundColor = RGBA(245, 245, 245, 1)
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(10 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-10 * iPHONE_AUTORATIO)
        }
        
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
        }
        
        backView.addSubview(videoPlayerBack)
        videoPlayerBack.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(71 * iPHONE_AUTORATIO)
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
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 44 * iPHONE_AUTORATIO, height: 44 * iPHONE_AUTORATIO))
        }
        
        backView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-14 * iPHONE_AUTORATIO)
        }
        
        backView.addSubview(likeNumLabel)
        likeNumLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.centerY.equalTo(timeLabel.snp_centerY)
        }
        
        backView.addSubview(isLikeIcon)
        isLikeIcon.snp.makeConstraints { (make) in
            make.right.equalTo(likeNumLabel.snp_left).offset(-5 * iPHONE_AUTORATIO)
            make.centerY.equalTo(timeLabel.snp_centerY)
            make.size.equalTo(CGSize(width: 11 * iPHONE_AUTORATIO, height: 11 * iPHONE_AUTORATIO))
        }
        
        backView.addSubview(audioTimesLabel)
        audioTimesLabel.snp.makeConstraints { (make) in
            make.right.equalTo(isLikeIcon.snp_left).offset(-25 * iPHONE_AUTORATIO)
            make.centerY.equalTo(timeLabel.snp_centerY)
        }
        
        backView.addSubview(audioListIcon)
        audioListIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel.snp_centerY)
            make.right.equalTo(audioTimesLabel.snp_left).offset(-8 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 14 * iPHONE_AUTORATIO, height: 10 * iPHONE_AUTORATIO))
        }
    }
    
    @objc private func didTappedPlayerButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        block(isPlay ?? true)
    }
}

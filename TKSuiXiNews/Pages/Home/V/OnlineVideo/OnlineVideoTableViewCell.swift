//
//  OnlineVideoTableViewCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let fontSize = kFont(14 * iPHONE_AUTORATIO)

class OnlineVideoTableViewCell: BaseTableViewCell {
    ///视频时间
    var time: String? {
        willSet(newValue) {
            _timeLabel.text = newValue ?? "0小时前"
        }
    }
    
    ///视频标题
    var title: String? {
        willSet(newValue) {
            _titleLabel.text = newValue ?? ""
        }
    }
    
    ///视频封面
    var videoImageUrl: String? {
        willSet(newValue) {
            if let value = newValue {
                _playItem.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    ///视频的浏览量
    var reviewNum: Int? {
        willSet(newValue) {
            _reviewLabel.text = "\(newValue ?? 0)"
        }
    }
    
    ///点击播放视频的bLOCK
    var playVideoBlock: () -> Void = { }

    //直播的标签
//    private lazy var _statusLabel: UILabel = {
//        let label = UILabel()
//        label.text = "直播"
//        label.font = fontSize
//        label.textColor = RGBA(255, 74, 92, 1)
//        return label
//    }()
    
    //横线
//    private lazy var _line: UIView = {
//        let view = UIView()
//        view.backgroundColor = RGBA(204, 204, 204, 1)
//        return view
//    }()

    ///标题
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        return label
    }()
    
    ///显示的播放器界面
    private lazy var _playItem: HomeVVideoBaseView = {
        let view = HomeVVideoBaseView(frame: .zero)
        view.isUserInteractionEnabled = true
        view.videoBlock = { [weak self] in
            self?.playVideoBlock()
        }
        return view
    }()
    
    ///下方的时间
    private lazy var _timeLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.text = "0小时前"
        label.textColor = RGBA(153, 153, 153, 1)
        return label
    }()
    
    ///下方的浏览Icon
    private lazy var _reviewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("view_list_icon")
        return imageView
    }()
    
    ///浏览数量的Label
    private lazy var _reviewLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        label.text = ""
        return label
    }()
    
    ///下方显示的BottomView
    private lazy var _bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(244, 244, 244, 1)
        return view
    }()
    
    ///初始化
    override func setupUI() {
        super.setupUI()
        
//        contentView.addSubview(_statusLabel)
//        _statusLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(13 * iPHONE_AUTORATIO)
//            make.top.equalTo(20 * iPHONE_AUTORATIO)
//        }
//
//        contentView.addSubview(_line)
//        _line.snp.makeConstraints { (make) in
//            make.centerY.equalTo(_statusLabel.snp_centerY)
//            make.left.equalTo(80 * iPHONE_AUTORATIO)
//            make.size.equalTo(CGSize(width: 1, height: 15 * iPHONE_AUTORATIO))
//        }
//
        contentView.addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20 * iPHONE_AUTORATIO)
            make.left.equalTo(16 * iPHONE_AUTORATIO)
            make.right.equalTo(-16 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_playItem)
        _playItem.snp.makeConstraints { (make) in
            make.top.equalTo(53 * iPHONE_AUTORATIO)
            make.left.equalTo(14 * iPHONE_AUTORATIO)
            make.right.equalTo(-14 * iPHONE_AUTORATIO)
            make.height.equalTo(188 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_timeLabel)
        _timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(_playItem.snp_bottom).offset(15 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_reviewLabel)
        _reviewLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.centerY.equalTo(_timeLabel.snp_centerY)
        }
        
        contentView.addSubview(_reviewIcon)
        _reviewIcon.snp.makeConstraints { (make) in
            make.right.equalTo(_reviewLabel.snp_left).offset(-8 * iPHONE_AUTORATIO)
            make.centerY.equalTo(_timeLabel.snp_centerY)
            make.size.equalTo(CGSize(width: 15 * iPHONE_AUTORATIO, height: 10 * iPHONE_AUTORATIO))
        }
        
        contentView.addSubview(_bottomView)
        _bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(10 * iPHONE_AUTORATIO)
        }
    }
}

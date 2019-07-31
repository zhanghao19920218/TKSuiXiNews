//
//  HomeMatrixSectionHeaderView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class HomeMatrixSectionHeaderView: UIView {
    var name:String? {
        willSet(newValue) {
            nameLabel.text = newValue ?? ""
        }
    }
    
    var time:String? {
        willSet(newValue) {
            timeLabel.text = newValue ?? "0000年0月0日"
        }
    }
    
    //头像
    private lazy var avatarImg: BaseAvatarImageView = {
        let imageView = BaseAvatarImageView(frame: .zero)
        return imageView
    }()
    
    //名称
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        return label
    }()
    
    //时间
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(12 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        return label
    }()
    
    //指示器
    private lazy var indicatorImg: UIImageView = {
        let imageView = UIImageView();
        imageView.image = K_ImageName("more_news_indicator")
        return imageView;
    }()
    
    //上面的背景
    private lazy var _topView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(245, 245, 245, 1)
        return view
    }()
    
    private lazy var _bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(244, 244, 244, 1)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化页面
    private func _setupUI() {
        backgroundColor = .white
        
        addSubview(_topView)
        _topView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(15 * iPHONE_AUTORATIO)
        }
        
        addSubview(avatarImg)
        avatarImg.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(30 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 42 * iPHONE_AUTORATIO, height: 42 * iPHONE_AUTORATIO))
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(65 * iPHONE_AUTORATIO)
            make.top.equalTo(32 * iPHONE_AUTORATIO)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(65 * iPHONE_AUTORATIO)
            make.top.equalTo(58 * iPHONE_AUTORATIO)
        }
        
        addSubview(indicatorImg)
        indicatorImg.snp.makeConstraints { (make) in
            make.right.equalTo(-25 * iPHONE_AUTORATIO)
            make.centerY.equalTo(avatarImg.snp_centerY)
            make.size.equalTo(CGSize(width: 8 * iPHONE_AUTORATIO, height: 14 * iPHONE_AUTORATIO))
        }
        
        addSubview(_bottomLine)
        _bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

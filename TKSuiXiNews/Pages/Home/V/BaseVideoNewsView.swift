//
//  BaseVideoNewsView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class BaseVideoNewsView: UIImageView {
    //播放时间
    var timeLength: String? {
        willSet(newValue) {
            timeLabel.text = newValue ?? "00:00"
        }
    }
    
    
    //增加视频的时间
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(9 * iPHONE_AUTORATIO)
        label.textColor = .white
        label.text = "00:00"
        label.textAlignment = .center
        return label
    }()
    
    //视频的播放
    private lazy var timeBackView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(0, 0, 0, 0.5)
        view.layer.cornerRadius = 3 * iPHONE_AUTORATIO
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _setupUI() {
        addSubview(timeBackView)
        timeBackView.snp.makeConstraints { (make) in
            make.right.equalTo(-10 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-5 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 35 * iPHONE_AUTORATIO, height: 15 * iPHONE_AUTORATIO))
        }
        
        timeBackView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
}

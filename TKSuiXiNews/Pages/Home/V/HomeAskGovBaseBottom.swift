//
//  HomeAskGovBaseBottom.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 问政下方的评论和时间
 */
fileprivate let fontSize = kFont(13 * iPHONE_AUTORATIO)
fileprivate let fontColor = RGBA(153, 153, 153, 1)

class HomeAskGovBaseBottom: UIView {
    //时间
    var time: String? {
        willSet(newValue) {
            _timeLabel.text = newValue ?? "0小时前"
        }
    }
    
    //评论数量
    var comment: Int? {
        willSet(newValue) {
            _commentNumL.text = "\(newValue ?? 0)"
        }
    }
    
    
    //时间
    private lazy var _timeLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
//        label.text = "0小时前"
        return label
    }()
    
    //评论的icon
    private lazy var _commentIcon: UIImageView = {
        let imageView = UIImageView();
        imageView.image = K_ImageName("comment_list_icon")
        return imageView
    }()
    
    //评论数量
    private lazy var _commentNumL: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = fontColor
        label.text = "0"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(_timeLabel)
        _timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
        }
        
        addSubview(_commentNumL)
        _commentNumL.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
        }
        
        addSubview(_commentIcon)
        _commentIcon.snp.makeConstraints { (make) in
            make.right.equalTo(_commentNumL.snp_left).offset(-8 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 13 * iPHONE_AUTORATIO, height: 12 * iPHONE_AUTORATIO))
        }
    }
}

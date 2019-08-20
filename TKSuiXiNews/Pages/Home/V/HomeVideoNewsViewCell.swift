//
//  HomeVideoNewsViewCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 视讯Cell
 */
class HomeVideoNewsViewCell: BaseTableViewCell {
    var title:String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? "";
        }
    }
    
    var timeLength: Int = 0{
        willSet(newValue) {
            let result = newValue.secondsToHoursMinutesSeconds()
            videoImg.timeLength = "\(result.min):\(result.sec)"
        }
    }
    
    var imageName: String? {
        willSet(newValue) {
            if let value = newValue {
                videoImg.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    var time:String? {
        willSet(newValue) {
            bottomView.time = newValue
        }
    }
    
    var review: Int? {
        willSet(newValue) {
            bottomView.review = newValue
        }
    }
    
    var like: Int? {
        willSet(newValue) {
            bottomView.like = newValue
        }
    }
    
    var isLike: Int? {
        willSet(value) {
            bottomView.isLike = value
        }
    }
    
    
    private lazy var videoImg: BaseVideoNewsView = {
        let view = BaseVideoNewsView(frame: .zero)
        view.layer.cornerRadius = 3 * iPHONE_AUTORATIO
        view.image = K_ImageName(PLACE_HOLDER_IMAGE)
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.clipsToBounds = true
        return view;
    }()
    
    //标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }()
    
    //下面的bottomView
    private lazy var bottomView: HomeNewsBottomTimeView = {
        let view = HomeNewsBottomTimeView()
        return view
    }()

    override func setupUI() {
        super.setupUI()
        
        addSubview(videoImg)
        videoImg.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 114 * iPHONE_AUTORATIO, height: 82 * iPHONE_AUTORATIO))
            make.centerY.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(136 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(16 * iPHONE_AUTORATIO)
        }
        
        addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalTo(127 * iPHONE_AUTORATIO)
            make.height.equalTo(47 * iPHONE_AUTORATIO)
        }
    }
    
    

}

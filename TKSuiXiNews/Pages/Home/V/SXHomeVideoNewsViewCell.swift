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
class SXHomeVideoNewsViewCell: BaseTableViewCell {
    var title:String? {
        willSet(newValue) {
            _titleLabel.text = newValue ?? "";
        }
    }
    
    var timeLength: Int = 0{
        willSet(newValue) {
            let result = newValue.secondsToHoursMinutesSeconds()
            _videoImg.timeLength = "\(result.min):\(result.sec)"
        }
    }
    
    var imageName: String? {
        willSet(newValue) {
            if let value = newValue {
                _videoImg.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    var time:String? {
        willSet(newValue) {
            _bottomView.time = newValue
        }
    }
    
    var review: Int? {
        willSet(newValue) {
            _bottomView.review = newValue
        }
    }
    
    var like: Int? {
        willSet(newValue) {
            _bottomView.like = newValue
        }
    }
    
    var isLike: Int? {
        willSet(value) {
            _bottomView.isLike = value
        }
    }
    
    
    private lazy var _videoImg: SXBaseVideoNewsView = {
        let view = SXBaseVideoNewsView(frame: .zero)
        view.layer.cornerRadius = 3 * iPHONE_AUTORATIO
        view.image = K_ImageName(PLACE_HOLDER_IMAGE)
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.clipsToBounds = true
        return view;
    }()
    
    //标题
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }()
    
    //下面的bottomView
    private lazy var _bottomView: SXHomeNewsBottomTimeView = {
        let view = SXHomeNewsBottomTimeView()
        return view
    }()

    override func setupUI() {
        super.setupUI()
        
        addSubview(_videoImg)
        _videoImg.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 114 * iPHONE_AUTORATIO, height: 82 * iPHONE_AUTORATIO))
            make.centerY.equalToSuperview()
        }
        
        addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(136 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(16 * iPHONE_AUTORATIO)
        }
        
        addSubview(_bottomView)
        _bottomView.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalTo(127 * iPHONE_AUTORATIO)
            make.height.equalTo(47 * iPHONE_AUTORATIO)
        }
    }
    
    

}

//
//  HomeNewsNoPicCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class SXHomeNewsNoPicCell: BaseTableViewCell {
    
    var isHiddenTop: Bool? {
        willSet(newValue) {
            if let value = newValue {
                if !value {
                    _isTopLabelView.isHidden = false
                    _titleLabel.text = ("       " + (_titleLabel.text ?? ""))
                } else {
                    _isTopLabelView.isHidden = true
                }
            } else {
                _isTopLabelView.isHidden = true
            }
        }
    }

    var title: String? {
        willSet(newValue) {
            _titleLabel.text = newValue ?? ""
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
    
    //标题
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }()
    
    //置顶
    private lazy var _isTopLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(255, 74, 92, 1)
        view.layer.cornerRadius = 3 * iPHONE_AUTORATIO
        view.isHidden = true
        return view
    }()
    
    //置顶的Label
    private lazy var _isTopLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(10 * iPHONE_AUTORATIO)
        label.textColor = .white
        label.text = "置顶"
        label.textAlignment = .center
        return label
    }()
    
    //设置下方的评论列表
    private lazy var _bottomView: SXHomeNewsBottomTimeView = {
        let view = SXHomeNewsBottomTimeView()
        return view
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(16 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(_bottomView)
        _bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(38 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        contentView.addSubview(_isTopLabelView)
        _isTopLabelView.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(15 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 27 * iPHONE_AUTORATIO, height: 17 * iPHONE_AUTORATIO))
        }
        
        _isTopLabelView.addSubview(_isTopLabel)
        _isTopLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

}

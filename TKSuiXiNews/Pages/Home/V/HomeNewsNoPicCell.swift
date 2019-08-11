//
//  HomeNewsNoPicCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class HomeNewsNoPicCell: BaseTableViewCell {
    
    var isHiddenTop: Bool? {
        willSet(newValue) {
            if let value = newValue, !value {
                isTopLabelView.isHidden = false
                titleLabel.text = ("       " + (titleLabel.text ?? ""))
            }
        }
    }

    var title: String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? ""
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
    
    //标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }()
    
    //置顶
    private lazy var isTopLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(255, 74, 92, 1)
        view.layer.cornerRadius = 3 * iPHONE_AUTORATIO
        view.isHidden = true
        return view
    }()
    
    //置顶的Label
    private lazy var isTopLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(10 * iPHONE_AUTORATIO)
        label.textColor = .white
        label.text = "置顶"
        label.textAlignment = .center
        return label
    }()
    
    //设置下方的评论列表
    private lazy var bottomView: HomeNewsBottomTimeView = {
        let view = HomeNewsBottomTimeView()
        return view
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(16 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
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
        
        contentView.addSubview(isTopLabelView)
        isTopLabelView.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(23 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 27 * iPHONE_AUTORATIO, height: 17 * iPHONE_AUTORATIO))
        }
        
        isTopLabelView.addSubview(isTopLabel)
        isTopLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

}

//
//  ProductDetailTitleCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///商品详情的标题和库存
class SXProductDetailTitleCell: BaseTableViewCell {
    var name:String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? ""
        }
    }
    
    //积分数量
    var score: Int? {
        willSet(newValue) {
            scoreLabel.text = "兑换：\(newValue ?? 0) 积分"
        }
    }
    
    //库存
    var storage: Int? {
        willSet(newValue) {
            storageNumL.text = "库存：\(newValue ?? 0)"
        }
    }

    //标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = kFont(16 * iPHONE_AUTORATIO)
        return label
    }()
    
    //兑换分
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        label.text = "兑换：0分"
        return label
    }()
    
    //库存
    private lazy var storageNumL: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        label.text = "库存：0"
        return label
    }()

    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(25 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(93 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(storageNumL)
        storageNumL.snp.makeConstraints { (make) in
            make.centerY.equalTo(scoreLabel.snp_centerY)
            make.right.equalTo(-14 * iPHONE_AUTORATIO)
        }
    }
}

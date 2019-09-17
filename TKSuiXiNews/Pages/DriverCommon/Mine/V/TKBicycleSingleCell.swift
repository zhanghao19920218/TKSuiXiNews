//
//  TKBicycleSingleCell.swift
//  TKSuiXiNews
//
//  Created by Mason on 2019/9/16.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///订单列表的Cell
class TKBicycleSingleCell: BaseTableViewCell {
    ///订单时间
    public var createTime: String? {
        willSet(newValue) {
            _timeLabel.text = newValue ?? ""
        }
    }
    
    ///订单时长
    public var orderLength: String? {
        willSet(newValue) {
            _orderLengthL.text = newValue ?? "0分0秒"
        }
    }
    
    ///订单价格
    public var orderPrice: String? {
        willSet(newValue) {
            _orderPriceL.text = newValue ?? "0元"
        }
    }
    
    ///时间的Label
    private lazy var _timeLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.textColor = RGBA(139, 139, 139, 1)
        return label
    }()
    
    ///订单时长
    private lazy var _orderLengthL: UILabel = {
        let label = UILabel()
        label.textColor = RGBA(78, 78, 78, 1)
        label.text = "0分0秒"
        return label
    }()
    
    ///订单的icon
    private lazy var _orderTimeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("bicy_time_icon")
        return imageView
    }()
    
    ///订单价格的Label
    private lazy var _orderPriceL: UILabel = {
        let label = UILabel()
        label.textColor = RGBA(25, 25, 25, 1)
        label.text = "0元"
        label.font = kBoldFont(15 * iPHONE_AUTORATIO)
        return label
    }()
    
    ///已完成的Label
    private lazy var finishedL: UILabel = {
        let label = UILabel()
        label.textColor = RGBA(139, 139, 139, 1)
        label.text = "已完成"
        label.font = kFont(14 * iPHONE_AUTORATIO)
        return label
    }()
    
    ///背景
    private lazy var _contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5 * iPHONE_AUTORATIO
        return view
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.backgroundColor = RGBA(245, 245, 245, 1)
        
        contentView.addSubview(_contentView)
        _contentView.snp.makeConstraints { (make) in
            make.left.top.equalTo(15 * iPHONE_AUTORATIO)
            make.right.bottom.equalTo(-15 * iPHONE_AUTORATIO)
        }
        
        _contentView.addSubview(_timeLabel)
        _timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16 * iPHONE_AUTORATIO)
            make.top.equalTo(23 * iPHONE_AUTORATIO)
        }
        
        _contentView.addSubview(_orderTimeIcon)
        _orderTimeIcon.snp.makeConstraints { (make) in
            make.left.equalTo(18 * iPHONE_AUTORATIO)
            make.top.equalTo(52 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 8 * iPHONE_AUTORATIO, height: 8 * iPHONE_AUTORATIO))
        }
        
        _contentView.addSubview(_orderLengthL)
        _orderLengthL.snp.makeConstraints { (make) in
            make.left.equalTo(33 * iPHONE_AUTORATIO)
            make.centerY.equalTo(_orderTimeIcon.snp_centerY)
        }
        
        _contentView.addSubview(_orderPriceL)
        _orderPriceL.snp.makeConstraints { (make) in
            make.right.equalTo(-16 * iPHONE_AUTORATIO)
            make.centerY.equalTo(_orderTimeIcon.snp_centerY)
        }
        
        _contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(89 * iPHONE_AUTORATIO)
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.height.equalTo(1)
        }
        
        _contentView.addSubview(finishedL)
        finishedL.snp.makeConstraints { (make) in
            make.left.equalTo(16 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-19 * iPHONE_AUTORATIO)
        }
    }
}

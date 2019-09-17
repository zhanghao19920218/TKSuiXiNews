//
//  CDLMessageCell.swift
//  OodsOwnMore
//
//  Created by Barry Allen on 2019/5/13.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import PPBadgeViewSwift

//自适应的cell
class SXTKMessageCell: UITableViewCell {
    //时间的Label
    private lazy var dateTimeLabel: UILabel = {
        let label = UILabel.init();
        label.font = kFont(11 * iPHONE_AUTORATIO);
        label.textColor = RGBA(204, 204, 204, 1);
        label.textAlignment = .center;
        return label;
    } ();
    
    ///消息信息的Label
    private lazy var _messageLabel: UILabel = {
        let label = UILabel.init();
        label.layer.cornerRadius = 10 * iPHONE_AUTORATIO;
        label.backgroundColor = .white;
        label.font = kFont(14 * iPHONE_AUTORATIO);
        label.numberOfLines = 0;
        return label;
    }();
    
    ///消息背景的View
    private lazy var _messageBackgroundView: UIView = {
        let view = UIView.init();
        view.layer.cornerRadius = 10;
        view.backgroundColor = .white;
        return view;
    }();
    
    //查看当前是否是未读消息
    var isUnread: Int? {
        willSet (value) {
            if let intValue = value {
                if (intValue != 1) {
                    _messageBackgroundView.pp.addDot(color: RGBA(253, 149, 71, 1));
                }
            }
        }
    }
    
    //查看事件
    var date: String? {
        willSet(value) {
            if let time = value {
                dateTimeLabel.text = time;
            }
        }
    }
    
    //查看消息
    var message: String? {
        willSet(value) {
            if let msg = value {
                _messageLabel.text = msg;
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var totalHeight = 10 * iPHONE_AUTORATIO;
        totalHeight = totalHeight + dateTimeLabel.sizeThatFits(size).height;
        totalHeight = totalHeight + _messageLabel.sizeThatFits(size).height;
        
        return CGSize(width: size.width, height: totalHeight);
    }
    
    //初始化UI
    fileprivate func setupUI()
    {
        self.contentView.backgroundColor = RGBA(247, 247, 247, 1);
        
        self.contentView.addSubview(dateTimeLabel);
        dateTimeLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(15 * iPHONE_AUTORATIO);
        };
        
        self.contentView.addSubview(_messageBackgroundView);
        _messageBackgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO);
            make.right.equalTo(-15 * iPHONE_AUTORATIO);
            make.top.equalTo(self.dateTimeLabel.snp_bottom).offset(15 * iPHONE_AUTORATIO);
            make.bottom.equalTo(-20 * iPHONE_AUTORATIO);
        };
        
        self._messageBackgroundView.addSubview(_messageLabel);
        _messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16 * iPHONE_AUTORATIO);
            make.right.equalTo(-16 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        };
    }


}

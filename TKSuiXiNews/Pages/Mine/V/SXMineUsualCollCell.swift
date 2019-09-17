//
//  MineUsualCollCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

//个人中心的cell
class SXMineUsualCollCell: UICollectionViewCell {
    ///照片的名称
    var imageName: String? {
        willSet(newValue) {
            _collectionImage.image = K_ImageName(newValue ?? "");
        }
    }
    
    ///标题
    var title:String? {
        willSet(newValue) {
            _nameLabel.text = newValue ?? ""
        }
    }
    
    ///未读消息
    var unread: Int? {
        willSet(newValue) {
            if let value = newValue, value > 0 {
                _unreadMsgView.isHidden = false
                _unreadMsgLabel.text = "\(value)"
            } else {
                _unreadMsgView.isHidden = true
            }
        }
    }
    
    ///图片信息
    private lazy var _collectionImage: UIImageView = {
        let imageView = UIImageView();
        return imageView;
    }();
    
    ///用户名称
    private lazy var _nameLabel: UILabel = {
        let label = UILabel();
        label.textColor = RGBA(102, 102, 102, 1);
        label.textAlignment = .center;
        label.font = kFont(12 * iPHONE_AUTORATIO)
        return label;
    }()
    
    ///未读消息数
    private lazy var _unreadMsgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(254, 168, 65, 1)
        view.layer.cornerRadius = 10 * iPHONE_AUTORATIO
        view.isHidden = true
        return view
    }()
    
    ///未读消息的Label
    private lazy var _unreadMsgLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(10 * iPHONE_AUTORATIO)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "0"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(_collectionImage);
        _collectionImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(19 * iPHONE_AUTORATIO);
            make.size.equalTo(CGSize(width: 50 * iPHONE_AUTORATIO, height: 50 * iPHONE_AUTORATIO))
        };
        
        contentView.addSubview(_nameLabel);
        _nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(self._collectionImage.snp_bottom).offset(10 * iPHONE_AUTORATIO)
        }
        
        _collectionImage.addSubview(_unreadMsgView)
        _unreadMsgView.snp.makeConstraints { (make) in
            make.right.equalTo(8 * iPHONE_AUTORATIO)
            make.top.equalTo(-8 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 20 * iPHONE_AUTORATIO, height: 20 * iPHONE_AUTORATIO))
        }
        
        _unreadMsgView.addSubview(_unreadMsgLabel)
        _unreadMsgLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

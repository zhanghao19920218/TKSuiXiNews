//
//  MallProductCollectionViewCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 积分商城的Cell
 */

class MallProductCollectionViewCell: UICollectionViewCell {
    var imageName:String? {
        willSet(newValue) {
            if let value = newValue {
                _imageView.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
            }
        }
    }
    
    var productName:String? {
        willSet(newValue) {
            _productLabel.text = newValue ?? ""
        }
    }
    
    var score:Int? {
        willSet(newValue) {
            _scoreNumL.text = "\(newValue ?? 0)积分"
        }
    }
    
    //背景的view
    private lazy var _view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10 * iPHONE_AUTORATIO
        view.layer.masksToBounds = true
        return view
    }()
    
    //产品的图片
    private lazy var _imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    //产品的名称
    private lazy var _productLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }()
    
    //产品的积分
    private lazy var _scoreNumL: UILabel = {
        let label = UILabel()
        label.font = kFont(11 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        label.text = "0积分"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化页面
    private func _setupUI() {
        contentView.addSubview(_view)
        _view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        _view.addSubview(_imageView)
        _imageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(90 * iPHONE_AUTORATIO)
        }
        
        _view.addSubview(_productLabel)
        _productLabel.snp.makeConstraints { (make) in
            make.left.equalTo(11 * iPHONE_AUTORATIO)
            make.right.equalTo(-11 * iPHONE_AUTORATIO)
            make.top.equalTo(_imageView.snp_bottom).offset(10 * iPHONE_AUTORATIO)
        }
        
        _view.addSubview(_scoreNumL)
        _scoreNumL.snp.makeConstraints { (make) in
            make.left.equalTo(11 * iPHONE_AUTORATIO)
            make.top.equalTo(150 * iPHONE_AUTORATIO)
        }
    }
}

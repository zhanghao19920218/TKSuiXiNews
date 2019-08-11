//
//  BaseVoteButton.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 点击按钮投票
 */

fileprivate let fontSize = kFont(14 * iPHONE_AUTORATIO)
//显示0人的占位
fileprivate let placeholderPerson = "0人"

fileprivate let normalColor = RGBA(221, 221, 221, 1)
fileprivate let selectedColor = RGBA(255, 146, 157, 1)

class BaseVoteButton: UIButton {
    //显示背景的投票进度
    var progress: Float?
    {
        willSet(newValue) {
            if let value = newValue {
                let width = CGFloat(value) * 325 * iPHONE_AUTORATIO
                _voteNumBackView.frame = CGRect(x: 0, y: 0, width: width, height: 34 * iPHONE_AUTORATIO)
                if newValue != 1.0 {
                    _voteNumBackView.corner(byRoundingCorners: [.bottomLeft, .topLeft], radii: 5 * iPHONE_AUTORATIO)
                } else {
                    _voteNumBackView.layer.cornerRadius = 5 * iPHONE_AUTORATIO
                }
            }
            
        }
    }
    
    //投票的标题
    var title:String = "" {
        willSet(newValue) {
            _voteLabel.text = newValue
        }
    }
    
    //显示人数
    var person: Int = 0 {
        willSet(newValue) {
            _voteNumLabel.text = "\(newValue)人"
        }
    }
    
    //是不是点击的属性
    var isCustomerShow:Bool?
    {
        willSet(newValue) {
            if let value = newValue, value {
                _voteNumLabel.isHidden = false
                _voteNumBackView.isHidden = false
            } else {
                _voteNumLabel.isHidden = true
                _voteNumBackView.isHidden = true
            }
        }
    }
    
    //是不是点击了
    var isCustomerIsSelected: Bool?
    {
        willSet(newValue) {
            isCustomerShow = true
            if let value = newValue, value {
                _voteNumBackView.backgroundColor = selectedColor
                layer.borderColor = selectedColor.cgColor
            } else {
                _voteNumBackView.backgroundColor = normalColor
                layer.borderColor = normalColor.cgColor
            }

        }
    }
    
    
    var _progress: Float = 0.0

    //投票的标题
    private lazy var _voteLabel: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textAlignment = .center
        return label
    }()

    
    //投票人数
    private lazy var _voteNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = fontSize
        label.text = placeholderPerson
        label.isHidden = true
        return label
    }()
    
    //显示进度条的背景
    private lazy var _voteNumBackView: UIView = {
        let view = UIView()
        view.backgroundColor = normalColor
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _setupUI() //初始化页面
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化按钮
    private func _setupUI() {
        layer.cornerRadius = 5 * iPHONE_AUTORATIO
        layer.borderWidth = 1
        layer.borderColor = normalColor.cgColor
        
        backgroundColor = .white
        
        //删除系统的label和imageView
        titleLabel?.removeFromSuperview()
        imageView?.removeFromSuperview()
        
        _voteNumBackView.frame = CGRect(x: 0, y: 0, width: 0, height: 34 * iPHONE_AUTORATIO)
        addSubview(_voteNumBackView)
        
        addSubview(_voteLabel)
        _voteLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        addSubview(_voteNumLabel)
        _voteNumLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.centerY.equalToSuperview()
        }
    }
}

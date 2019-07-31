//
//  TurntableView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 转盘View
 */

fileprivate let fontSize = kFont(14 * iPHONE_AUTORATIO)

class TurntableView: UIView {
    var block: () -> Void = { }
    
    private lazy var _array: Array<Int> = {
        return [Int]()
    }()
    
    var array: Array<RotatePanelListItemModel>? {
        willSet(newValue) {
            if let value = newValue {
                if value.count == 6 {
                    label2.text = value[0].name.string
                    label4.text = value[1].name.string
                    label6.text = value[2].name.string
                    label5.text = value[3].name.string
                    label3.text = value[4].name.string
                    label.text = value[5].name.string
                    
                    for item in value {
                        _array.append(item.id.int)
                    }
                }
            }
        }
    }
    
    //转盘背景
    lazy var _rotateWheel: UIImageView = {
        let view = UIImageView()
        view.image = K_ImageName("rotate_panel_back")
        return view
    }()
    
    //指针
    private lazy var _rotateBasic: UIImageView = {
        let view = UIImageView()
        view.image = K_ImageName("rotate_panel_line")
        return view
    }()
    
    //转盘按钮
    lazy var _rotateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(K_ImageName("rotate_panel_button"), for: .normal)
        button.addTarget(self,
                         action: #selector(rotateButtonTapped(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    //六个标题Label
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = RGBA(255, 74, 92, 1)
        label.text = "0积分"
        return label
    }()
    
    private lazy var label2: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = RGBA(255, 74, 92, 1)
        label.text = "0积分"
        return label
    }()
    
    private lazy var label3: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = RGBA(255, 74, 92, 1)
        label.text = "0积分"
        return label
    }()
    
    private lazy var label4: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = RGBA(255, 74, 92, 1)
        label.text = "0积分"
        return label
    }()
    
    private lazy var label5: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = RGBA(255, 74, 92, 1)
        label.text = "0积分"
        return label
    }()
    
    private lazy var label6: UILabel = {
        let label = UILabel()
        label.font = fontSize
        label.textColor = RGBA(255, 74, 92, 1)
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
    
    //MARK: - 初始化页面
    private func _setupUI() {
        //转盘
        addSubview(_rotateWheel)
        _rotateWheel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        //转盘的指针
        addSubview(_rotateBasic)
        _rotateBasic.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-9 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 71 * iPHONE_AUTORATIO, height: 88 * iPHONE_AUTORATIO))
        }
        
        //转盘的按钮
        addSubview(_rotateButton)
        _rotateButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 64 * iPHONE_AUTORATIO, height: 64 * iPHONE_AUTORATIO))
        }
        
        _rotateWheel.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(58 * iPHONE_AUTORATIO)
            make.left.equalTo(80 * iPHONE_AUTORATIO)
        }
        label.transform = CGAffineTransform(rotationAngle: -.pi / 6)
        
        _rotateWheel.addSubview(label2)
        label2.snp.makeConstraints { (make) in
            make.top.equalTo(58 * iPHONE_AUTORATIO)
            make.right.equalTo(-80 * iPHONE_AUTORATIO)
        }
        label2.transform = CGAffineTransform(rotationAngle: .pi / 6)
        
        _rotateWheel.addSubview(label3)
        label3.snp.makeConstraints { (make) in
            make.top.equalTo(142 * iPHONE_AUTORATIO)
            make.left.equalTo(28 * iPHONE_AUTORATIO)
        }
        label3.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        
        _rotateWheel.addSubview(label4)
        label4.snp.makeConstraints { (make) in
            make.top.equalTo(142 * iPHONE_AUTORATIO)
            make.right.equalTo(-28 * iPHONE_AUTORATIO)
        }
        label4.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
        _rotateWheel.addSubview(label5)
        label5.snp.makeConstraints { (make) in
            make.bottom.equalTo(-58 * iPHONE_AUTORATIO)
            make.left.equalTo(80 * iPHONE_AUTORATIO)
        }
        label5.transform = CGAffineTransform(rotationAngle: -.pi / 6 * 5)
        
        _rotateWheel.addSubview(label6)
        label6.snp.makeConstraints { (make) in
            make.bottom.equalTo(-58 * iPHONE_AUTORATIO)
            make.right.equalTo(-80 * iPHONE_AUTORATIO)
        }
        label6.transform = CGAffineTransform(rotationAngle: .pi / 6 * 5)
    }
    
    @objc func rotateButtonTapped(_ sender: UIButton) {
        block()
    }

}

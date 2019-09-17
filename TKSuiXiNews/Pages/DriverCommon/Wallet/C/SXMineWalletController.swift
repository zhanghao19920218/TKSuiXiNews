//
//  SXMineWalletController.swift
//  TKSuiXiNews
//
//  Created by Mason on 2019/9/16.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///我的钱包页面
class SXMineWalletController: SXBaseViewController {
    ///单车剩余天数
    private lazy var _bicycleL: UILabel = {
        let label = UILabel()
        label.font = kBoldFont(14 * iPHONE_AUTORATIO)
        label.textColor = bicycleAppThemeColor
        label.text = "剩余27天"
        return label
    }()
    
    ///助力车剩余天数
    private lazy var _motorL: UILabel = {
        let label = UILabel()
        label.font = kBoldFont(14 * iPHONE_AUTORATIO)
        label.text = "剩余82天"
        label.textColor = bicycleAppThemeColor
        return label
    }()
    
    ///标题
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.text = "我的卡"
        label.font = kBoldFont(16 * iPHONE_AUTORATIO)
        return label
    }()
    
    ///单车骑行卡
    private lazy var _bicycleCardBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(K_ImageName("bicy_month_card"), for: .normal)
        return button
    }()
    
    ///助力车骑行卷
    private lazy var _motorCardBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(K_ImageName("motor_month_card"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBarLogo();
        
        navigationController?.navigationBar.barTintColor = bicycleAppThemeColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        view.backgroundColor = RGBA(251, 251, 251, 1)

        // Do any additional setup after loading the view.
        view.addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15 * iPHONE_AUTORATIO)
            make.left.equalTo(16 * iPHONE_AUTORATIO)
        }
        
        view.addSubview(_bicycleCardBtn)
        _bicycleCardBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16 * iPHONE_AUTORATIO)
            make.right.equalTo(-16 * iPHONE_AUTORATIO)
            make.top.equalTo(50 * iPHONE_AUTORATIO)
            make.height.equalTo(82 * iPHONE_AUTORATIO)
        }
        
        view.addSubview(_motorCardBtn)
        _motorCardBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16 * iPHONE_AUTORATIO)
            make.right.equalTo(-16 * iPHONE_AUTORATIO)
            make.top.equalTo(_bicycleCardBtn.snp_bottom).offset(12 * iPHONE_AUTORATIO)
            make.height.equalTo(82 * iPHONE_AUTORATIO)
        }
        
        _bicycleCardBtn.addSubview(_bicycleL)
        _bicycleL.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            
        }
        
        _motorCardBtn.addSubview(_motorL)
        _motorL.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
        }
    }

}

//
//  BicycleMineController.swift
//  TKSuiXiNews
//
//  Created by Mason on 2019/9/16.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///我的界面
class BicycleMineController: SXBaseViewController {
    ///用户头像
    private lazy var _avatarImgV: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("bicy_user_avatar")
        return imageView
    }()
    
    ///用户昵称
    private lazy var _nicknameL: UILabel = {
        let label = UILabel()
        label.font = kBoldFont(18 * iPHONE_AUTORATIO)
        label.text = DefaultsKitUtil.share.getMobileNum
        return label
    }()
    
    ///我的订单界面
    private lazy var _orderImageBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(K_ImageName("bicy_mine_order"), for: .normal)
        button.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self,
                         action: #selector(clickOrderListAction),
                         for: .touchUpInside)
        return button
    }()
    
    ///我的金币
    private lazy var _mineCoinBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(K_ImageName("bicy_mine_coin"), for: .normal)
        button.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        button.layer.shadowOpacity = 0.3
        button.addTarget(self,
                         action: #selector(clickIntegralDetailAction),
                         for: .touchUpInside)
        button.layer.shadowColor = UIColor.black.cgColor
        return button
    }()
    
    ///金币的数量
    private lazy var _coinNumL: UILabel = {
        let label = UILabel()
        label.font = kBoldFont(16 * iPHONE_AUTORATIO)
        label.text = "0金币"
        return label
    }()
    
    ///设置个人信息按钮
    private lazy var _settingBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage("bicy_setting_icon")
        button.addTarget(self,
                         action: #selector(clickSettingAction),
                         for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        requestData()
        
        setupNaviBarLogo();
        
        navigationController?.navigationBar.barTintColor = bicycleAppThemeColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        view.backgroundColor = RGBA(251, 251, 251, 1)
        
        view.addSubview(_avatarImgV)
        _avatarImgV.snp.makeConstraints { (make) in
            make.left.top.equalTo(15 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 55 * iPHONE_AUTORATIO, height: 55 * iPHONE_AUTORATIO))
        }
        
        view.addSubview(_nicknameL)
        _nicknameL.snp.makeConstraints { (make) in
            make.left.equalTo(_avatarImgV.snp_right).offset(16 * iPHONE_AUTORATIO)
            make.centerY.equalTo(_avatarImgV.snp_centerY)
        }
        
        view.addSubview(_orderImageBtn)
        _orderImageBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.top.equalTo(100 * iPHONE_AUTORATIO)
            make.width.equalTo(K_SCREEN_WIDTH/2 - 20 * iPHONE_AUTORATIO)
            make.height.equalTo(72 * iPHONE_AUTORATIO)
        }
        
        view.addSubview(_mineCoinBtn)
        _mineCoinBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.top.equalTo(100 * iPHONE_AUTORATIO)
            make.width.equalTo(K_SCREEN_WIDTH/2 - 20 * iPHONE_AUTORATIO)
            make.height.equalTo(72 * iPHONE_AUTORATIO)
        }
        
        _mineCoinBtn.addSubview(_coinNumL)
        _coinNumL.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
        }
        
        view.addSubview(_settingBtn)
        _settingBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.centerY.equalTo(_avatarImgV.snp_centerY)
            make.size.equalTo(CGSize(width: 22 * iPHONE_AUTORATIO, height: 20 * iPHONE_AUTORATIO))
        }
    }
    
    ///进入积分明细
    @objc private func clickIntegralDetailAction(){
        let vc = MineIntegralDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //点击设置按钮
    @objc private func clickSettingAction(){
        let vc = MineSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //点击设置订单列表
    @objc private func clickOrderListAction() {
        let vc = BicycleOrderController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension BicycleMineController {
    //MARK: - 请求个人中心数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.memeberInfo, success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MemeberInfoResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            //未读消息数量
            self?._coinNumL.text = "\(forceModel.data.score.string)币"
            
            //更新手机号码
            DefaultsKitUtil.share.storePhoneNum(mobile: forceModel.data.mobile.string)
            }
        )
    }
}

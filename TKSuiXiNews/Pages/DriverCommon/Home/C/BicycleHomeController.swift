//
//  BicycleHomeController.swift
//  TKSuiXiNews
//
//  Created by Mason on 2019/9/16.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import AMapFoundationKit
import AMapLocationKit

class BicycleHomeController: SXBaseViewController {
    ///初始化界面
    private var _isFirstEnter: Bool = true
    
    
    ///获取用户当前的位置
    private var _userCurrentLoc: CLLocationCoordinate2D?
    
    ///扫码按钮
    private lazy var _scanButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(K_ImageName("bicy_scan_button"), for: .normal)
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self,
                         action: #selector(userClickScanCodeBtn(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    ///定位按钮
    private lazy var _locButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(K_ImageName("bicy_loc_in"), for: .normal)
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self,
                         action: #selector(userLocationCurrentLoc(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    ///维修按钮
    private lazy var _fixButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(K_ImageName("bicy_fix_icon"), for: .normal)
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self,
                         action: #selector(userClickedErrorUploadBtn(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    ///地图界面
    private lazy var _mapView: GDMapView = {
        let mapView = GDMapView(frame: .zero)
        return mapView
    }()
    
    ///设置地图中心点
    private lazy var _centerLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("bicy_center_logo")
        return imageView
    }()
    
    
    ///初始化持续定位
    private lazy var _locationManager: AMapLocationManager = {
        let manager = AMapLocationManager()
        manager.delegate = self
        manager.distanceFilter = 200
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBarLogo()

        setupUI()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = bicycleAppThemeColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //开启持续定位
        _locationManager.startUpdatingLocation()
    }
    
    //关闭定位
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _locationManager.stopUpdatingLocation()
    }
    
    ///初始化界面
    private func setupUI() {
        view.addSubview(_mapView)
        _mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        //扫码开锁
        view.addSubview(_scanButton)
        _scanButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-25 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 211 * iPHONE_AUTORATIO, height: 56 * iPHONE_AUTORATIO))
        }
        
        //定位点
        view.addSubview(_locButton)
        _locButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(_scanButton.snp_centerY)
            make.left.equalTo(16 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 40 * iPHONE_AUTORATIO, height: 40 * iPHONE_AUTORATIO))
        }
        
        //修理车辆按钮
        view.addSubview(_fixButton)
        _fixButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(_scanButton.snp_centerY)
            make.right.equalTo(-16 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 40 * iPHONE_AUTORATIO, height: 40 * iPHONE_AUTORATIO))
        }
        
        //中间点的显示
        view.addSubview(_centerLogo)
        _centerLogo.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-33 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 22 * iPHONE_AUTORATIO, height: 33 * iPHONE_AUTORATIO))
        }
    }

    ///用户定位当前的位置
    @objc private func userLocationCurrentLoc(_ sender: UIButton) {
        if let _ = _userCurrentLoc {
            _mapView.setCenter(_userCurrentLoc!, animated: true)
            _mapView.zoomLevel = 18.0
        }
    }
    
    ///用户点击扫码开锁按钮
    @objc private func userClickScanCodeBtn(_ sender: UIButton) {
        let vc = ScannerVC()
        vc.setupScanner("扫描单车", bicycleAppThemeColor, .default, "对准单车二维码，即可自动扫描解锁") { (code) in
            TProgressHUD.show(text: "请扫描单车二维码")
            
            //关闭扫描界面
            self.dismiss(animated: true, completion: nil)
        }
        
        //Present到扫描界面
        present(vc, animated: true, completion: nil)
    }
    
    ///用户跳转故障上报的界面
    @objc private func userClickedErrorUploadBtn(_ sender: UIButton) {
        let vc = BicycleUploadErrorController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BicycleHomeController: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        if _isFirstEnter {
            //第一次进入App更新位置
            _mapView.setCenter(location.coordinate, animated: true)
            _isFirstEnter = false
        }
        
        _userCurrentLoc = location.coordinate
    }
}

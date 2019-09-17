//
//  GDMapView.swift
//  TKSuiXiNews
//
//  Created by Mason on 2019/9/16.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import MAMapKit
import AMapFoundationKit

class GDMapView: MAMapView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///初始化需求
    private func setupUI() {
        isShowsIndoorMapControl = false
        showsCompass = false
        showsScale = false
        isRotateEnabled = false //不可滑动
        isRotateCameraEnabled = false //不可倾斜
        //设置距离
        zoomLevel = 18.0
        
        //显示定位小蓝点
        showsUserLocation = true
        userTrackingMode = .followWithHeading
        
        //自定义定位小蓝点
        let r = MAUserLocationRepresentation()
        r.showsAccuracyRing = false
        r.lineWidth = 2
        r.enablePulseAnnimation = true
        r.locationDotBgColor = UIColor.white
        r.locationDotFillColor = bicycleAppThemeColor
        r.showsHeadingIndicator = true
        update(r)
    }

}

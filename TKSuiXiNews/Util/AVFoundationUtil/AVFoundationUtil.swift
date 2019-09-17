//
//  AVFoundationUtil.swift
//  TKSuiXiNews
//
//  Created by Mason on 2019/9/17.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import AVFoundation

class AVFoundationUtil {
    ///静态函数获取数据
    public static let shared = AVFoundationUtil()
    
    private init() {
        
    }
    
    //MARK: - 检测当前App的摄像头权限
    public var checkCameraAuth: Bool {
        get {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            if status != .authorized {
                TProgressHUD.show(text: "请先授权摄像头来扫描二维码")
                return false
            }
            return status == .authorized
        }
    }
}

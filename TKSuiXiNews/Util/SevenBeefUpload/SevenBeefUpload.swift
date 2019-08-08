//
//  SevenBeefUpload.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/8.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import Qiniu
import DefaultsKit

class SevenBeefUpload {
    //MARK: - 上传一个视频
    public static func uploadVideoFile(filePath:Data){
        //华南
        let config = QNConfiguration.build { (builder) in
            builder?.setZone(QNFixedZone.zone2())
        }
        //设置文件位置
        let fileKey = Defaults.shared.get(for: userIdKey) ?? "" + "\(String.getTimeLine())"
        
        //重用uploadManager。一般地，只需创建一个uploadManager对象
        let token = Defaults.shared.get(for: sevenToken)
        if let token = token {
            let uploadKey = fileKey
            let uploadManager = QNUploadManager(configuration: config)
            uploadManager?.put(filePath, key: uploadKey, token: token, complete: { (info, keys, resp) in
                //请求成功
                if info?.isOK ?? false {
                    print("请求成功")
                    
                    
                    
                } else {
                    print("请求失败")
                }
                print("info ===== \(info)")
                print("resp ===== \(resp)")
            }, option: nil)
        }
    }
}

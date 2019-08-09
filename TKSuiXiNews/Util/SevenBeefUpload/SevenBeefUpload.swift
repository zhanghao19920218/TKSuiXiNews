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

typealias QNSuccessBlock = ((_ result: String) -> Void)
typealias QNFailureBlock = ((_ error: String) -> Void)

class SevenBeefUpload {
    static let share = SevenBeefUpload()
    
    private init() {
        
    }
    
    //MARK: - 请求七牛云的token
    open func getSevenBeefToken() {
        HttpClient.shareInstance.request(target: BAAPI.qiniuyunToken, success: { (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SevenBeefModelResponse.self, from: json)
            guard let userModel = model else {
                return;
            }
            Defaults.shared.set(userModel.data.string, for: sevenToken);
        })
    }
    
    //MARK: - 上传单张照片
    open func uploadSingleImage(_ image: UIImage, success: @escaping (String) ->  Void){
        TProgressHUD.show()
        //华南区
        let config = QNConfiguration.build { (builder) in
            builder?.setZone(QNFixedZone.zone2())
        }
        let uploadManager = QNUploadManager(configuration: config)
        let uploadOption = QNUploadOption.init(mime: nil,
                                               progressHandler: { (key, percent) in
                                                print("上传进度 \(percent)")
        }, params: nil,
           checkCrc: false,
           cancellationSignal: nil)
        guard let data = image.compressImageNoAffectQuality() else { return }
        //上传七牛云token
        let token = Defaults.shared.get(for: sevenToken)
        //文件路径
        let filePath = _filePath()
        uploadManager?.put(data, key: filePath, token: token, complete: { (info, key, resp) in
            TProgressHUD.hide()
            if info?.isOK ?? false {
                let path = K_URL_CDN + filePath
                success(path)
            } else {
                print(info?.error as Any)
            }
            }, option: uploadOption)
    }
    
    //MARK: - 上传多图
    open func uploadImages(_ images: [UIImage], success: @escaping ([String]) -> Void) {
        var fileLocs = [String]()
        //加载动画
        TProgressHUD.show()
        //华南区
        let config = QNConfiguration.build { (builder) in
            builder?.setZone(QNFixedZone.zone2())
        }
        let uploadManager = QNUploadManager(configuration: config)
        let uploadOption = QNUploadOption.init(mime: nil,
                                               progressHandler: { (key, percent) in
                                                print("上传进度 \(percent)")
        }, params: nil,
           checkCrc: false,
           cancellationSignal: nil)
        //上传七牛云token
        let token = Defaults.shared.get(for: sevenToken)
        for (index, image) in images.enumerated() {
            //文件路径
            let filePath = _filePath()
            if let data = image.compressImageNoAffectQuality() {
                uploadManager?.put(data,
                                   key: filePath,
                                   token: token, complete: { (info, key, resp) in
                                    if info?.isOK ?? false {
                                        let path = K_URL_CDN + filePath
                                        fileLocs.append(path)
                                    } else {
                                        fileLocs.append("\(index)")
                                    }
                                    //创建成功进行返回
                                    if fileLocs.count == images.count {
                                        //隐藏进度条
                                        TProgressHUD.hide()
                                        success(fileLocs)
                                    }
                },
                                   option: uploadOption)
            }
        }
    }
    
    //MARK: - 上传视频的接口
    open func uploadVideoToQNFilePath(data: Data, success: @escaping (String) -> Void){
        TProgressHUD.show()
        //华南区
        let config = QNConfiguration.build { (builder) in
            builder?.setZone(QNFixedZone.zone2())
        }
        let uploadManager = QNUploadManager(configuration: config)
        let uploadOption = QNUploadOption.init(mime: "video/webm",
                                               progressHandler: { (key, percent) in
                                                print("上传进度 \(percent)")
        }, params: nil,
           checkCrc: false,
           cancellationSignal: nil)
        //上传七牛云token
        let token = Defaults.shared.get(for: sevenToken)
        let filePath = _videofilePath()
        uploadManager?.put(data, key: filePath, token: token, complete: { (info, key, resp) in
            TProgressHUD.hide()
            if info?.isOK ?? false {
                let path = K_URL_CDN + filePath
                success(path)
            } else {
                TProgressHUD.show(text: "上传视频失败")
            }
        }, option: uploadOption)
    }
    
    //MARK: - 组建文件
    private func _filePath() -> String {
        let uid = Defaults.shared.get(for: userIdKey)
        let timeIntervel = String.getTimeLine()
        //6位随机数
        let causualNumber = Int(arc4random_uniform(899999) + 100000)
        let fileName = "\(uid ?? "0")\(timeIntervel)\(causualNumber)"
        let path = "qiniu/\(String.getTimeFormat())/\(fileName).png"
        return path
    }
    
    //MARK: - 组建视频文件
    private func _videofilePath() -> String {
        let uid = Defaults.shared.get(for: userIdKey)
        let timeIntervel = String.getTimeLine()
        //6位随机数
        let causualNumber = Int(arc4random_uniform(899999) + 100000)
        let fileName = "\(uid ?? "0")\(timeIntervel)\(causualNumber)"
        let path = "qiniu/\(String.getTimeFormat())/\(fileName).mp4"
        return path
    }
}

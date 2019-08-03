//
//  YPImagePickerUtil.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/25.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import CoreMedia
import AVFoundation
import YPImagePicker

//typealias YPImagePickerBlock = (_ imageUrl:String, _ videoUrl: String, _ videoLength: Int)->Void

/// -parameters:

protocol YPImagePickerUtilDelegate {
    //MARK: - 获取视频地址
    func imagePicker(imageUrl: String, videoUrl: String, videoLength: Int, isSuccess: Bool);
    
    //MARK: - 获取单照片地址
    func imagePicker(imageUrl: String, isSuccess: Bool)
    
    //MARK: - 多图上传
    func imagePicker(images:[String], isSuccess: Bool)
}

open class YPImagePickerUtil {
    //单例模式
    static let share = YPImagePickerUtil();
    
    //需要获取的视频信息
    private var videoLength = 0;
    
    //获取视频的封面照片
    private var videoImageFirst: UIImage = UIImage();
    
    //获取视频的上传后的地址
    private var videoUploadUrl:String = "";
    
    //获取图片的上传地址
    private var imageFirstUrl:String = "";
    
    //上传单张照片
    private var singleImageUrl: String = "";
    
    //第一张照片
    private var singleFirstImage:UIImage = UIImage();
    
    //多图上传的images
    private var mutilImages:[String] = [];
    
    //获取imagePicker
    private var picker: YPImagePicker?
    
    var delegate: YPImagePickerUtilDelegate?
    
    private init(){
        
    }
    
    //单视频的获取
    open func singleVideoPicker() {
        //获取当前的viewController
        let vc = UIViewController.current()
        
        //定义配置文件
        var config = YPImagePickerConfiguration()
        config.screens = [.video]
        config.video.fileType = .mp4
        config.video.recordingTimeLimit = TimeInterval(15)
        
        picker = YPImagePicker(configuration: config)
        picker?.didFinishPicking { [weak self] items, _ in
            guard let video = items.singleVideo else {
                self?.picker?.dismiss(animated: true, completion: nil);
                return;
            }
            //获取视频长度
            let asset = AVAsset(url: video.url)
            let duration = asset.duration
            let durationTime = Int(CMTimeGetSeconds(duration))
            
            //视频长度小于1就直接dismiss掉
            if durationTime < 1 {
                self?.picker?.dismiss(animated: true, completion: {
                    TProgressHUD.show(text: "录制时间过短");
                });
                return;
            }
            
            self?.videoLength = durationTime;
            
            //获取封面照片
            self?.videoImageFirst = video.thumbnail;
            
            //上传照片信息
            self?.uploadDetailVideo(videoUrl: video.url);
        }
        
        if let picker = self.picker {
            vc?.present(picker, animated: true, completion: nil)
        }
    }
    
    //上传视频获取videoUrl
    private func uploadDetailVideo(videoUrl:URL ){
        //上传视频的数据
        let data = try? Data(contentsOf: videoUrl);
        
        HttpClient.shareInstance.request(target: BAAPI.uploadVideo(data: data  ?? Data()), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(UploadFileResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            //更新视频地址
            self?.videoUploadUrl = forceModel.data.url.string
            
            //上传图片
            self?.uploadDetailImage();
            
            }
        )
    }
    
    //上传图像
    private func uploadDetailImage(){
        let imageData = self.videoImageFirst.jpegData(compressionQuality: 0.75);
        HttpClient.shareInstance.request(target: BAAPI.uploadImage(data: imageData ?? Data()), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(UploadFileResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.imageFirstUrl = forceModel.data.url.string;
            
            if let delegate = self?.delegate {
                delegate.imagePicker(imageUrl: self?.imageFirstUrl ?? "", videoUrl: self?.videoUploadUrl ?? "", videoLength: self?.videoLength ?? 0, isSuccess: true)
                self?.picker?.dismiss(animated: true, completion: nil);
            }
            
            }
        )
    }
    
    
    //拍摄或者录制视频
    open func cameraOrVideo() {
        //获取当前的viewController
        let vc = UIViewController.current()
        
        //定义配置文件
        var config = YPImagePickerConfiguration()
        config.screens = [.video, .photo]
        config.showsPhotoFilters = false; //隐藏滤镜效果
        config.video.recordingTimeLimit = TimeInterval(15)
        
        picker = YPImagePicker(configuration: config)
        picker?.didFinishPicking { [weak self] items, _ in
            //判断是不是视频
            if let video = items.singleVideo {
                //获取视频长度
                let asset = AVAsset(url: video.url)
                let duration = asset.duration
                let durationTime = Int(CMTimeGetSeconds(duration))
                
                //视频长度小于1就直接dismiss掉
                if durationTime < 1 {
                    self?.picker?.dismiss(animated: true, completion: {
                        TProgressHUD.show(text: "录制时间过短");
                    });
                    return;
                }
                
                self?.videoLength = durationTime;
                
                //获取封面照片
                self?.videoImageFirst = video.thumbnail;
                
                //上传照片信息
                self?.uploadDetailVideo(videoUrl: video.url);
            }
            
            if let image = items.singlePhoto {
                self?.singleFirstImage = image.modifiedImage ?? image.originalImage;
                
                self?.uploadSinglePhoto();
            }
            
            self?.picker?.dismiss(animated: true, completion: nil);
        }
        
        if let picker = self.picker {
            vc?.present(picker, animated: true, completion: nil)
        }
    }
    
    //MARK: - 拍客上传单照片
    private func uploadSinglePhoto() {
        let imageData = self.singleFirstImage.jpegData(compressionQuality: 0.75);
        HttpClient.shareInstance.request(target: BAAPI.uploadImage(data: imageData ?? Data()), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(UploadFileResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.singleImageUrl = forceModel.data.url.string;
            
            if let delegate = self?.delegate {
                delegate.imagePicker(imageUrl: K_URL_Base + (self?.singleImageUrl ?? ""), isSuccess: true)
                self?.picker?.dismiss(animated: true, completion: nil);
            }
            
            }
        )
    }
    
    //MARK: - 拍客上传多照片
    open func multiPickerPhotosLibary(maxCount:Int) {
        //获取当前的viewController
        let vc = UIViewController.current()
        
        //定义配置文件
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.library.mediaType = .photo;
        config.library.maxNumberOfItems = maxCount;
        config.showsPhotoFilters = false; //隐藏滤镜效果
        config.library.defaultMultipleSelection = true; //显示多选择的页面
        
        picker = YPImagePicker(configuration: config)
        picker?.didFinishPicking { [weak self] items, _ in
            //获取照片的Data数组
            //MARK: - 没选择数据返回
            if items.count == 0 {
                self?.picker?.dismiss(animated: true, completion: nil);
            } else {
                var images = [UIImage]();
                for item in items {
                    switch item {
                    case let .photo(photo):
                        let image = photo.modifiedImage ?? photo.originalImage
                        images.append(image);
                    case let .video(video):
                        print(video)
                    }
                }
                
                self?.uploadPhotosImage(images: images);
            }
            
        }
        
        if let picker = self.picker {
            vc?.present(picker, animated: true, completion: nil)
        }
    }
    
    //上传单照片
    private func uploadPhotosImage(images: [UIImage]) {
        HttpClient.shareInstance.request(target: BAAPI.uploadImages(images: images), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(MutiImagesResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            //增加一个头部地址
            self?.mutilImages = forceModel.data;

            if let delegate = self?.delegate {
                delegate.imagePicker(images: self?.mutilImages ?? [String](), isSuccess: true)
                self?.picker?.dismiss(animated: true, completion: nil);
            }
            
            }
        )
    }
}

//
//  UIImage+Extension.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/9.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/**
 * 图片压缩
 */
extension UIImage {
    //MARK: - 压缩图片到指定大小
    /// - Parameters:
    ///   - maxSize: 例如100 * 1024 100kb以内
    ///   - return: Data
    open func compressImageToSize(_ maxSize: Int) -> Data? {
        var compress:CGFloat = 1.0
        var data = self.jpegData(compressionQuality: compress)
        //如果图片本身大小小于maxSize就返回
//        printDebug("------------------------\(data?.count ?? 0 / 1024)KB")
        if data?.count ?? 0 < maxSize { return data }
        //压缩图片的质量优点在于可以更好的保留图片的清晰度,缺点在于可能我们compress继续
        //减少, data也不会再减小,不能保证压缩后小于指定的大小
        //为了快速压缩我们使用二分法进行优化
        var max:CGFloat = 1
        var min:CGFloat = 0
        for i in 0..<6 {
            compress = (max + min) / 2
            data = self.jpegData(compressionQuality: compress)
            //如果data.length小于maxSize * 0.9 代表data.length过小那么就让最小数变大
            //此处为何是0.9, 因为我们需要返回data的大小在出入指定大小maxSize在90% ~ 100%
            if Float(data?.count ?? 0) < (Float(maxSize) * 0.9) {
                min = compress
            } else if data?.count ?? 0 > maxSize {
                //如果data.length大于maxSize 代表data.length过大那么就让最大数变小
                max = compress
            } else {
                break
            }
        }
        //当对质量进行压缩并没有达到我们需要的大小时我们可以对照片大小进行压缩
        //压缩照片尺寸会达到我们理想的大小, 但会让照片变得相当模糊
        //判断质量压缩后的大小是否小于maxSize
//        printDebug("------------------------\(data?.count ?? 0 / 1024)KB")
        if data?.count ?? 0 < maxSize { return data }
        guard var compressData = data else {
            return nil
        }
        let image = UIImage(data: compressData)
        var lastLength = 0
        while compressData.count > maxSize && (compressData.count != lastLength) {
            lastLength = compressData.count
            //计算比例
            let ratio = Double(maxSize) / Double(compressData.count)
            //计算在比例下的size, 注意要将宽高转变成整数, 否则可能会出现图片白边的情况
            let size = CGSize(width: image?.size.width ?? 0 * CGFloat(sqrt(ratio)), height: image?.size.height ?? 0 * CGFloat(sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            UIGraphicsEndImageContext()
            compressData = image!.jpegData(compressionQuality: 1)!
        }
        return compressData
    }
    
    //MARK: - 无损压缩
    /// - Parameters:
    ///   - return: Data
    open func compressImageNoAffectQuality() -> Data? {
        var compress:CGFloat = 1
        var data = self.jpegData(compressionQuality: compress)
        //压缩图片的质量优点在于可以更好的保留图片的清晰度，缺点在于可能我们compress继续
        //减小，data也不会再减小，不能保证压缩后小于指定的大小
        //为了快速压缩我们使用二分法来进行优化循环
        var max:CGFloat = 1
        var min:CGFloat = 0
        var lastLength: Int = 0
        //此处我们最多循环六次
        for i in 0..<6 {
            compress = (min + max) / 2
            data = self.jpegData(compressionQuality: compress)
            //当我们检测到上一次图片的大小和这一次图片的大小一样,代表已经不能压缩了就跳出block
            if data?.count != lastLength {
                lastLength = data?.count ?? 0
                max = compress
//                printDebug("------------------------\(data?.count ?? 0 / 1024)KB")
            } else {
                break
            }
        }
        
        return data
    }
    
}

//
//  PhotoBrowser.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/13.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import SKPhotoBrowser

/*
 * 照片浏览器
 */
class PhotoBrowser {
    private init() {
        
    }
    
    /// 显示照片浏览器
    ///
    /// - Parameter original: 初始参数, photos: 照片的地址,
    /// - Returns: return void
    static func showImages(original: Int, photos: [String]) {
        let urlPhotos = photos.map { (image) -> SKPhoto in
            return SKPhoto.photoWithImageURL(image)
        }
        SKPhotoBrowserOptions.displayAction = false
        let browser = SKPhotoBrowser(photos: urlPhotos, initialPageIndex: original)
        let current = UIViewController.current()
        current?.present(browser, animated: true, completion: nil)
    }
}

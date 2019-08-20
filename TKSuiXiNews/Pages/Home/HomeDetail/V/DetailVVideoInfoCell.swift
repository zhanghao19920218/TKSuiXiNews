//
//  DetailVVideoInfoCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * V视频显示的Cell
 */

class DetailVVideoInfoCell: BaseTableViewCell {
    var block: VideoTappedBlock = {  }
    //视频地址
    private var _videoUrl: String?
    //获取照片地址
    var imageUrl: String? {
        willSet(value) {
            if let newValue = value {
                videoItem.kf.setImage(with: URL(string: newValue), placeholder: K_ImageName(PLACE_HOLDER_IMAGE));
            }
        }
    }
    
    //获取播放地址
    var videoUrl: String? {
        willSet(value) {
            _videoUrl = value;
        }
    }
    
    var videoItem: HomeVVideoBaseView = {
        let view = HomeVVideoBaseView(frame: .zero)
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.clipsToBounds = true
        return view;
    }();
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(videoItem);
        videoItem.snp.makeConstraints { (make) in
            make.top.equalTo(20 * iPHONE_AUTORATIO)
            make.left.equalTo(13 * iPHONE_AUTORATIO);
            make.right.equalTo(-13 * iPHONE_AUTORATIO);
            make.bottom.equalToSuperview();
        }
    }
}

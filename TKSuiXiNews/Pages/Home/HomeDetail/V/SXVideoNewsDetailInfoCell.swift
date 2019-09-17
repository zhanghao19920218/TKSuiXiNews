//
//  VideoNewsDetailInfoCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/2.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 视讯的视频播放界面
 */

class SXVideoNewsDetailInfoCell: BaseTableViewCell {

    //视频的界面
    var _videoItem: SXHomeVVideoBaseView = {
        let view = SXHomeVVideoBaseView(frame: .zero)
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.clipsToBounds = true
        return view;
    }();
    
    //获取照片地址
    var imageUrl: String? {
        willSet(value) {
            if let newValue = value {
                _videoItem.kf.setImage(with: URL(string: newValue), placeholder: K_ImageName(PLACE_HOLDER_IMAGE));
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(_videoItem)
        _videoItem.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

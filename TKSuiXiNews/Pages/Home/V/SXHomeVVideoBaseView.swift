//
//  HomeVVideoBaseView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 视频播放
 */
typealias VideoTappedBlock = (() -> Void)

class SXHomeVVideoBaseView: UIImageView {
    var videoBlock: VideoTappedBlock = { }
    
    //播放按钮
    private lazy var _playItem: UIButton = {
        let button = UIButton(type: .custom);
        button.setImage(K_ImageName("play_video"), for: .normal);
        button.addTarget(self,
                         action: #selector(playVideoItemTapped(_:)),
                         for: .touchUpInside);
        return button;
    }();
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -初始化页面播放
    private func setupUI() {
        
        image = K_ImageName(PLACE_HOLDER_IMAGE);
        
        addSubview(_playItem);
        _playItem.snp.makeConstraints { (make) in
            make.center.equalToSuperview();
            make.size.equalTo(CGSize(width: 35 * iPHONE_AUTORATIO, height: 35 * iPHONE_AUTORATIO))
        };
    }
    
    //点击播放按钮
    @objc private func playVideoItemTapped(_ sender: UIButton) {
        videoBlock();
    }
}

//
//  HomeTVDetailPlayerView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class SXHomeTVDetailPlayerView: UIView {
    var videoBlock: VideoTappedBlock = { }
    //标题
    var title:String? {
        willSet(newValue) {
            _titleLabel.text = newValue ?? "";
        }
    }
    
    //设置图片
    var imageName: String? {
        willSet(newValue) {
            if let value = newValue {
                _player.kf.setImage(with: URL(string: value), placeholder: K_ImageName(PLACE_HOLDER_IMAGE));
            }
        }
    }
    
    //新闻的播放
    private lazy var _player: SXHomeVVideoBaseView = {
        let view = SXHomeVVideoBaseView(frame: .zero);
        view.image = K_ImageName(PLACE_HOLDER_IMAGE);
        view.isUserInteractionEnabled = true
        return view;
    }();
    
    //新闻的标题
    private lazy var _titleLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(12 * iPHONE_AUTORATIO)
        return label;
    }();

    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(_player);
        _player.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.left.right.equalToSuperview()
            make.height.equalTo(94 * iPHONE_AUTORATIO);
        }
        
        _player.videoBlock = { [weak self] () in
            self?.videoBlock()
        }
        
        addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(self._player.snp_bottom).offset(10 * iPHONE_AUTORATIO);
        }
    }
}

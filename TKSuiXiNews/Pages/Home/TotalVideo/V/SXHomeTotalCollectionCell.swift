//
//  HomeTotalCollectionCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class SXHomeTotalCollectionCell: UICollectionViewCell {
    var videoBlock: () -> Void = {}
    
    var title:String? {
        willSet(newValue) {
            _view.title = newValue
        }
    }
    
    var imageName:String? {
        willSet(newValue) {
            _view.imageName = newValue
        }
    }
    
    //MARK: - 初始化view
    private lazy var _view: SXHomeTVDetailPlayerView = {
        let view = SXHomeTVDetailPlayerView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _setupUI() {
        contentView.addSubview(_view)
        _view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        _view.videoBlock = { [weak self] in
            self?.videoBlock()
        }
    }
}

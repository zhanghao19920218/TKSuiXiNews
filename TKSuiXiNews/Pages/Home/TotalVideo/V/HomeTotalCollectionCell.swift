//
//  HomeTotalCollectionCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class HomeTotalCollectionCell: UICollectionViewCell {
    var videoBlock: () -> Void = {}
    
    var title:String? {
        willSet(newValue) {
            view.title = newValue
        }
    }
    
    var imageName:String? {
        willSet(newValue) {
            view.imageName = newValue
        }
    }
    
    //MARK: - 初始化view
    private lazy var view: HomeTVDetailPlayerView = {
        let view = HomeTVDetailPlayerView()
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
        contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.videoBlock = { [weak self] in
            self?.videoBlock()
        }
    }
}

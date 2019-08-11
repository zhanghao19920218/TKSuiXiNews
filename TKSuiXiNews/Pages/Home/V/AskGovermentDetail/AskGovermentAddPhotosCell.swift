//
//  AskGovermentAddPhotosCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/10.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

//添加照片的界面

class AskGovermentAddPhotosCell: BaseTableViewCell {
    var chooseBlock: () -> Void = { }
    
    var deleteBlock: (Int) -> Void = { _ in }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.text = "添加照片"
        return label
    }()
    
    var images:[String]? {
        willSet(newValue) {
            imagesScreen.images = newValue ?? [String]()
        }
    }

    //显示图片的界面
    private lazy var imagesScreen: HomeVSendCollectionView = {
        let view = HomeVSendCollectionView();
        view.images = []
        return view;
    }()
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(17 * iPHONE_AUTORATIO)
            make.top.equalTo(20 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(imagesScreen)
        imagesScreen.snp.makeConstraints { (make) in
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.top.equalTo(53 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-15 * iPHONE_AUTORATIO)
        }
        imagesScreen.block = { [weak self] () in
            self?.chooseBlock()
        }
        imagesScreen.deleteBlock = { [weak self] (index) in
            self?.deleteBlock(index)
        }
    }
    
    

}

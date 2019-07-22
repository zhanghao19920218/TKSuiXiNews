//
//  MineUsualCollCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

//个人中心的cell
class MineUsualCollCell: UICollectionViewCell {
    var imageName: String? {
        willSet(newValue) {
            collectionImage.image = K_ImageName(newValue ?? "");
        }
    }
    
    var title:String? {
        willSet(newValue) {
            nameLabel.text = newValue ?? "";
        }
    }
    
    //图片
    private lazy var collectionImage: UIImageView = {
        let imageView = UIImageView();
        return imageView;
    }();
    
    //名称
    private lazy var nameLabel: UILabel = {
        let label = UILabel();
        label.textColor = RGBA(102, 102, 102, 1);
        label.textAlignment = .center;
        label.font = kFont(12 * iPHONE_AUTORATIO)
        return label;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(collectionImage);
        collectionImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(19 * iPHONE_AUTORATIO);
            make.size.equalTo(CGSize(width: 50 * iPHONE_AUTORATIO, height: 50 * iPHONE_AUTORATIO))
        };
        
        contentView.addSubview(nameLabel);
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(self.collectionImage.snp_bottom).offset(10 * iPHONE_AUTORATIO)
        };
    }
}

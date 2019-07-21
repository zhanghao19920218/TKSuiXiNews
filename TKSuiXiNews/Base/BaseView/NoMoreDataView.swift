//
//  NoMoreDataView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/21.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let name = "暂时没有内容";

class NoMoreDataView: UIView {
    //没有数据的照片
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView.init();
        imageView.image = K_ImageName("no_data_contain");
        return imageView;
    }();
    
    //没有数据的Label
    private lazy var label: UILabel = {
        let label = UILabel.init();
        label.font = kFont(16 * iPHONE_AUTORATIO);
        label.textColor = RGBA(102, 102, 102, 1);
        label.textAlignment = .center;
        label.text = name;
        return label;
    }();

    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        addSubview(imageView);
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview();
            make.size.equalTo(CGSize(width: 200 * iPHONE_AUTORATIO, height: 154 * iPHONE_AUTORATIO));
        }
        
        //下面的标题
        addSubview(label);
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView.snp_bottom).offset(10 * iPHONE_AUTORATIO);
            make.centerX.equalToSuperview();
        };
    }

}

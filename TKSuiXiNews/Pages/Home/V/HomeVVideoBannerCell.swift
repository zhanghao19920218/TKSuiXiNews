//
//  HomeVVideoBannerCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/21.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class HomeVVideoBannerCell: BaseTableViewCell {
    //显示一个Banner
    private lazy var banner: BannerView = {
        let banner = BannerView.init();
        return banner;
    }();

    override func setupUI() {
        super.setupUI();
        
        contentView.addSubview(banner);
        banner.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        };
    }

}

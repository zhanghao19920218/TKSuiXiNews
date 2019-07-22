//
//  ScroreItemButton.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

//积分
fileprivate let fontSize = kFont(14 * iPHONE_AUTORATIO);
fileprivate let scoreColor = RGBA(51, 51, 51, 1);
fileprivate let scoreNumColor = RGBA(153, 153, 153, 1);
class ScroreItemButton: UIButton {
    var score: String? {
        willSet(value){
            scoreNumLabel.text = value ?? "0";
        }
    }

    //积分的icon
    private lazy var iconImage:UIImageView = {
        let imageView = UIImageView.init();
        imageView.image = K_ImageName("score_icon");
        return imageView;
    }();

    //积分的Label
    private lazy var scoreLabel: UILabel = {
        let label = UILabel.init();
        label.textColor = scoreColor;
        label.font = fontSize
        label.text = "积分"
        return label;
    }();
    
    //积分的刷量
    private lazy var scoreNumLabel: UILabel = {
        let label = UILabel.init();
        label.font = fontSize;
        label.textColor = scoreNumColor
        label.text = "0"
        return label;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置页面
    private func setupUI(){
        addSubview(iconImage);
        iconImage.snp.makeConstraints { (make) in
            make.left.equalTo(26 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        };
        
        addSubview(scoreLabel);
        scoreLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview();
            make.left.equalTo(44 * iPHONE_AUTORATIO)
        };
        
        addSubview(scoreNumLabel);
        scoreNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.scoreLabel.snp_right).offset(5 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
    }
}

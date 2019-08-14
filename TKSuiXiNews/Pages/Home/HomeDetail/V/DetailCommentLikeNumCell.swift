//
//  DetailCommentLikeNumCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class DetailCommentLikeNumCell: BaseTableViewCell {
    var comment: Int? {
        willSet(value) {
            commentLabel.text = "评论 \(value ?? 0)"
        }
    }
    
    var like: Int? {
        willSet(value) {
            likeLabel.text = "赞 \(value ?? 0)"
        }
    }
    
    //评论
    private lazy var commentLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1);
        label.text = "评论 0"
        return label;
    }()
    
    private lazy var likeLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(14 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1);
        label.text = "赞 0"
        return label;
    }()

    //颜色背景
    private lazy var topSecion: UIView = {
        let view = UIView();
        view.backgroundColor = RGBA(245, 245, 245, 1);
        return view;
    }()
    
    private lazy var indicatorImg: UIImageView = {
       let view = UIImageView()
        view.image = K_ImageName("go_right")
        return view
    }()
    
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(topSecion);
        topSecion.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview();
            make.height.equalTo(15 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(likeLabel);
        likeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO);
            make.top.equalTo(self.topSecion.snp_bottom).offset(15 * iPHONE_AUTORATIO)
        }
        
        contentView.addSubview(indicatorImg)
        indicatorImg.snp.makeConstraints { (make) in
            make.right.equalTo(-14 * iPHONE_AUTORATIO)
            make.centerY.equalTo(self.likeLabel.snp_centerY)
            make.size.equalTo(CGSize(width: 6 * iPHONE_AUTORATIO, height: 10 * iPHONE_AUTORATIO))
        }
        
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.right.equalTo(indicatorImg).offset(-10 * iPHONE_AUTORATIO)
            make.centerY.equalTo(self.likeLabel.snp_centerY)
        }
        
        contentView.addSubview(bottomLine);
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO);
            make.right.equalTo(-13 * iPHONE_AUTORATIO);
            make.height.equalTo(1);
            make.bottom.equalToSuperview();
        }
    }
}

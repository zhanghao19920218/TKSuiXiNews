//
//  MineSettingTableViewCell.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class MineSettingTableViewCell: UITableViewCell {
    
    public lazy var rightSubLab : UILabel = {
        let lab = UILabel()
        lab.font = kFont(14)
        lab.textColor = RGB(170, 170, 170)
        return lab
    }()
    
    public lazy var rightLab : UILabel = {
        let lab = UILabel()
        lab.font = kFont(14)
        lab.textColor = RGB(170, 170, 170)
        return lab
    }()
    
    public lazy var iconImageView : UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    public lazy var rightImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "go_right")
        return imgView
    }()
    
    public lazy var leftLab : UILabel = {
        let lab = UILabel()
        lab.font = kFont(14)
        lab.textColor = RGB(51, 51, 51)
        return lab
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = RGB(244, 245, 247)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        let bgView = UIView()
        bgView.backgroundColor = .white
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(15)
            ConstraintMaker.right.equalTo(-15)
            ConstraintMaker.top.bottom.equalToSuperview()
        }
        
        bgView.addSubview(leftLab)
        leftLab.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(15)
            ConstraintMaker.centerY.equalToSuperview()
        }
        
        bgView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.right.equalTo(-15)
            ConstraintMaker.centerY.equalToSuperview()
        }
        
        let lineView = UIView()
        lineView.backgroundColor = RGB(244, 245, 247)
        bgView.addSubview(lineView)
        lineView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.bottom.equalToSuperview()
            ConstraintMaker.height.equalTo(1)
            ConstraintMaker.left.equalToSuperview().offset(15)
            ConstraintMaker.right.equalToSuperview().offset(-15)
        }
        
        bgView.addSubview(rightSubLab)
        rightSubLab.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.right.equalTo(rightImageView.snp.left).offset(-10)
            ConstraintMaker.centerY.equalToSuperview()
        }
        rightSubLab.isHidden = true
        
        bgView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.right.equalToSuperview().offset(-15)
            ConstraintMaker.centerY.equalToSuperview()
            ConstraintMaker.size.equalTo(CGSize(width: 50, height: 50))
        }
        iconImageView.backgroundColor = .red
        iconImageView.layer.cornerRadius = 25
        iconImageView.layer.masksToBounds = true
        iconImageView.isHidden = true
        
        bgView.addSubview(rightLab)
        rightLab.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.right.equalToSuperview().offset(-15)
            ConstraintMaker.centerY.equalToSuperview()
        }
        rightLab.isHidden = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

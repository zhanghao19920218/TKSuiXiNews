//
//  MineSettingTableViewCell.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

///设置的TableViewCell
class SXMineSettingCell: UITableViewCell {
    ///右侧副标题标签
    public lazy var _rightSubLab : UILabel = {
        let lab = UILabel()
        lab.font = kFont(14)
        lab.textColor = RGB(170, 170, 170)
        return lab
    }()
    
    ///右侧标题标签
    public lazy var _rightLab : UILabel = {
        let lab = UILabel()
        lab.font = kFont(14)
        lab.textColor = RGB(170, 170, 170)
        return lab
    }()
    
    ///显示的iconImageView
    public lazy var _iconImgView : UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    ///显示右侧的ImageView
    public lazy var _rightImgV : UIImageView = {
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
        
        bgView.addSubview(_rightImgV)
        _rightImgV.snp.makeConstraints { (ConstraintMaker) in
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
        
        bgView.addSubview(_rightSubLab)
        _rightSubLab.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.right.equalTo(_rightImgV.snp.left).offset(-10)
            ConstraintMaker.centerY.equalToSuperview()
        }
        _rightSubLab.isHidden = true
        
        bgView.addSubview(_iconImgView)
        _iconImgView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.right.equalToSuperview().offset(-15)
            ConstraintMaker.centerY.equalToSuperview()
            ConstraintMaker.size.equalTo(CGSize(width: 50, height: 50))
        }
        _iconImgView.backgroundColor = .red
        _iconImgView.layer.cornerRadius = 25
        _iconImgView.layer.masksToBounds = true
        _iconImgView.isHidden = true
        
        bgView.addSubview(_rightLab)
        _rightLab.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.right.equalToSuperview().offset(-15)
            ConstraintMaker.centerY.equalToSuperview()
        }
        _rightLab.isHidden = true
        
        
    }

}

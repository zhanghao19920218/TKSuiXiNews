//
//  MineIntegralDetailTableViewCell.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class MineIntegralDetailTableViewCell: UITableViewCell {
    
    public var model : IntegralDetailModel!{
        willSet {
            timeLab.text = "---"
            desLab.text = "---"
            statusBtn.setTitle("---", for: .normal)
        }
        didSet{
            timeLab.text = model.createtime.string
            desLab.text = model.name.string
            statusBtn.setTitle(model.symbol.string + model.amount.string, for: .normal)
        }
    }
        
    
    private lazy var statusBtn : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = kFont(14)
        btn.setTitleColor(RGB(51, 51, 51), for: .normal)
        btn.setImage("integral_detail_coin")
        return btn
    }()
    
    private lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = kFont(14)
        lab.textColor = RGB(51, 51, 51)
        return lab
    }()
    
    private lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.font = kFont(14)
        lab.textColor = RGB(51, 51, 51)
        return lab
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    func initUI() {
        self.contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(desLab)
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(timeLab.snp_right).offset(50)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(statusBtn)
        statusBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-14)
            make.centerY.equalToSuperview()
        }
        
        let lineView = UIView()
        lineView.backgroundColor = RGB(244, 244, 244)
        self.contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
            make.height.equalTo(1)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

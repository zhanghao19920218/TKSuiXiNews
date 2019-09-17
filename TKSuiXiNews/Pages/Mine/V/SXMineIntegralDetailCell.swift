//
//  MineIntegralDetailTableViewCell.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class SXMineIntegralDetailCell: UITableViewCell {
    
    public var _model : IntegralDetailModel!{
        willSet {
            _timeLabel.text = "---"
            _describeLabel.text = "---"
            _statusButton.setTitle("---", for: .normal)
        }
        didSet{
            _timeLabel.text = _model.createtime.string
            _describeLabel.text = _model.name.string
            _statusButton.setTitle(_model.symbol.string + _model.amount.string, for: .normal)
        }
    }
        
    
    private lazy var _statusButton : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = kFont(14)
        btn.setTitleColor(RGB(51, 51, 51), for: .normal)
        btn.setImage("integral_detail_coin")
        return btn
    }()
    
    private lazy var _describeLabel : UILabel = {
        let lab = UILabel()
        lab.font = kFont(14)
        lab.textColor = RGB(51, 51, 51)
        return lab
    }()
    
    private lazy var _timeLabel : UILabel = {
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
        self.contentView.addSubview(_timeLabel)
        _timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(_describeLabel)
        _describeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(_timeLabel.snp_right).offset(50)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(_statusButton)
        _statusButton.snp.makeConstraints { (make) in
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

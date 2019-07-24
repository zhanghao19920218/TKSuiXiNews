//
//  BaseTableViewCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    //增加下横线
    lazy var bottomLine: UIView = {
        let view = UIView();
        view.backgroundColor = RGBA(244, 244, 244, 1);
        return view;
    }();

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.selectionStyle = .none;
        
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化UI
    func setupUI()
    {
        
    }

}

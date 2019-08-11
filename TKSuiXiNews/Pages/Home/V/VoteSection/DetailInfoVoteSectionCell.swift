//
//  DetailInfoVoteSectionCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class DetailInfoVoteSectionCell: BaseTableViewCell {
    var currentVoteBlock: (_ id: Int, _ index: Int) -> Void = { _, _ in }
    
    var title:String = "" {
        willSet(newValue) {
            view.title = newValue
        }
    }
    
    var dataSource:[VoteOption] = [VoteOption]() {
        willSet(newValue) {
            view.dataSources = newValue
            var count = 0
            for item in newValue {
                count += item.count.int
            }
            view.totalCount = count //当前的总点击数量
        }
    }
    
    var currentIndex: Int? {
        willSet(newValue) {
            view.currentIndex = newValue
        }
    }
    
    

    private lazy var view: BaseVoteView = {
        let view = BaseVoteView()
        return view
    }()

    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalTo(10 * iPHONE_AUTORATIO)
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.bottom.equalTo(-10 * iPHONE_AUTORATIO)
        }
        
        view.currentVoteBlock = { [weak self] (id, index) in
            self?.currentVoteBlock(id, index)
        }
    }
}

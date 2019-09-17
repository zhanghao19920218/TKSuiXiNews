//
//  AwardPanelModel.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

///获奖的model
class SXAwardPanelModel {
    lazy var time:Int = {
        return 0;
    }()
    
    lazy var array: [SXRotatePanelListItemModel] = {
        return [SXRotatePanelListItemModel]()
    }()
    
    lazy var winId: Int = {
        return 0
    }()
    
    lazy var winName:String = {
       return ""
    }()
    
    lazy var score:Int = {
        return 0
    }()
}

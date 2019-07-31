//
//  AwardPanelModel.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

class AwardPanelModel {
    lazy var time:Int = {
        return 0;
    }()
    
    lazy var array: [RotatePanelListItemModel] = {
        return [RotatePanelListItemModel]()
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

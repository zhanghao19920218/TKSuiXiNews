//
//  FWPopupViewUtil.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/25.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import FWPopupView

protocol FWPopupViewUtilDelegate {
    func didSelectedPopIndex(index:Int)
}

class FWPopupViewUtil {
    static let share = FWPopupViewUtil();
    
    var delegate: FWPopupViewUtilDelegate?
    
    private init() {
        
    }
    
    //弹窗
    func popAlert() {
        let sheetView = FWSheetView.sheet(title: nil, itemTitles: ["拍摄", "从手机相册里选择"], itemBlock: { [weak self] (_, index, _) in
            if let delegate = self?.delegate {
                delegate.didSelectedPopIndex(index: index);
            }
        }, cancenlBlock: nil)
        sheetView.show();
        
    }
}

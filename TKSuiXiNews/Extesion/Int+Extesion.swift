//
//  Int+Extesion.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/11.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

extension Int {
    //MARK: - 讲TimeInterval转为小时
    func secondsToHoursMinutesSeconds() -> (hour:String, min:String, sec: String) {
        return (self / 3600 < 10 ? "0\(self / 3600)" : "\(self / 3600)",
            (self % 3600) / 60 < 10 ? "0\((self % 3600) / 60)" : "\((self % 3600) / 60)",
            (self % 3600) % 60 < 10 ? "0\((self % 3600) % 60)" : "\((self % 3600) % 60)")
    }
}

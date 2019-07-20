//
//  CounterButton.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * @class 倒计时的按钮
 */
let CountdownButtonAutoStartCounddown:Bool = true
let CountdownButtonNormalTitle:String = "发送验证码"
let CountdownButtonTotalNum:Int = 60
let CountdownButtonDisabledTitleFormat:String = "重新发送(%d秒)"
let CountdownButtonNormalTitleColor: UIColor = RGBA(255, 74, 92, 1);
let CountdownButtonDisableTitleColor: UIColor = RGBA(153, 153, 153, 1);

class CounterButton: UIButton {
    var autoStartCounddown:Bool
    var normalTitle:String
    var totalCountdownNum:Int
    var disabledTitleColor:UIColor
    var disabledTitleFormat:String
    
    var countdownTimer:Timer
    var countdownCurNum:Int
    
    override init(frame: CGRect) {
        self.autoStartCounddown = CountdownButtonAutoStartCounddown
        self.normalTitle = CountdownButtonNormalTitle
        self.totalCountdownNum = CountdownButtonTotalNum
        self.disabledTitleColor = CountdownButtonDisableTitleColor
        self.disabledTitleFormat = CountdownButtonDisabledTitleFormat
        
        self.countdownCurNum = 0
        self.countdownTimer = Timer();
        
        super.init(frame: frame)
        
        self.setTitleColor(CountdownButtonNormalTitleColor, for: .normal);
        self.titleLabel?.font = kFont(12 * iPHONE_AUTORATIO);
        
        if self.autoStartCounddown {
            self.addTarget(self, action: #selector(startCountdown), for: .touchUpInside)
        }
        
        setTitle(self.normalTitle, for:.normal)
    }
    
    convenience init(normalTitle:String, autoStartCounddown:Bool = CountdownButtonAutoStartCounddown, totalCountdownNum:Int = CountdownButtonTotalNum, countingDownTitleColor:UIColor = CountdownButtonDisableTitleColor,countingDownTitleFormat:String = CountdownButtonDisabledTitleFormat) {
        self.init(frame: CGRect.zero)
        
        self.autoStartCounddown = autoStartCounddown
        if !self.autoStartCounddown {
            self.removeTarget(self, action: #selector(startCountdown), for: .touchUpInside)
        }
        
        self.normalTitle = normalTitle
        self.setTitle(self.normalTitle, for:.normal);
        
        self.totalCountdownNum = totalCountdownNum
        
        self.disabledTitleColor = countingDownTitleColor
        self.setTitleColor(self.disabledTitleColor, for: .disabled)
        
        self.disabledTitleFormat = countingDownTitleFormat
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func startCountdown() {
        
        self.countdownCurNum = self.totalCountdownNum
        
        updateCountdownLabel()
        
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(updateCountdown), userInfo: nil, repeats: true)
        RunLoop.current.add(self.countdownTimer, forMode: .common)
    }
    
    @objc func updateCountdown() {
        self.countdownCurNum -= 1
        
        if self.countdownCurNum <= 0 {
            self.countdownTimer.invalidate()
            self.countdownCurNum  = 0
        }
        
        updateCountdownLabel()
    }
    
    func updateCountdownLabel(){
        
        DispatchQueue.main.async { [weak self] () in
            if self?.countdownCurNum == 0 {
                self?.setTitle(self?.normalTitle, for: .normal)
                self?.isEnabled = true
            }else if self?.countdownCurNum ?? 0 > 0 {
                self?.setTitle(String(format: self?.disabledTitleFormat ?? "", self?.countdownCurNum ?? 0), for: .disabled)
                self?.isEnabled = false
            }
        };
    }
    
    func stopCountdown(){
        
        self.countdownTimer.invalidate()
        
        self.countdownCurNum = 0
        
        updateCountdownLabel()
    }
}

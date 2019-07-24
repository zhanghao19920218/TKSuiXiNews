//
//  THUD.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation
import MBProgressHUD

class TAlert: NSObject {
    enum AlertType {
        case success
        case info
        case error
        case warning
    }
    
    class func show(type: AlertType, text: String) {
        if let window = UIApplication.shared.delegate?.window {
            var image: UIImage
            switch type {
            case .success:
                image = K_ImageName("success")!;
            case .info:
                image = K_ImageName("message")!;
            case .error:
                image = K_ImageName("error")!;
            case .warning:
                image = K_ImageName("alert")!;
            }
            let hud = MBProgressHUD.showAdded(to: window!, animated: true)
            hud.backgroundColor = UIColor.black
            hud.mode = .customView
            hud.customView = UIImageView(image:image)
            hud.label.text = text
            hud.hide(animated: true, afterDelay: 1.2)
        }
    }
}

class TProgressHUD {
    class func show() {
        if let window = UIApplication.shared.delegate?.window {
            let animation:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z");
            animation.fromValue = NSNumber.init(value: 0.0);
            animation.toValue = NSNumber.init(value: Double.pi * 2);
            animation.duration = 1;
            animation.autoreverses = false;
            animation.fillMode = CAMediaTimingFillMode.forwards;
            animation.repeatCount = MAXFLOAT;
            //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
            let hub = MBProgressHUD.showAdded(to: window!, animated: true);
            hub.mode = MBProgressHUDMode.indeterminate;
//            hub.bezelView.color = UIColor.black;
            let xOffset:CGFloat = hub.offset.x;
            hub.offset = CGPoint(x: xOffset, y: -80);
        }
    }
    
    class func show(text: String) {
        if let window = UIApplication.shared.delegate?.window {
            //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
            let hub = MBProgressHUD.showAdded(to: window!, animated: true);
            hub.mode = MBProgressHUDMode.indeterminate;
//            hub.bezelView.color = UIColor.black;
//            hub.label.textColor = UIColor.white;
            hub.label.text = text;
            let xOffset:CGFloat = hub.offset.x;
            hub.offset = CGPoint(x: xOffset, y: -80);
            hub.hide(animated: true, afterDelay: 1.5);
        }
    }
    
    class func hide() {
        if let window = UIApplication.shared.delegate?.window {
            MBProgressHUD.hide(for: window!, animated: true)
        }
    }
}

//
//  UIViewController+Extesion.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

extension UIViewController {
    //MARK: - 跳转的效果
    /// - Parameters:
    ///   - rootViewController: 要跳转的viewController
    static func restoreRootViewController(_ rootViewController: UIViewController) {
        typealias Animation = () -> Void; //动画的Block
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let window = appDelegate.window;
        
        let animation: Animation = {
            let oldState = UIView.areAnimationsEnabled;
            UIView.setAnimationsEnabled(false);
            window?.rootViewController = rootViewController;
            
            UIView.setAnimationsEnabled(oldState);
        };
        
        UIView.transition(with: window!,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: animation,
                          completion: nil);
    }
}

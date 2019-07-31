//
//  UIApplication+Extension.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

#if DEBUG
extension UIApplication {
    
    private class ApplicationState {
        
        static let shared = ApplicationState()
        
        var current = UIApplication.State.inactive
        
        private init() {
            let center = NotificationCenter.default
            let mainQueue = OperationQueue.main
            center.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: mainQueue) { (notification) in
                self.current = UIApplication.shared.applicationState
            }
            center.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: mainQueue) { (notification) in
                self.current = UIApplication.shared.applicationState
            }
            center.addObserver(forName: UIApplication.didFinishLaunchingNotification, object: nil, queue: mainQueue) { (notification) in
                self.current = UIApplication.shared.applicationState
            }
            center.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: mainQueue) { (notification) in
                self.current = UIApplication.shared.applicationState
            }
            center.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: mainQueue) { (notification) in
                self.current = UIApplication.shared.applicationState
            }
        }
    }
    
    @objc
    private var __applicationState: UIApplication.State {
        if Thread.isMainThread {
            return self.__applicationState
        } else {
            return ApplicationState.shared.current
        }
    }
    
    /// FIXME: -[UIApplication applicationState] called on a background thread.
    public static func mainThreadApplicationState() {
        if let originalMethod = class_getInstanceMethod(UIApplication.self, #selector(getter: applicationState)),
            let swizzledMethod = class_getInstanceMethod(UIApplication.self, #selector(getter: __applicationState)) {
            _ = ApplicationState.shared
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
#endif

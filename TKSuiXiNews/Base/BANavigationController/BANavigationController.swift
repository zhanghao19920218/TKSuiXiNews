//
//  BANavigationController.swift
//  OodsOwnMore
//
//  Created by Barry Allen on 2019/5/8.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class BANavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white;
        self.navigationBar.isTranslucent = false;
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: kFont(16.0),
                                                  NSAttributedString.Key.foregroundColor:UIColor.black];
        self.navigationBar.barTintColor = UIColor.white;
        
        if let version = UIDevice.current.systemVersion.toDouble() {
            if (version >= 7.0) {
                self.edgesForExtendedLayout = []; //视图控制器,四条边不指定
                self.extendedLayoutIncludesOpaqueBars = false; //不透明的操作栏
                self.modalPresentationCapturesStatusBarAppearance = false;
                UINavigationBar.appearance().setBackgroundImage(K_ImageName(""),
                                                                for:.top,
                                                                barMetrics: .default)
            } else {
                self.navigationBar.setBackgroundImage(K_ImageName(""),
                                                      for: .default);
            }
        }
        
        //添加手势返回
        weak var weakSelf = self;
        if (self.responds(to: #selector(getter: interactivePopGestureRecognizer))) {
            self.interactivePopGestureRecognizer?.delegate = weakSelf;
            self.delegate = weakSelf;
        }
        
        self.setupClearColorNavigationBar();
    }
    
    //MARK: 透明化标题颜色
    private func setupClearColorNavigationBar()
    {
        self.navigationBar.setBackgroundImage(UIImage.init(),
                                              for: .any,
                                              barMetrics: .default);
        
        self.navigationBar.shadowImage = UIImage.init();
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0 ) {
            viewController.hidesBottomBarWhenPushed = true;
        }
        super.pushViewController(viewController, animated: animated);
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let avc:UIViewController = super.popViewController(animated: animated) ?? UIViewController.init();
        return avc;
    }
    
    //MARK: UINavigationControllerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (self.children.count == 1) {
            return false;
        }
        return true;
    }
    
    // 我们差不多能猜到是因为手势冲突导致的，那我们就先让 ViewController 同时接受多个手势吧。
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    //解决手指在滑动的时候，被 pop 的 ViewController 中的 UIScrollView 会跟着一起滚动，这个效果看起来就很怪，而且也不是原始的滑动返回应有的效果
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self);
    }
}

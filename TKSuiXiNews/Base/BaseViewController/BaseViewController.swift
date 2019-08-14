//
//  BaseViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

typealias ParametersBlock = (_ commentNum: Int, _ reviewNum: Int, _ likeNum: Int, _ isLike: Bool) -> Void

class BaseViewController: UIViewController {
    //当前的数据
    private var duration: Int = 0
    
    open var timerTravel: Int = 0 
    
    private var timer: Timer? = nil
    
    ///评论的次数
    open lazy var commentNum:Int = {
        return 0
    }()
    
    ///观看的次数
    open lazy var reviewNum: Int = {
        return 0
    }()
    
    ///点赞的次数
    open lazy var likeNum: Int = {
        return 0
    }()
    
    
    ///是否点赞
    open lazy var isLike: Bool = {
        return false
    }()
    
    /// 传递点击数组
    /// - Parameters:
    ///   - commentNum: 点赞次数
    ///   - reviewNum: 浏览次数
    ///   - likeNum: 点赞次数
    ///   - isLike: 是否喜欢
    open var parametersBlock: ParametersBlock = { _,_,_,_ in }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI();
        
        loadData();
    }
    

    //MARK: 设置全局的背景颜色
    private func setupUI(){
        view.backgroundColor = UIColor.white;
        
        //设置导航栏的NavigationBar
        if (navigationController?.viewControllers.count ?? 0 > 1) {
            addBackImageBtnInTopBar();
        }
        //计算获取积分
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction(timer:)), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let timer = timer {
            //停止计时器
            timer.invalidate()
        }
    }
    
    open func counterAction() {
        
    }
    
    @objc private func timerAction(timer: Timer) {
        if duration == timerTravel {
            counterAction()
            timer.invalidate()
        }
        duration += 1
    }
    
    //MARK: - 更新StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    //初始化NavigationBar的Logo
    func createNavigationBarLogo()
    {
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 97 * iPHONE_AUTORATIO, height: 19 * iPHONE_AUTORATIO))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 97 * iPHONE_AUTORATIO, height: 19 * iPHONE_AUTORATIO))
        imageView.contentMode = .scaleAspectFit
        let image = K_ImageName("logo_top");
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
    }

    
    // MARK: 修改返回按钮
    private func addBackImageBtnInTopBar ()
    {
        let backB = UIButton.init();
        if StaticMethod.share.isUserLogin {
            backB.setImage("token_back_main");
        } else {
            backB.setImage("back_main");
        }
        backB.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -30, bottom: 0, right: 0);
        backB.frame = CGRect(x: 0, y: 0, width: 44, height: 44);
        backB.addTarget(self,
                        action: #selector(self.popViewControllerBtnPressed),
                        for: .touchUpInside);
        let barButton = UIBarButtonItem.init(customView: backB);
        self.navigationItem.leftBarButtonItem = barButton;
    }
    
    @objc func popViewControllerBtnPressed() {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    //基类进行网络请求
    func loadData() {

    }

}

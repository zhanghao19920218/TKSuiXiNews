//
//  NEPlayerControlView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/26.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class NEPlayerControlView: UIView {
    private var isDragging:Bool {
        get {
            return false;
        }
    }
    
    //增加控制点击的效果
    private lazy var control: UIControl = {
        let control = UIControl();
        control.addTarget(self,
                          action: #selector(tappedControlView),
                          for: .touchUpInside);
        return control;
    }();
    
    //确定是不是隐藏
    private lazy var isControlHidden:Bool = {
        return true;
    }();
    
    //设置爱奇艺按钮
    private lazy var playButton: LYCopyQIYButton = {
        let button = LYCopyQIYButton(frame: CGRect(x: K_SCREEN_WIDTH/2 - 20 * iPHONE_AUTORATIO , y: K_SCREEN_HEIGHT/2 - 20 * iPHONE_AUTORATIO, width: 40 * iPHONE_AUTORATIO, height: 40 * iPHONE_AUTORATIO), color: appThemeColor)
        button.isHidden = true;
        return button;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化页面
    private func setupUI(){
        backgroundColor = RGBA(51, 51, 51, 0.3);
        
        addSubview(control);
        control.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        
        addSubview(playButton);
        
    }
    
    //MARK: - 点击跳转控制文件
    @objc private func tappedControlView(){
        isControlHidden = !isControlHidden;
        
        playButton.isHidden = isControlHidden;
    }
}

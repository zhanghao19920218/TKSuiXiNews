//
//  RotatePanelScoreController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 转盘抽奖的Controller
 */

class RotatePanelScoreController: SXBaseViewController {
    private var _model: AwardPanelModel = AwardPanelModel()
    
    private lazy var _backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("rotate_score_back_view")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var _bottomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("rotate_score_bottom_view")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    private lazy var _titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("rotate_score_title")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var _panelView: TurntableView = {
        let view = TurntableView()
        view.block = { [weak self] () in
            self?.requestOnceTime()
        }
        return view
    }()
    
    private lazy var _indicatorL: UILabel = {
        let label = UILabel()
        label.font = kBoldFont(14 * iPHONE_AUTORATIO)
        label.text = "剩余转盘次数：0"
        label.textColor = .white
        return label
    }()
    
    private lazy var _indcatorBackView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(255, 74, 92, 1)
        view.layer.cornerRadius = 10 * iPHONE_AUTORATIO
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _setupUI()
        
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }

    //初始化页面
    private func _setupUI(){
        view.addSubview(_backgroundImage)
        _backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        _backgroundImage.addSubview(_bottomImageView)
        _bottomImageView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(472 * iPHONE_AUTORATIO)
        }
        
        _backgroundImage.addSubview(_titleImage)
        _titleImage.snp.makeConstraints { (make) in
            make.top.equalTo(89 * iPHONE_AUTORATIO)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 202 * iPHONE_AUTORATIO, height: 79 * iPHONE_AUTORATIO))
        }
        
        _bottomImageView.addSubview(_panelView)
        _panelView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-130 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 300 * iPHONE_AUTORATIO, height: 300 * iPHONE_AUTORATIO))
        }
        
        _bottomImageView.addSubview(_indcatorBackView)
        _indcatorBackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(_panelView.snp_bottom).offset(30 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 150 * iPHONE_AUTORATIO, height: 35 * iPHONE_AUTORATIO))
        }
        
        _indcatorBackView.addSubview(_indicatorL)
        _indicatorL.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    private func _startAnimation(_ result: Int) {
        var turnAngle:Double = 0
        let trunsNum = arc4random() % 5 + 1; //控制圈数
        
        if _model.array.count != 6 {
            return
        }
        
        if result == self._model.array[0].id.int {
            turnAngle = -30
        } else if result == self._model.array[1].id.int {
            turnAngle = -90
        } else if result == self._model.array[2].id.int {
            turnAngle = -150
        } else if result == self._model.array[3].id.int {
            turnAngle = -210
        } else if result == self._model.array[4].id.int {
            turnAngle = -270
        } else if result == self._model.array[5].id.int {
            turnAngle = -330
        }
        
        let perAngle = Double.pi / 180.0
        
        let rotationAnimation: CABasicAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = turnAngle * perAngle + 360.0 * perAngle * Double(trunsNum)
        rotationAnimation.duration = 3.0;
        rotationAnimation.isCumulative = true
        rotationAnimation.delegate = self
        //由快变慢
        rotationAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        _panelView._rotateWheel.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
    }
    
    
}

extension RotatePanelScoreController: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        _panelView._rotateButton.isEnabled = false
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            _panelView._rotateButton.isEnabled = true
            // 转盘结束后调用，显示获得的对应奖励
            let view = MallPopMenu(frame: CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT))
            view.score = _model.score
            view.isLottery = true
            self.view.addSubview(view)
        }
    }
}

extension RotatePanelScoreController {
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.awardProductItems, success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(RotatePanelListItemResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?._indicatorL.text = "剩余转盘次数：\(forceModel.data.num.int)"
            self?._panelView.array = forceModel.data.data
            self?._model.time = forceModel.data.num.int
            self?._model.array = forceModel.data.data
            }
        )
    }
    
    //MARK: - 点击一下请求一次
    private func requestOnceTime() {
        if _model.time == 0 {
            TProgressHUD.show(text: "您已没有抽奖次数")
            return
        }
        
        HttpClient.shareInstance.request(target: BAAPI.awardDraw, success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(AwardDrawResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?._model.time -= 1;
            self?._indicatorL.text = "剩余转盘次数：\(String(describing: self?._model.time ?? 0))"
            self?._model.winId = forceModel.data.id.int
            self?._model.winName = forceModel.data.name.string
            self?._model.score = forceModel.data.score.int
            //进行转圈
            self?._startAnimation(forceModel.data.id.int)
            }
        )
    }
}

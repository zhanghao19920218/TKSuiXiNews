//
//  ScoreRuleViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class ScoreRuleViewController: BaseViewController {
    
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
//        label.text = "关于积分兑换礼品以及每日转盘抽取积分规则关于积分兑换礼品以及每日转盘抽取积分规则"
        return label
    }()
    
    private lazy var _writerLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
//        label.text = "濉溪发布官方"
        label.textColor = RGBA(153, 153, 153, 1)
        return label
    }()
    
    private lazy var _timeLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
//        label.text = "2019年1月1日"
        label.textColor = RGBA(153, 153, 153, 1)
        return label
    }()
    
    private lazy var _contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 //Line break when the current line is full display.
//        let str = "<html><body><div style=\"font-size: 14px;color:#333\"><div>兑换规则：</div><p>1、商品兑换成功后 5 分钟内生效。</p><p>2、用户可在“兑换记录”查看兑换情况及生效情况。</p><p>3、兑换期间出现的问题及使用流程，可拨打客服线 400 123 4567 (工作日 9:00-18:00) 进行咨询。</p><br><div>重要声明：</div><p>除商品本身不能正常兑换外，商品一经兑换，一律不退还积分哦，请大家兑换前仔细参照商品介绍、有效时间、兑换说明等重要信息。</p></div></body></html>"
//        do{
//            let srtData = str.data(using: String.Encoding.unicode, allowLossyConversion: true)!
//            let strOptions = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]//Tips:Supported four types.
//            let attrStr = try NSAttributedString(data: srtData, options: strOptions, documentAttributes: nil)
//            label.attributedText = attrStr
//        }catch let error as NSError {
//            print(error.localizedDescription)
//        }
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "积分规则"
        
        _setupUI()
        
        requestScoreRule()
    }

    private func _setupUI(){
        view.addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.equalTo(25 * iPHONE_AUTORATIO)
        }
        
        view.addSubview(_writerLabel)
        _writerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.top.equalTo(_titleLabel.snp_bottom).offset(25 * iPHONE_AUTORATIO)
        }
        
        view.addSubview(_timeLabel)
        _timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.centerY.equalTo(_writerLabel.snp_centerY)
        }
        
        view.addSubview(_contentLabel)
        _contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(_writerLabel.snp_bottom).offset(25 * iPHONE_AUTORATIO)
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
        }
    }
}

extension ScoreRuleViewController {
    //MARK: - 请求积分规则
    private func requestScoreRule() {
        HttpClient.shareInstance.request(target: BAAPI.scoreRule, success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(ScoreRuleResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            //获取积分标题
            self?._titleLabel.text = forceModel.data.name.string
            self?._writerLabel.text = forceModel.data.nickname.string
            self?._timeLabel.text = forceModel.data.time.string
            
            
            //进行积分规则的获取
            let rule = forceModel.data.content.string
            do{
                let srtData = rule.data(using: String.Encoding.unicode, allowLossyConversion: true)!
                let strOptions = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]//Tips:Supported four types.
                let attrStr = try NSAttributedString(data: srtData, options: strOptions, documentAttributes: nil)
                self?._contentLabel.attributedText = attrStr
            }catch let error as NSError {
                print(error.localizedDescription)
            }
            })
    }
}

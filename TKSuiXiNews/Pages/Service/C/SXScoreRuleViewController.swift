//
//  ScoreRuleViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class SXScoreRuleViewController: SXBaseViewController {
    
    private lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(16 * iPHONE_AUTORATIO)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var _writerLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        return label
    }()
    
    private lazy var _timeLabel: UILabel = {
        let label = UILabel()
        label.font = kFont(13 * iPHONE_AUTORATIO)
        label.textColor = RGBA(153, 153, 153, 1)
        return label
    }()
    
    private lazy var _contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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

extension SXScoreRuleViewController {
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

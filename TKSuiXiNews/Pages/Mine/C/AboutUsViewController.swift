//
//  AboutUsViewController.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class AboutUsViewController: BaseViewController {
    ///下载的二维码图片
    private lazy var downLoadImageV: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "关于我们"
        
        view.backgroundColor = RGB(244, 245, 247)
        
        createView()
    }
    
    func createView() {
        
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage.init(named: "logo")
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(96 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 90 * iPHONE_AUTORATIO, height: 76 * iPHONE_AUTORATIO))
        }
        
        let nameLab = UILabel()
        nameLab.font = kFont(16)
        nameLab.textColor = RGB(51, 51, 51)
        self.view.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp_bottom).offset(15 * iPHONE_AUTORATIO)
        }
        
        let versionLab = UILabel()
        versionLab.font = kFont(12)
        versionLab.textColor = RGB(153, 153, 153)
        view.addSubview(versionLab)
        versionLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLab.snp_bottom).offset(13 * iPHONE_AUTORATIO)
        }
        
        
        let infoDictionary = Bundle.main.infoDictionary
        if let infoDictionary = infoDictionary {
            let appVersion = infoDictionary["CFBundleShortVersionString"]
            let appName = infoDictionary["CFBundleDisplayName"]
            let versionStr = appVersion as! String
            let appNameStr = appName as! String
            versionLab.text = "V" + versionStr
            nameLab.text = appNameStr
        }
        
        view.addSubview(downLoadImageV)
        downLoadImageV.snp.makeConstraints { (make) in
            make.top.equalTo(versionLab.snp_bottom).offset(50 * iPHONE_AUTORATIO)
            make.size.equalTo(CGSize(width: 120 * iPHONE_AUTORATIO, height: 120 * iPHONE_AUTORATIO))
            make.centerX.equalToSuperview()
        }
        
        let desLab = UILabel()
        desLab.font = kFont(12)
        desLab.textColor = RGB(153, 153, 153)
        desLab.numberOfLines = 2
        desLab.textAlignment = .center
        view.addSubview(desLab)
        desLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(downLoadImageV.snp_bottom).offset(73 * iPHONE_AUTORATIO)
        }
        desLab.text = "版权所有 © 2004-2019 京ICP证050806号\n京ICP备05051578号-1"
        
        //获取二维码地址
        downLoadImageV.kf.setImage(with: URL(string: DefaultsKitUtil.share.getQRAddress()), placeholder: K_ImageName(PLACE_HOLDER_IMAGE))
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

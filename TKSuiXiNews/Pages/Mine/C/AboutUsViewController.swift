//
//  AboutUsViewController.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class AboutUsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于我们"
        //设置标题为白色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.view.backgroundColor = RGB(244, 245, 247)
        createView()
    }
    
    func createView() {
        let versionLab = UILabel()
        versionLab.font = kFont(12)
        versionLab.textColor = RGB(153, 153, 153)
        self.view.addSubview(versionLab)
        versionLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        let nameLab = UILabel()
        nameLab.font = kFont(16)
        nameLab.textColor = RGB(51, 51, 51)
        self.view.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(versionLab.snp_top).offset(-10)
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
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage.init(named: "logo")
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nameLab.snp_top).offset(-20)
        }
        
        
        let desLab = UILabel()
        desLab.font = kFont(12)
        desLab.textColor = RGB(153, 153, 153)
        desLab.numberOfLines = 2
        desLab.textAlignment = .center
        self.view.addSubview(desLab)
        desLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(versionLab.snp_bottom).offset(100)
        }
        desLab.text = "版权所有 © 2004-2019 京ICP证050806号\n京ICP备05051578号-1"
        
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

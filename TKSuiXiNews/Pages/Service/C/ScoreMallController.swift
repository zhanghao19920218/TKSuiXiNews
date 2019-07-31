//
//  ScoreMallController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 积分商城
 */

class ScoreMallController: BaseCollectionViewController {
    private lazy var topView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K_ImageName("mine_info_back")
        return imageView
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _setupUI()
        
        navigationItem.title = "积分商城"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }

    //MARK: - 初始化
    private func _setupUI() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(311 * iPHONE_AUTORATIO);
        }
    }
}

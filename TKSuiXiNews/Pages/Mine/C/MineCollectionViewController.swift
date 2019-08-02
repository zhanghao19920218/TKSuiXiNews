//
//  MineCollectionViewController.swift
//  TKSuiXiNews
//
//  Created by 途酷 on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

class MineCollectionViewController: BaseViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        //设置标题为白色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    //MARK: - 更新StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
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

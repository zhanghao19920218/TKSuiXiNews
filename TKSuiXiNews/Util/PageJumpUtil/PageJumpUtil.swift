//
//  PageJumpUtil.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/27.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import Foundation

///页面跳转的Util
class PageJumpUtil {
    static let share = PageJumpUtil()
    
    private init() {
        
    }
    
    ///Banner选择跳转的VC
    open func jumpVCAccording(_ model: BannerArticleInfoModel, _ id: TStrInt) {
        let currentVC = UIViewController.current()
        if model.module.string == "V视频" {
            let vc = SXDetailVideoInfoController();
            vc.id = id.string
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else if model.module.string == "濉溪TV" {
            let vc = SXVideoNewsDetailController()
            vc.id = id.string
            vc.timerTravel = 360
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else if model.module.string == "新闻" {
            let vc = SXHomeNewsDetailInfoController();
            vc.id = id.string
            vc.title = "新闻"
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else if model.module.string == "视讯" {
            let vc = SXVideoNewsDetailController()
            vc.id = id.string
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else if model.module.string == "问政" {
            let vc = SXDetailAskGovementController();
            vc.id = id.string
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else if model.module.string == "公告" {
            let vc = SXDetailAskGovementController()
            vc.id = id.string
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else if model.module.string == "直播" {
            let vc = SKOnlineNewsShowController()
            vc.id = id.string
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else if model.module.string == "原创" {
            if model.images?.count ?? 0 == 0 {
                //原创的视频页面
                let vc = SXDetailVideoInfoController()
                vc.id = id.string
                currentVC?.navigationController?.pushViewController(vc, animated: true)
            } else {
                //图文页面
                let vc = SXShowDetailImageViewController();
                vc.id = id.string
                currentVC?.navigationController?.pushViewController(vc, animated: true)
            }
        } else if model.module.string == "悦读" {
            let vc = SXHomeNewsDetailInfoController();
            vc.id = id.string
            vc.title = "悦读"
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else if model.module.string == "悦听" {
            let vc = SXHomeHappyDetailListenController()
            vc.id = id.string
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else if model.module.string == "矩阵" {
            let vc = SXHomeNewsDetailInfoController()
            vc.id = id.string
            vc.title = "矩阵"
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else if model.module.string == "党建" {
            let vc = SXHomeNewsDetailInfoController();
            vc.id = id.string
            vc.title = "党建"
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else if model.module.string == "专栏" {
            let vc = SXHomeNewsDetailInfoController();
            vc.id = model.id.string
            vc.title = "专栏"
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = SXHomeNewsDetailInfoController();
            vc.id = id.string
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

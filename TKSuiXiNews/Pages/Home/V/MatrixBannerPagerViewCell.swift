//
//  MatrixBannerPagerViewCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/9.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import FSPagerView

/*
 *  矩阵的Banner Cell
 */
fileprivate let cellIdentifier = "BannerMatrixSingleCellIdentifier"

class MatrixBannerPagerViewCell: BaseTableViewCell {
    
    //获取的索引
    private var _selectedIndex:(Column: Int, Row:Int)?

//    var dataSources:[HomeVVideoBannerDatum]? {
//        willSet(newValue) {
//            imageNames = newValue ?? []
//            pageControl.numberOfPages = imageNames.count
//            pageView.reloadData()
//        }
//    }
    
//    private lazy var imageNames:Array<HomeVVideoBannerDatum> = {
//        let array = Array<HomeVVideoBannerDatum>();
//        return array;
//    }();
//
    
    
    private lazy var pageView: FSPagerView = {
        let pageView = FSPagerView.init();
        pageView.register(BannerMatrixSingleCell.self, forCellWithReuseIdentifier: cellIdentifier);
        pageView.itemSize = CGSize(width: K_SCREEN_WIDTH, height: 139 * iPHONE_AUTORATIO)
        pageView.delegate = self;
        pageView.dataSource = self
        return pageView;
    }();
    
    private lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl();
        pageControl.contentHorizontalAlignment = .center
        pageControl.numberOfPages = 2
        pageControl.setFillColor(RGBA(255, 74, 92, 1), for: .selected)
        pageControl.setFillColor(RGBA(245, 245, 245, 1), for: .normal)
        return pageControl;
    }()
    
    //初始化页面
    override func setupUI(){
        contentView.addSubview(pageView);
        pageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        };
        
        pageView.addSubview(pageControl);
        pageControl.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview();
            make.height.equalTo(30 * iPHONE_AUTORATIO);
        };
    }
    

}

extension MatrixBannerPagerViewCell: FSPagerViewDelegate, FSPagerViewDataSource {
    // MARK:- FSPagerView DataSource
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 2
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//        let model = imageNames[index]
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, at: index) as! BannerMatrixSingleCell
        cell.selectedBlock = { [weak self] (selectIndex) in
            self?._selectedIndex = (Column: index, Row:selectIndex)
            self?.pageView.reloadData() //刷新页面
        }
        if index == _selectedIndex?.Column { cell._selectedIndex = _selectedIndex?.Row } else { cell._selectedIndex = nil }
        cell.isShowShadow = false
        cell._isReload = true
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        let model = imageNames[index]
//        pagerView.deselectItem(at: index, animated: true)
//        pagerView.scrollToItem(at: index, animated: true)
//        block(model)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}

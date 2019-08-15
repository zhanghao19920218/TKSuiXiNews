//
//  HomeSpecialSectionBannerCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/10.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import FSPagerView

fileprivate let cellIdentifier = "SpecialHomeTitleBannerCellIdentifier"

class HomeSpecialSectionBannerCell: BaseTableViewCell {
    //获取当前的页数
    private var _currentPageNum: Int = 0
    
    //当前选中的Block
    var currentBlock:(String) -> Void = { _ in }
    
    //获取的索引
    private var _selectedIndex:(Column: Int, Row:Int)?
    
    var dataSources: [ArticleAdminModelDatum] = [ArticleAdminModelDatum]() {
        willSet(newValue) {
            _currentPageNum = (Int((newValue.count - 1)/8) + 1)//获取页数
            pageControl.numberOfPages = _currentPageNum
            pageView.reloadData()
        }
    }
    
    
    private lazy var pageView: FSPagerView = {
        let pageView = FSPagerView.init();
        pageView.register(SpecialHomeTitleBannerCell.self, forCellWithReuseIdentifier: cellIdentifier);
        pageView.itemSize = CGSize(width: K_SCREEN_WIDTH, height: 238 * iPHONE_AUTORATIO)
        pageView.delegate = self;
        pageView.dataSource = self
        return pageView
    }();
    
    private lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl();
        pageControl.contentHorizontalAlignment = .center
        pageControl.setFillColor(RGBA(255, 74, 92, 1), for: .selected)
        pageControl.setFillColor(RGBA(245, 245, 245, 1), for: .normal)
        pageControl.numberOfPages = 2
        return pageControl;
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBA(245, 245, 245, 1)
        return view
    }()
    
    //初始化页面
    override func setupUI(){
        contentView.addSubview(pageView);
        pageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-15 * iPHONE_AUTORATIO)
        };
        
        pageView.addSubview(pageControl);
        pageControl.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(30 * iPHONE_AUTORATIO)
        };
        
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(15 * iPHONE_AUTORATIO)
        }
    }
    
    
}

extension HomeSpecialSectionBannerCell: FSPagerViewDelegate, FSPagerViewDataSource {
    // MARK:- FSPagerView DataSource
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return _currentPageNum
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, at: index) as! SpecialHomeTitleBannerCell
        cell.isShowShadow = false
        cell.selectedBlock = { [weak self] (selectIndex) in
            self?._selectedIndex = (Column: index, Row:selectIndex)
            let model = self?.dataSources[index * 4 + selectIndex]
            let result = model?.nickname.string ?? ""
            self?.currentBlock(result)
            self?.pageView.reloadData() //刷新页面
        }
        if index == _selectedIndex?.Column { cell._selectedIndex = _selectedIndex?.Row } else { cell._selectedIndex = nil }
        cell.isShowShadow = false
        cell._isReload = true
        //如果当前不是最后一个页面就是4个
        if dataSources.count == 0 {
            return cell
        }
        if index == (_currentPageNum - 1) { //最后一个页面
            //首位
            let firstIndex = index * 8
            let lastIndex = dataSources.count - 1;
            cell.dataSource = Array(dataSources[firstIndex...lastIndex])
            cell._isReload = true
        } else {
            //首位
            let firstIndex = index * 8
            //尾位
            let lastIndex = (firstIndex + 7)
            cell.dataSource = Array(dataSources[firstIndex...lastIndex])
            cell._isReload = true
        }
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


//
//  BannerView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/21.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import FSPagerView
import Kingfisher

class BannerView: UIView,FSPagerViewDelegate, FSPagerViewDataSource {
    fileprivate var numberOfItems = 7
    lazy var imageNames:Array<String> = {
        let array = Array<String>();
        return array;
    }();

    private lazy var pageView: FSPagerView = {
        let pageView = FSPagerView.init();
        pageView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell");
        pageView.itemSize = FSPagerView.automaticSize;
        pageView.delegate = self;
        pageView.dataSource = self;
        return pageView;
    }();

    private lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl();
        pageControl.numberOfPages = 7
        pageControl.contentHorizontalAlignment = .right
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return pageControl;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化页面
    private func setupUI(){
        addSubview(pageView);
        pageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        };
        
        pageView.addSubview(pageControl);
        pageControl.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview();
            make.height.equalTo(25 * iPHONE_AUTORATIO);
        };
    }
    
    // MARK:- FSPagerView DataSource
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.numberOfItems
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.kf.setImage(with: URL(string: "https://cdn.jiemodui.com/img/Public/Uploads/item/20190424/1556091557677850.png"));
        cell.textLabel?.text = "安徽高考：6月23日放榜26日填志愿";
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
//        cell.textLabel?.text = index.description+index.description
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}

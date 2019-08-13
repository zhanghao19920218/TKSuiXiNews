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
    var block: (HomeVVideoBannerDatum) -> Void = { _ in }
    
    var dataSources:[HomeVVideoBannerDatum]? {
        willSet(newValue) {
            imageNames = newValue ?? []
            pageControl.numberOfPages = imageNames.count
            pageView.reloadData()
        }
    }
    
    private lazy var imageNames:Array<HomeVVideoBannerDatum> = {
        let array = Array<HomeVVideoBannerDatum>();
        return array;
    }();
    
    

    private lazy var pageView: FSPagerView = {
        let pageView = FSPagerView.init();
        pageView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell");
        pageView.itemSize = FSPagerView.automaticSize;
        pageView.delegate = self;
        pageView.dataSource = self
        pageView.automaticSlidingInterval = 3
        pageView.isInfinite = true
        return pageView;
    }();

    private lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl();
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
        return self.imageNames.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let model = imageNames[index]
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.kf.setImage(with: URL(string: model.image.string));
        cell.textLabel?.text = model.name.string
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let model = imageNames[index]
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        block(model)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}

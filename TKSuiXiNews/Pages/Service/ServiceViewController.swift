//
//  ServiceViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "ServiceSingleNameCellIdentifier";
fileprivate let sectionHeaderIdentifier = "ServiceSectionHeaderIdentifier"
fileprivate let sectionHeaderSupplement = "UICollectionElementKindSectionHeader"

fileprivate let layoutWidth = K_SCREEN_WIDTH/2
fileprivate let layoutHeight = 91 * iPHONE_AUTORATIO

class ServiceViewController: BaseViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: layoutWidth, height: layoutHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0;
        layout.headerReferenceSize = CGSize(width: K_SCREEN_WIDTH, height: 50 * iPHONE_AUTORATIO)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout);
        collectionView.register(ServiceSingleNameCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ServiceCollectionHeader.self, forSupplementaryViewOfKind: sectionHeaderSupplement, withReuseIdentifier: sectionHeaderIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white;
        
        //header注册
        
        return collectionView;
    }();
    
    private lazy var dataSource: Array<ServerListModelSectionItem> = {
        let array = Array<ServerListModelSectionItem>();
        return array;
    }();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createNavigationBarLogo();
        
        navigationController?.navigationBar.barTintColor = appThemeColor;
        
        setupUI()
        
        getLocaleJson() //获取本地数据
    }
    
    //MARK: - 服务页面CollectionView
    private func setupUI(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview();
            make.bottom.equalTo(-TAB_BAR_HEIGHT)
        }
    }

    //获取本地Json文件
    private func getLocaleJson(){
        //获取本地json文件路径
        guard let path = Bundle.main.path(forResource: "servicelist", ofType: "json") else {
            print("加载本地JSON数据失败");
            return;
        }
        let jsonUrl = URL(fileURLWithPath: path);
        //使用方法throw出来
        do {
            /*
             * try 和 try! 的区别
             * try 发生异常会跳到catch代码中
             * try! 发生异常程序会直接crash
             */
            let data = try Data(contentsOf: jsonUrl);
            let decoder = JSONDecoder()
            guard let model = try? decoder.decode(ServerListModel.self, from: data) else {
                print("读取本地数据出现错误!");
                return;
            }
            
            self.dataSource = model.data;
            self.collectionView.reloadData();
            
            
        } catch {
            print("读取本地数据出现错误!", error)
        }
    }
}

extension ServiceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].data.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource[indexPath.section].data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ServiceSingleNameCell
        cell.imageName = model.imagename;
        cell.title = model.title;
        cell.subTitle = model.subTitle;
        return cell
    }
    
    //这个是设定header和footer的方法，根据kind不同进行不同的判断即可
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == sectionHeaderSupplement {
            let resuableView = collectionView.dequeueReusableSupplementaryView(ofKind: sectionHeaderSupplement, withReuseIdentifier: sectionHeaderIdentifier, for: indexPath) as! ServiceCollectionHeader
            resuableView.imageName = dataSource[indexPath.section].name
//            resuableView.imageName = "section_collection_header"
            return resuableView
        }

        fatalError()
    }
    
}

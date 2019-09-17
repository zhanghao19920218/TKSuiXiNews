//
//  ServiceViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/20.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let singlenameIdentifier = "ServiceSingleNameCellIdentifier";
fileprivate let sectionHeaderIdentifier = "ServiceSectionHeaderIdentifier"
fileprivate let sectionHeaderSupplement = "UICollectionElementKindSectionHeader"
fileprivate let sxscoreMallCellIdentifier = "ServiceScoreImageCellIdentifier"

fileprivate let layoutWidth = K_SCREEN_WIDTH/2
fileprivate let layoutHeight = 91 * iPHONE_AUTORATIO

///用户服务界面的Controller
class SXServiceViewController: SXBaseViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0;
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout);
        collectionView.register(SXServiceSingleNameCell.self, forCellWithReuseIdentifier: singlenameIdentifier)
        collectionView.register(SXServiceCollectionHeader.self, forSupplementaryViewOfKind: sectionHeaderSupplement, withReuseIdentifier: sectionHeaderIdentifier)
        collectionView.register(SXServiceScoreImageCell.self, forCellWithReuseIdentifier:  sxscoreMallCellIdentifier);
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        //header注册
        return collectionView
    }();
    
    private lazy var dataSource: Array<SXServerListModelSectionData> = {
        let array = Array<SXServerListModelSectionData>()
        return array
    }();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNaviBarLogo();
        
        navigationController?.navigationBar.barTintColor = appThemeColor;
        
        setupUI()
        
        _getLocalJsonFile() //获取本地数据
        
        configureNavigationBar()
    }
    
    //初始化navigationBar
    private func configureNavigationBar()
    {
        //设置标题为白色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    //MARK: - 更新StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    //MARK: - 服务页面CollectionView
    private func setupUI(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    //获取本地Json文件
    private func _getLocalJsonFile(){
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
            guard let model = try? decoder.decode(SXServerListModel.self, from: data) else {
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

extension SXServiceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if DefaultsKitUtil.share.isShowServer {
            return dataSource.count + 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return dataSource[section-1].data.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sxscoreMallCellIdentifier, for: indexPath) as! SXServiceScoreImageCell
            cell.imageName = "rotate_mall_cell_img"
            return cell
        }
        
        let model = dataSource[indexPath.section-1].data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: singlenameIdentifier, for: indexPath) as! SXServiceSingleNameCell
        cell.imageName = model.imagename;
        cell.title = model.title;
        cell.subTitle = model.subTitle;
        return cell
    }
    
    //这个是设定header和footer的方法，根据kind不同进行不同的判断即可
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            return UICollectionReusableView()
        }
        if kind == sectionHeaderSupplement {
            let resuableView = collectionView.dequeueReusableSupplementaryView(ofKind: sectionHeaderSupplement, withReuseIdentifier: sectionHeaderIdentifier, for: indexPath) as! SXServiceCollectionHeader
            resuableView.imageName = dataSource[indexPath.section - 1].name
            return resuableView
        }

        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let model = dataSource[indexPath.section - 1].data[indexPath.row]
            let vc = SXServiceWKWebViewController()
            navigationController?.pushViewController(vc, animated: true)
            vc.loadUrl = model.url
        } else {
            let vc = SXScoreMallController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: K_SCREEN_WIDTH, height: K_SCREEN_WIDTH)
        }
        
        return CGSize.init(width: layoutWidth, height: layoutHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 0, height: 0);
        }
        
        return CGSize(width: K_SCREEN_WIDTH, height: 50 * iPHONE_AUTORATIO)
    }
}

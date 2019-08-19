//
//  HomeHappyListenController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 悦听
 */
fileprivate let cellIdentifier = "HomeHappyListenCellIdentifier"

class HomeHappyListenController: BaseTableViewController {
    //当前选中的indexPath.row
    private var _selectedIndex: Int?
    
    //当前播放的时间
    private var _musicCurrentTime: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AudioPlayerSample.share.pause()
        
        _selectedIndex = nil
        
        tableView.reloadData()
    }
    
    
    //初始化页面
    private func setupUI() {
        tableView.register(HomeHappyListenCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
        tableView.backgroundColor = RGBA(245, 245, 245, 1)
    }
    
    override func loadData() {
        super.loadData();
        
        requestData(); //请求数据
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //刷线删除数据
        _selectedIndex = nil
        _musicCurrentTime = nil
        
        //关闭音乐
        AudioPlayerSample.share.pause()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "悦听", page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeHappyReadResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.reloadData();
            }, failure:{ [weak self] () in
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.reloadData();
            }
        )
    };
    
    
    override func pullUpLoadMoreData() {
        super.pullUpLoadMoreData()
        
        page = (page == 1 ? 2 : page);
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "悦听", page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeHappyReadResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            if forceModel.data.data.count != 0 {
                //页数+1
                self?.page += 1;
                self?.dataSource += forceModel.data.data;
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.reloadData();
            } else {
                //没有更多数据
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            }, failure:{ [weak self] () in
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.reloadData();
            }
        )
    }

}

extension HomeHappyListenController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row] as! HomeHappyReadListItemModel
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HomeHappyListenCell
        cell.title = model.name.string
        //确定是不是播放中
        if let index = _selectedIndex, index == indexPath.row {
            cell.isPlay = true
            cell.audioLength = _musicCurrentTime
        } else {
            cell.isPlay = false
            cell.audioLength = model.time.int
        }
        cell.beginTime = model.begintime.string
        cell.likeNum = model.likeNum.int
        cell.review = model.visitNum.int
        cell.isLike = model.likeStatus.int
        cell.block = { [weak self] (isPlay) in
            OperationQueue.main.addOperation {
                self?.tableView.reloadData() //刷新页面
                AudioPlayerSample.share.url = model.audio.string
                if isPlay {
                    //判断是不是在播放音频
                    self?._selectedIndex = nil
                    self?._musicCurrentTime = nil
                    AudioPlayerSample.share.pause()
                    self?.tableView.reloadRows(at: [indexPath], with: .none)
                } else {
                    //判断是不是在播放音频
                    self?._selectedIndex = indexPath.row //确定选中的index
                    AudioPlayerSample.share.play(timeChangeBlock: { [weak self] (time) in
                        self?._musicCurrentTime = time
                        if self?.dataSource.count ?? 0 > indexPath.row {
                            self?.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    })
                }
            }
            
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187 * iPHONE_AUTORATIO
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as! HomeHappyReadListItemModel
        let vc = HomeHappyDetailListenController()
        vc.id = model.id.string
        navigationController?.pushViewController(vc, animated: true)
        //如果取消点赞或者成功点赞刷新页面
        vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
            //获取要刷新的索引
            let indexPaths = [indexPath]
            //更新索引的数据
            var changeModel = self?.dataSource[indexPath.row] as! HomeHappyReadListItemModel
            changeModel.visitNum.int = review
            changeModel.likeStatus.int = (likeStatus ? 1 : 0)
            changeModel.likeNum.int = like
            self?.dataSource[indexPath.row] = changeModel
            //刷新页面
            self?.tableView.reloadRows(at: indexPaths, with: .none)
        }
    }
}

extension HomeHappyListenController {
    //MARK: - 请求数据
    private func requestData() {
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "悦听", page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeHappyReadResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data
            self?.tableView.reloadData()
            }
        )
    }
}

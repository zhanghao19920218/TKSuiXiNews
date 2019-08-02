//
//  HomeBannerDetailViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/2.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import WebKit

class HomeBannerDetailViewController: BaseViewController {

    //MARK: - 加载网页
    var loadUrl: String? {
        willSet(newValue) {
            if let value = newValue {
                //加载网页
                let string = ("<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>" + "<body>" + value + "</body>")
                webView.loadHTMLString(string, baseURL: nil)
            }
        }
    }
    
    var name:String? {
        willSet(newValue) {
            navigationItem.title = newValue ?? ""
        }
    }
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: config)
        //UI代理
        webView.uiDelegate = self
        //导航代理
        webView.navigationDelegate = self
        // 是否允许手势左滑返回上一级,  类似导航控制的左滑动返回
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    //设置喜欢的preferecn
    private lazy var preference: WKPreferences = {
        let preference = WKPreferences()
        //最小字体大小 当将JavaScriptEnabled属性设置为NO, 可以看到明显效果
        preference.minimumFontSize = 9.0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = true
        // 在IOS上默认为NO, 表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = false
        return preference
    }()
    
    //设置配置
    private lazy var config: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preference
        //是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        configuration.allowsInlineMediaPlayback = true
        //设置视频是否需要用户手动播放  设置为NO则允许自动播放
        configuration.requiresUserActionForMediaPlayback = false
        //设置是否允许画中画技术 在特定设备上有效
        configuration.allowsPictureInPictureMediaPlayback = true
        //这个类主要用来做native与JavaScript的交互管理
        let wkUController = WKUserContentController()
        configuration.userContentController = wkUController
        return configuration
    }()
    
    //设置进度条
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = appThemeColor
        progressView.progressViewStyle = .default
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //消除监听
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    private func _setupUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        webView.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(5)
        }
        
        //MARK: - 添加监测网页加载进度的观察者
        webView.addObserver(self,
                            forKeyPath: "estimatedProgress",
                            options: [],
                            context: nil)
    }
}

extension HomeBannerDetailViewController: WKUIDelegate, WKNavigationDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.isHidden = false
            progressView.progress = Float(webView.estimatedProgress)
            if webView.estimatedProgress >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [weak self] () in
                    self?.progressView.progress = 0; //重新为0
                    self?.progressView.isHidden = true
                }
            }
            
        } else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //如果是跳转一个新页面
        if navigationAction.targetFrame == nil {
            if let newUrl = navigationAction.request.url?.absoluteString.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "`#%^{}\"[]|\\<> ").inverted) {
                if let url = URL(string: newUrl) {
                    print(url);
                    webView.load(URLRequest(url: url))
                }
            }
        }
        
        decisionHandler(.allow)
    }
}

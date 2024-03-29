//
//  TKRuleController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/12.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import WebKit

///用户协议的Controller
class SXUserRuleController: SXBaseViewController {
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        
        navigationItem.title = "用户协议"
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
        preference.minimumFontSize = 14 * iPHONE_AUTORATIO;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = false
        // 在IOS上默认为NO, 表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = false
        return preference
    }()
    
    //设置配置
    private lazy var config: WKWebViewConfiguration = {
        //图片自适应
        let jScrpit = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}"
        let wkUScript = WKUserScript(source: jScrpit, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preference
        //是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        configuration.allowsInlineMediaPlayback = true
        //设置视频是否需要用户手动播放  设置为NO则允许自动播放
        configuration.requiresUserActionForMediaPlayback = false
        //设置是否允许画中画技术 在特定设备上有效
        configuration.allowsPictureInPictureMediaPlayback = true
        //这个类主要用来做native与JavaScript的交互管理
        //        let wkUController = WKUserContentController()
        configuration.userContentController = wkUController
        return configuration
    }()
    
    
    private func setupUI() {
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

extension SXUserRuleController: WKUIDelegate, WKNavigationDelegate {
    
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
    
    ///更新用户的字体
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '85%'", completionHandler: nil)
    }
}

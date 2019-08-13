//
//  HomeArticleContentWebCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/2.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import WebKit

fileprivate let keyPaths = "contentSize"

class HomeArticleContentWebCell: BaseTableViewCell {
    var block: (CGFloat) -> Void = { _ in }
    
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
    
    //判断高度进行监听,如果最大就不改变
    private var _webFrameHeight: CGFloat = 0

    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: config)
        //UI代理
        webView.uiDelegate = self
        //导航代理
        webView.navigationDelegate = self
        // 是否允许手势左滑返回上一级,  类似导航控制的左滑动返回
        webView.allowsBackForwardNavigationGestures = false
        // 不给用户手动交互
        webView.isUserInteractionEnabled = false
        //不可以滑动
        webView.scrollView.isScrollEnabled = false
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
    
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
            make.top.bottom.equalToSuperview()
        }
        
        //使用kvo为webview添加监听，监听webView内容高度
        webView.scrollView.addObserver(self, forKeyPath: keyPaths, options: [.new], context: nil)
    }
    
    deinit {
        //移除监听
        webView.scrollView.removeObserver(self, forKeyPath: keyPaths)
    }

}

extension HomeArticleContentWebCell: WKUIDelegate, WKNavigationDelegate {
    
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '85%'", completionHandler: nil)
    }
    
    
}

extension HomeArticleContentWebCell {
    //MARK: - 监听高度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == keyPaths {
            var frame = webView.frame
            frame.size.height = webView.scrollView.contentSize.height
            if _webFrameHeight != frame.size.height {
                block(frame.size.height)
                _webFrameHeight = frame.size.height
            } else {
                _webFrameHeight = frame.size.height
            }
        }
    }
}

//
//  WebItem.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/19.
//

import Foundation
import WebKit
import Foundation

class WebItem: NSObject, ObservableObject {
    init(webView: WKWebView, isSelect: Bool) {
        self.webView = webView
        self.isSelect = isSelect
    }
    var webView: WKWebView
    var isSelect: Bool
    var isNavigation: Bool {
        return webView.url == nil
    }
    
    static func == (lhs: WebItem, rhs: WebItem) -> Bool {
        return lhs.webView == rhs.webView
    }
}

extension WebItem {
    static var navigation: WebItem {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return WebItem(webView: webView, isSelect: true)
    }
    
    func load(_ url: String) {
        webView.navigationDelegate = self
        if url.isUrl, let Url = URL(string: url) {
            let request = URLRequest(url: Url)
            webView.load(request)
        } else {
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let reqString = "https://www.google.com/search?q=" + urlString
            self.load(reqString)
        }
    }
    
    func stopLoad() {
        webView.stopLoading()
    }
    
    func goBack() {
        webView.goBack()
    }
    
    func goForword() {
        webView.goForward()
    }
}

extension WebItem: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        return nil
    }
}

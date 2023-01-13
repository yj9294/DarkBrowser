//
//  Command.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/16.
//

import Foundation
import Combine
import UIKit

protocol Command {
    func execute(in store: Store)
}

class SubscriptionToken {
    var cancelable: AnyCancellable?
    func unseal() { cancelable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancelable = self
    }
}

struct LaunchCommand: Command {
    func execute(in store: Store) {
        let token = SubscriptionToken()
        store.dispatch(.launchProgress(0.0))
        var isShowAD = false
        store.state.launch.duration = 2.5 / 0.6
        Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink { _ in
            let iv =  store.state.launch.duration / 0.01
            let progress = store.state.launch.progress + 1 / iv
            store.dispatch(.launchProgress(progress))
            if progress > 1.0 {
                token.unseal()
                store.dispatch(.adShow(.interstitial) { _ in
                    if store.state.launch.progress >= 1.0 {
                        store.dispatch(.launched)
                        store.dispatch(.adLoad(.interstitial))
//                        store.dispatch(.adLoad(.native))
                    }
                })
            }
            
            if store.state.ad.isLoaded(.interstitial), isShowAD {
                isShowAD = false
                store.state.launch.duration = 0.1
            }
        }.seal(in: token)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            isShowAD = true
            store.state.launch.duration = 16
        }
        
        store.dispatch(.adLoad(.interstitial))
        store.dispatch(.adLoad(.native))
    }
}

struct WebViewCommand: Command {
    func execute(in store: Store) {
        
        store.dispatch(.homeSearchText(""))
        
        let webView = store.state.home.item.webView

        let goback = webView.publisher(for: \.canGoBack).sink { canGoBack in
            store.dispatch(.homeCanGoback(canGoBack))
        }
        
        let goForword = webView.publisher(for: \.canGoForward).sink { canGoForword in
            store.dispatch(.homeCanGoForword(canGoForword))
        }
        
        let isLoading = webView.publisher(for: \.isLoading).sink { isLoading in
            store.dispatch(.homeLoading(isLoading))
        }
        
        var start = Date()
        let progress = webView.publisher(for: \.estimatedProgress).sink { progress in
            if progress == 0.1 {
                start = Date()
                store.dispatch(.loE(.loading))
            }
            if progress == 1.0 {
                let time = Date().timeIntervalSince1970 - start.timeIntervalSince1970
                store.dispatch(.loE(.loaded, ["lig": "\(ceil(time))"]))
            }
            store.dispatch(.homeProgress(progress))
        }
        
        let isNavigation = webView.publisher(for: \.url).map{$0 == nil}.sink { isNavigation in
            store.dispatch(.homeNavigation(isNavigation))
        }
        
        let url = webView.publisher(for: \.url).compactMap{$0}.sink { url in
            store.dispatch(.homeSearchText(url.absoluteString))
        }
        
        store.disposeBag = [goback, goForword, isLoading, progress, isNavigation, url]
    }
}

struct HomeSearchCommand: Command {
    func execute(in store: Store) {
        let url = store.state.home.searchText
        if url.count == 0 {
            store.dispatch(.alert("Please enter your search content."))
            return
        }
        store.state.home.item.load(url)
    }
}


struct CleanCommand: Command {
    func execute(in store: Store) {
        let token = SubscriptionToken()
        let token1 = SubscriptionToken()
        var isShowAD = false
        var duration = 16.0
        var progress = 0.0
        Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink { _ in
            let iv =  duration / 0.01
            progress = progress + 1 / iv
            if AppEnterbackground {
                token.unseal()
                store.dispatch(.cleanShow(false))
                return
            }
            if progress > 1.0 {
                token.unseal()
                if AppEnterbackground || store.state.root.showLaunch {
                    store.dispatch(.cleanShow(false))
                    return
                }
                store.dispatch(.adShow(.interstitial) { _ in
                    store.dispatch(.loE(.cleanAnimation))
                    store.dispatch(.cleanShow(false))
                    store.dispatch(.alert("Clean successfully."))
                    store.dispatch(.loE(.cleanAlert))
                    store.dispatch(.webItemClean)
                    store.dispatch(.homeReloadWebView)
                })
            }
            
            if store.state.ad.isLoaded(.interstitial), isShowAD {
                isShowAD = false
                duration = 0.1
            }
        }.seal(in: token)
        
        Timer.publish(every: 2.5, on: .main, in: .common).autoconnect().sink { _ in
            token1.unseal()
            isShowAD = true
        }.seal(in: token1)
        
        store.dispatch(.adLoad(.interstitial))
    }
}

struct DismissCommand: Command {
    func execute(in store: Store) {
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let vc = window.rootViewController, let presentedVC = vc.presentedViewController {
            if let p = presentedVC.presentedViewController {
                p.dismiss(animated: true)
            } else {
                presentedVC.dismiss(animated: true)
            }
        }
    }
}


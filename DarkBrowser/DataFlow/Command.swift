//
//  Command.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/16.
//

import Foundation
import Combine

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
        Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink { _ in
            let iv =  store.state.launch.duration / 0.01
            let progress = store.state.launch.progress + 1 / iv
            store.dispatch(.launchProgress(progress))
            if progress > 1.0 {
                token.unseal()
                store.dispatch(.launched)
            }
        }.seal(in: token)
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

//
//  Store.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/16.
//

import Foundation
import Combine
import UIKit

class Store: ObservableObject {
    @Published var state = AppState()
    var disposeBag = [AnyCancellable]()
    
    init(){
        commonInit()
    }
    
    private func commonInit() {
        dispatch(.adRequestConfig)
        dispatch(.launching)
        dispatch(.homeReloadWebView)
        
        dispatch(.loP(.local))
        dispatch(.loE(.open))
        dispatch(.loE(.openCold))
    }
    
    public func dispatch(_ action: AppAction) {
        debugPrint("[ACTION]: \(action)")
        let result = Store.reduce(state: state, action: action)
        state = result.0
        if let command = result.1 {
            debugPrint("[COMMAND]: \(command)")
            command.execute(in: self)
        }
    }
}

extension Store{
    private static func reduce(state: AppState, action: AppAction) -> (AppState, Command?) {
        var appState = state
        var appCommand: Command? = nil
        switch action {
            
        case .alert(let text):
            appState.root.isAlert = true
            appState.root.message = text
        case .hideKeyboard:
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
        case .launching:
            appState.root.showLaunch = true
            appState.root.showHome = false
            appCommand = LaunchCommand()
        case .launched:
            appState.root.showLaunch = false
            appState.root.showHome = true
        case .launchProgress(let progress):
            appState.launch.progress = progress
            
        case .homeSearchText(let text):
            appState.home.searchText = text
        case .homeCanGoback(let ret):
            appState.home.canGoBack = ret
        case .homeCanGoForword(let ret):
            appState.home.canGoForword = ret
        case .homeLoading(let ret):
            appState.home.isLoading = ret
        case .homeNavigation(let ret):
            appState.home.isNavigation = ret
        case .homeProgress(let progress):
            appState.home.progress = progress
        case .homeGoback:
            appState.home.item.goBack()
        case .homeGoForword:
            appState.home.item.goForword()
        case .homeStopSearch:
            appState.home.item.stopLoad()
        case .homeSearch:
            appCommand = HomeSearchCommand()
        case .homeReloadWebView:
            appCommand = WebViewCommand()
            
        case .tabShow(let show):
            appState.root.showTab = show
            
        case .webItemSelect(let item):
            appState.home.items.forEach {
                $0.isSelect = false
            }
            item.isSelect = true
        case .webItemDelete(let item):
            if item.isSelect {
                appState.home.items = appState.home.items.filter({
                    !$0.isSelect
                })
                appState.home.items.first?.isSelect = true
            } else {
                appState.home.items = appState.home.items.filter({
                    $0.webView != item.webView
                })
            }
        case .webItemNew:
            appState.home.items.forEach {
                $0.isSelect = false
            }
            appState.home.items.insert(.navigation, at: 0)
        case .webItemClean:
            appState.home.items = [.navigation]
            
            
        case .settingShow(let show):
            appState.root.showSetting = show
        case .shareShow:
            appState.root.showShare = true
        case .privacyShow(let show):
            appState.root.showPrivacy = show
        case .termsShow(let show):
            appState.root.showTerms = show
        case .myAlertShow(let show):
            appState.root.showMyAlert = show
        case .cleanShow(let show):
            appState.root.showClean = show
            
        case .loP(let property, let value):
            appCommand = FirebasePropertyCommand(property, value)
        case .loE(let event, let params):
            appCommand = FirebaseEvnetCommand(event, params)
            
        case .adRequestConfig:
            appCommand = GADRequestConfigCommand()
        case .adUpdateConfig(let config):
            appState.ad.config = config
        case .adUpdateLimit(let state):
            appCommand = GADLimitedCommand(state)
        case .adAppear(let position):
            appCommand = GADAppearCommand(position)
        case .adDisappear(let position):
            appCommand = GADDisappearCommand(position)
        case .adClean(let position):
            appCommand = GADCleanCommand(position)
        
        case .adLoad(let position, let p):
            appCommand = GADLoadCommand(position, p)
        case .adShow(let position, let p, let completion):
            appCommand = GADShowCommand(position, p, completion)
            
        case .adNativeImpressionDate(let p):
            appState.ad.impressionDate[p] = Date()
        case .adModel(let model):
            appState.root.adModel = model
        case .clean:
            appCommand = CleanCommand()
        case .dismiss:
            appCommand = DismissCommand()
        }
        return (appState, appCommand)
    }
}

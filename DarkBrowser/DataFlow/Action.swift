//
//  Action.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/16.
//

import Foundation

enum AppAction {
    
    case alert(String)
    case hideKeyboard
    
    case launching
    case launchProgress(Double)
    case launched
    
    case homeSearchText(String)
    case homeCanGoback(Bool)
    case homeCanGoForword(Bool)
    case homeProgress(Double)
    case homeNavigation(Bool)
    case homeLoading(Bool)
    case homeGoback
    case homeGoForword
    case homeStopSearch
    case homeSearch
    case homeReloadWebView
    
    case tabShow(Bool)
    
    case webItemSelect(WebItem)
    case webItemDelete(WebItem)
    case webItemNew
    case webItemClean
    
    case settingShow(Bool)
    
    case shareShow
    
    case privacyShow(Bool)
    case termsShow(Bool)
    
    case myAlertShow(Bool)
    
    case cleanShow(Bool)
    
    case loP(AppState.Firebase.Property, String? = nil)
    case loE(AppState.Firebase.Event, [String: String]? = nil)
}

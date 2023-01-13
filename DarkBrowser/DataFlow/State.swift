//
//  State.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/16.
//

import Foundation

struct AppState {
    var root = RootState()
    var launch = LaunchState()
    var home = HomeState()
    var tab = TabState()
    var ad = GAdMoble()
}

extension AppState {
    struct RootState {
        var showHome = false
        var showLaunch = true
        var showTab = false
        var showSetting = false
        var showShare = false
        var showPrivacy = false
        var showTerms = false
        var showMyAlert = false
        var showClean = false
        
        var message: String = ""
        var isAlert: Bool = false
        
        var adModel: NativeViewModel = .None
    }
}

extension AppState {
    struct LaunchState {
        var progress = 0.0
        var duration = 2.5
    }
}

extension AppState {
    struct HomeState {
        enum NavigationItem: String, CaseIterable {
            case facebook, google, youtube, twitter, instagram, amazon, gmail, yahoo
            var title: String {
                return "\(self)".capitalized
            }
            var url: String {
                return "https://www.\(self).com"
            }
            var icon: String {
                return "home_\(self)"
            }
        }
        
        var searchText: String = ""
        var isLoading: Bool = false
        var progress: Double = 0.0
        var canGoBack: Bool = false
        var canGoForword: Bool = false
        var isNavigation: Bool = true
        
        var items: [WebItem] = [.navigation]
        var item: WebItem {
            items.filter {
                $0.isSelect
            }.first ?? .navigation
        }
    }
}

extension AppState {
    struct TabState {
    }
}

extension AppState {
    struct Firebase {
        enum Property: String {
            /// 設備
            case local = "w"
            
            var first: Bool {
                switch self {
                case .local:
                    return true
                }
            }
        }
        
        enum Event: String {
            
            var first: Bool {
                switch self {
                case .open:
                    return true
                default:
                    return false
                }
            }
            
            case open = "e_21"
            case openCold = "r_21"
            case openHot = "h_21"
            case homeShow = "u_21"
            case homeShowNavigation = "i_21"
            case homeNavigationClick = "o_21"
            case homeSearchClick = "p_21"
            case homeCleanClick = "z_21"
            case cleanAnimation = "x_21"
            case cleanAlert = "c_21"
            case tabShow = "b_21"
            case webNew = "v_21"
            case shareClick = "n_21"
            case copyClick = "m_21"
            
            case loading = "k_21"
            case loaded = "ll_21"
        }
    }
}

extension AppState {
    struct GAdMoble{

        @UserDefault(key: "state.ad.config")
        var config: GADConfigModel?
       
        @UserDefault(key: "state.ad.limit")
        var limit: GADLimitModel?
        
        var impressionDate:[GADPosition.Position: Date] = [:]
        
        let ads:[GADLoadModel] = GADPosition.allCases.map { p in
            GADLoadModel(position: p)
        }.filter { m in
            m.position != .all
        }
        
        func isLoaded(_ position: GADPosition) -> Bool {
            return self.ads.filter {
                $0.position == position
            }.first?.isLoaded == true
        }

        func isLimited(in store: Store) -> Bool {
            if limit?.date.isToday == true {
                if (store.state.ad.limit?.showTimes ?? 0) >= (store.state.ad.config?.showTimes ?? 0) || (store.state.ad.limit?.clickTimes ?? 0) >= (store.state.ad.config?.clickTimes ?? 0) {
                    return true
                }
            }
            return false
        }
    }
}

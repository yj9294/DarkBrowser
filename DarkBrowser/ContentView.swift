//
//  ContentView.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/16.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var store: Store
    
    var root : AppState.RootState {
        store.state.root
    }
    
    var launch: AppState.LaunchState {
        store.state.launch
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack{
                if root.showHome, !root.showLaunch {
                    HomeView()
                        .onAppear{
                            store.dispatch(.loE(.homeShow))
                            store.dispatch(.adLoad(.native))
                            store.dispatch(.adLoad(.interstitial))
                        }
                        .onDisappear{
                            store.dispatch(.adDisappear(.native))
                        }
                        .alert(title: root.message, isPresent: $store.state.root.isAlert)
                        .sheet(isPresented: $store.state.root.showShare) {
                            ShareView()
                        }
                }
                
                if root.showLaunch, !root.showHome {
                    LaunchView(launch.progress)
                }
                
                
                else if root.showTab {
                    TabView()
                        .onAppear {
                            store.dispatch(.loE(.tabShow))
                            store.dispatch(.adLoad(.native, .tab))
                            store.dispatch(.adLoad(.interstitial))
                        }
                        .onDisappear {
                            store.dispatch(.loE(.homeShow))
                        }
                }
                
                else if root.showSetting {
                    SettingView()
                        .onDisappear {
                            store.dispatch(.loE(.homeShow))
                        }
                }
                
                else if root.showPrivacy {
                    PrivacyView()
                        .onDisappear {
                            store.dispatch(.loE(.homeShow))
                            store.dispatch(.adLoad(.native))
                            store.dispatch(.adLoad(.interstitial))
                        }
                }
                
                else if root.showTerms {
                    TermsView()
                        .onDisappear {
                            store.dispatch(.loE(.homeShow))
                            store.dispatch(.adLoad(.native))
                            store.dispatch(.adLoad(.interstitial))
                        }
                }
                
                else if root.showMyAlert {
                    MyAlertView()
                }
                
                else if root.showClean {
                    CleanView()
                        .onDisappear {
                            store.dispatch(.loE(.homeShow))
                            store.dispatch(.adLoad(.native))
                            store.dispatch(.adLoad(.interstitial))
                        }
                }
               
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background(Color(hex: 0x000100).ignoresSafeArea(.all))
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            AppEnterbackground = false
            store.dispatch(.dismiss)
            store.dispatch(.launching)
            store.dispatch(.loE(.openHot))
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification), perform: { _ in
            AppEnterbackground = true
        })
        .onReceive(NotificationCenter.default.publisher(for: .nativeAdLoadCompletion), perform: { ad in
            if let ad = ad.object as? NativeViewModel {
                store.dispatch(.adModel(ad))
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Store())
    }
}

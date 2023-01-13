//
//  SettingView.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/20.
//

import SwiftUI
import MobileCoreServices

struct SettingView: View {
    
    @EnvironmentObject var store: Store
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack{
           Spacer()
            HStack{
                Spacer()
                VStack(spacing: 15){
                    HStack(spacing: 50){
                        Button(action: newAction) {
                            VStack{
                                Image("setting_new")
                                Text("New").foregroundColor(.white)
                            }
                        }
                        Button(action: shareAction) {
                            VStack{
                                Image("setting_share")
                                Text("Share").foregroundColor(.white)
                            }
                        }
                        Button(action: copyAction) {
                            VStack{
                                Image("setting_copy")
                                Text("Copy").foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.top, 25)
                    VStack {
                        Button(action: rateAction) {
                            HStack{
                                Text("Rate Us")
                                    .foregroundColor(.gray)
                                Spacer()
                                Image("setting_arrow")
                            }
                        }
                        .padding(.vertical, 20)
                        Button(action: termsAction) {
                            HStack{
                                Text("Terms of Use")
                                    .foregroundColor(.gray)
                                Spacer()
                                Image("setting_arrow")
                            }
                        }
                        .padding(.vertical, 20)
                        Button(action: privacyAction) {
                            HStack{
                                Text("Privacy Policy")
                                    .foregroundColor(.gray)
                                Spacer()
                                Image("setting_arrow")
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    .padding(.horizontal, 30)
                }
                .frame(width: 264)
                .background(Color.black)
                .cornerRadius(12)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 80)
        }
        .background(Color(hex: 0x000000, alpha: 0.7).ignoresSafeArea(.all).onTapGesture {
            backAction()
        })
    }
}

extension SettingView {
    
    func backAction() {
        store.dispatch(.settingShow(false))
    }
    
    func newAction() {
        store.dispatch(.loE(.webNew, ["lig": "setting"]))
        store.dispatch(.webItemNew)
        store.dispatch(.homeReloadWebView)
        store.dispatch(.settingShow(false))
    }
    
    func shareAction() {
        store.dispatch(.loE(.shareClick))
        store.dispatch(.settingShow(false))
        store.dispatch(.shareShow)
    }
    
    func copyAction() {
        store.dispatch(.loE(.copyClick))
        store.dispatch(.settingShow(false))
        if store.state.home.item.isNavigation {
            UIPasteboard.general.setValue("", forPasteboardType: kUTTypePlainText as String)
        } else {
            UIPasteboard.general.setValue(store.state.home.searchText, forPasteboardType: kUTTypePlainText as String)
        }
        store.dispatch(.alert("Copy Successfully."))
    }
    
    func rateAction() {
        store.dispatch(.settingShow(false))
        if let url = URL(string: "https://itunes.apple.com/cn/app/id1663722537") {
            openURL(url)
        }
    }
    
    func termsAction() {
        store.dispatch(.settingShow(false))
        store.dispatch(.termsShow(true))
        store.dispatch(.adDisappear(.native))
    }
    
    func privacyAction() {
        store.dispatch(.settingShow(false))
        store.dispatch(.privacyShow(true))
        store.dispatch(.adDisappear(.native))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView().environmentObject(Store())
    }
}

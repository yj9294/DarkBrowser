//
//  HomeView.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/16.
//

import SwiftUI
import AppTrackingTransparency

struct HomeView: View {
    
    @EnvironmentObject var store: Store
    
    let columns:[GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var home: AppState.HomeState {
        store.state.home
    }
    
    var root: AppState.RootState {
        store.state.root
    }
    
    var body: some View {
        VStack{
            // top view
            VStack {
                HStack{
                    TextField("", text: $store.state.home.searchText, onCommit: searchAction)
                        .foregroundColor(Color(hex: 0xffffff))
                        .placeholder(when: home.searchText.isEmpty) {
                            Text("Seaech Or Enter Address")
                                .foregroundColor(Color(hex: 0xffffff, alpha: 0.5))
                        }
                    Button(action: searchAction) {
                        Image(!home.isLoading ? "home_search" : "home_close")
                    }
                    .frame(width: 28, height: 28)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color(hex: 0xffffff, alpha: 0.5), lineWidth: 1))
                ProgressView(value: home.progress)
                    .accentColor(Color(hex: 0x7BFF67))
                    .background(Color(hex: 0xffffff, alpha: 0.4))
                    .frame(height: 1)
                    .opacity(home.isLoading ? 1.0 : 0.0)
            }
            .padding(.top, 20)
            .padding(.bottom, 12)
            .padding(.horizontal, 24)
            
            // center
            if home.isNavigation {
                VStack{
                    Spacer()
                    Image("home_icon")
                    Spacer()
                    LazyVGrid(columns: columns, content: {
                        ForEach(AppState.HomeState.NavigationItem.allCases, id: \.self) { model in
                            Button {
                                buttonAction(model.url)
                            } label: {
                                VStack(spacing: 7){
                                    Image(model.icon)
                                    Text(model.title)
                                        .foregroundColor(Color(hex: 0x9D9BCA))
                                }
                            }
                        }
                    })
                    .padding(.vertical, 10)
                    Spacer()
                }
            } else if !root.showTab {
                WebView(webView: home.item.webView)
            }
            
            // bottom
            HStack{
                Button(action: lastAction) {
                    Image(home.canGoBack ? "home_last" : "home_last_1")
                }
                Spacer()
                Button(action: nextAction) {
                    Image(home.canGoForword ? "home_next" : "home_next_1")
                }
                Spacer()
                Button(action: cleanAction) {
                    Image("home_clean")
                }
                Spacer()
                Button(action: tabAction) {
                    ZStack {
                        Image("home_tab")
                        Text("\(home.items.count)")
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                Button(action: settingAction) {
                    Image("home_setting")
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .onAppear{
            ATTrackingManager.requestTrackingAuthorization { _ in
            }
        }

    }
}

extension HomeView {
    func searchAction() {
        store.dispatch(.hideKeyboard)
        if home.isLoading {
            store.dispatch(.homeStopSearch)
        } else {
            if home.searchText.count > 0 {
                store.dispatch(.loE(.homeSearchClick, ["lig": home.searchText]))
            }
            store.dispatch(.homeSearch)
        }
    }
    
    func buttonAction(_ url: String) {
        store.dispatch(.loE(.homeNavigationClick, ["lig": url]))
        store.dispatch(.hideKeyboard)
        store.dispatch(.homeSearchText(url))
        store.dispatch(.homeSearch)
    }
    
    func lastAction() {
        store.dispatch(.hideKeyboard)
        store.dispatch(.homeGoback)
    }
    
    func nextAction() {
        store.dispatch(.hideKeyboard)
        store.dispatch(.homeGoForword)
    }
    
    func cleanAction() {
        store.dispatch(.loE(.homeCleanClick))
        store.dispatch(.hideKeyboard)
        store.dispatch(.myAlertShow(true))
    }
    
    func tabAction() {
        store.dispatch(.hideKeyboard)
        store.dispatch(.tabShow(true))
    }
    
    func settingAction() {
        store.dispatch(.hideKeyboard)
        store.dispatch(.settingShow(true))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Store())
    }
}

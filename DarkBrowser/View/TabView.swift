//
//  TabView.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/19.
//

import SwiftUI

struct TabView: View {
    @EnvironmentObject var store: Store
    
    var home: AppState.HomeState {
        store.state.home
    }
    
    var root: AppState.RootState {
        store.state.root
    }
    
    let colums = [GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12), GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12)]

    var body: some View {
        VStack{
            ScrollView{
                LazyVGrid(columns: colums) {
                    ForEach(home.items, id: \.self) { item in
                        ZStack {
                            if item.isSelect {
                                Color.green.cornerRadius(8)
                            } else {
                                Color.gray.cornerRadius(8)
                            }
                            
                            
                            // cell
                            Button {
                                selectAction(item)
                            } label: {
                                if item.isNavigation {
                                    Image("tab_icon")
                                        .resizable()
                                        .frame(width: 90, height: 60)
                                } else {
                                    VStack(spacing: 30){
                                        Text(item.webView.url?.absoluteString ?? "")
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                            .font(.footnote)
                                        Image("tab_icon")
                                            .resizable()
                                            .frame(width: 90, height: 60)
                                    }
                                }
                            }
                            .cornerRadius(8)
                            .clipped()
                            
                            // 删除按钮
                            VStack{
                                HStack{
                                    Spacer()
                                    if home.items.count > 1 {
                                        Button {
                                            deleteAction(item)
                                        } label: {
                                            Image("tab_close")
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .frame(height: 200)
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
            }
            Spacer()
            
            VStack{
                NativeView(model: root.adModel).frame(height: 76)
            }
            .padding(.horizontal, 16)
            
            // 底部
            ZStack{
                HStack{
                    Spacer()
                    Button(action: addAction) {
                        Image("tab_new")
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
                .frame(height: 58)

                HStack{
                    Spacer()
                    Button(action: backAction) {
                        Text("Back").foregroundColor(.white)
                            .font(.bold(.title2)())
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                }
                .frame(height: 58)
            }
        }
        .background(Color(hex: 0x000100).ignoresSafeArea(.all))
    }
}

extension TabView {
    func selectAction(_ item: WebItem) {
        store.dispatch(.webItemSelect(item))
        store.dispatch(.homeReloadWebView)
        store.dispatch(.tabShow(false))
        
        store.dispatch(.adDisappear(.native))
        store.dispatch(.adLoad(.native, .home))
        store.dispatch(.adLoad(.interstitial))
    }
    
    func deleteAction(_ item: WebItem) {
        store.dispatch(.webItemDelete(item))
        store.dispatch(.homeReloadWebView)
    }
    
    func addAction() {
        store.dispatch(.loE(.webNew, ["lig": "tab"]))
        store.dispatch(.webItemNew)
        store.dispatch(.homeReloadWebView)
        store.dispatch(.tabShow(false))
        
        store.dispatch(.adDisappear(.native))
        store.dispatch(.adLoad(.native, .home))
        store.dispatch(.adLoad(.interstitial))
    }
    
    func backAction() {
        store.dispatch(.tabShow(false))
        
        store.dispatch(.adDisappear(.native))
        store.dispatch(.adLoad(.native, .home))
        store.dispatch(.adLoad(.interstitial))
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView().environmentObject(Store())
    }
}

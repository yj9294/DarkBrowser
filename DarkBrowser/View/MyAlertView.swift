//
//  MyAlertView.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/20.
//

import SwiftUI

struct MyAlertView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0){
                VStack(spacing: 18){
                    Image("alert")
                    Text("Close Tabs and Clear Data")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 15)
                Color.gray.frame(height: 1)
                HStack{
                    Button(action: cancelAction) {
                        Text("Cancel")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 22)
                    }
                    Spacer()
                    Color.gray.frame(width: 1, height: 80)
                    Spacer()
                    Button(action: confirmAction) {
                        Text("Confirm")
                            .foregroundColor(.green)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 22)
                    }
                }
            }
            .background(Color(hex: 0x000100).ignoresSafeArea(.all))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            Spacer()
        }
        .background(Color(hex: 0x000000, alpha: 0.7).ignoresSafeArea(.all))
    }
}

extension MyAlertView {
    func cancelAction() {
        store.dispatch(.myAlertShow(false))
    }
    
    func confirmAction() {
        store.dispatch(.myAlertShow(false))
        store.dispatch(.cleanShow(true))
        Task{
            if !Task.isCancelled {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                store.dispatch(.loE(.cleanAnimation))
                store.dispatch(.cleanShow(false))
                store.dispatch(.alert("Clean successfully."))
                store.dispatch(.loE(.cleanAlert))
                store.dispatch(.webItemClean)
                store.dispatch(.homeReloadWebView)
            }
        }
    }
}

struct MyAlertView_Previews: PreviewProvider {
    static var previews: some View {
        MyAlertView().environmentObject(Store())
    }
}

//
//  ShareView.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/20.
//

import Foundation
import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    
    @EnvironmentObject var store: Store
    
    var home: AppState.HomeState {
        store.state.home
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var url: String = ""
        if let u = home.item.webView.url?.absoluteString {
            url = u
        } else {
            url = "https://itunes.apple.com/cn/app/id1663722537"
        }
        
        let controller = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

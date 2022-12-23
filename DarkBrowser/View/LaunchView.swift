//
//  LaunchView.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/16.
//

import SwiftUI

struct LaunchView: View {
    
    var progress = 0.0
    
    init(_ progress: Double) {
        self.progress = progress
    }
    
    
    var body: some View {
        VStack(spacing: 300) {
            VStack(spacing: 14) {
                Image("launch_icon")
                Image("launch_title")
            }
            HStack {
                ProgressView(value: progress)
                    .accentColor(.white)
                    .background(Color(hex: 0x6EEBC3, alpha: 0.2))
                    .cornerRadius(2.5)
            }
            .padding(.horizontal, 80.0)
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(0.5)
    }
}

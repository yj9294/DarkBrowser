//
//  CleanView.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/20.
//

import SwiftUI

struct CleanView: View {
    
    @State private var degrees: Double = 0
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
            }
            Spacer()
            ZStack{
                Image("clean_bg")
                    .rotationEffect(.degrees(degrees))
                    .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false))
                    .onAppear {
                        self.degrees = 360
                    }
                Image("clean_icon")
            }
            Text("cleaning...")
                .foregroundColor(.white)
            Spacer()
        }
        .background(Color(hex: 0x000100).ignoresSafeArea(.all))

    }
}

struct CleanView_Previews: PreviewProvider {
    static var previews: some View {
        CleanView()
    }
}

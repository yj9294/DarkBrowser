//
//  TermsView.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/20.
//

import SwiftUI

struct TermsView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack{
            ZStack {
                HStack{
                    Button(action: backAction) {
                        Image("setting_back")
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                Text("Terms of Use")
                    .foregroundColor(.white)
            }
            ScrollView{
                Text("""
Please read these Terms of Use in detail
Use of the application
You accept that you may not use this application for illegal purposes
You accept that we may discontinue the service of the application at any time without prior notice to you
You accept using our application in accordance with the terms of this page, if you reject the terms of this page, please do not use our services
Update
We may update our Terms of Use from time to time. We recommend that you review these Terms of Use periodically for changes.
Contact us
If you have any questions about these Terms of Use, please contact us
viab123456@outlook.com
""").foregroundColor(.white)
            }
            .padding(.all)
        }
        .background(Color(hex: 0x000100).ignoresSafeArea(.all))
    }
}

extension TermsView {
    func backAction() {
        store.dispatch(.termsShow(false))
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView()
    }
}

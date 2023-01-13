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
It is recommended that you read these Terms of Use in detail
Use of the application
You accept that we are not responsible for the third-party content you visit
You accept that we can terminate our service at any time without informing you in advance
You accept the use of our application to the extent permitted by law
Update
We will update these terms of use from time to time. We suggest you follow this page to learn about the updated status and content
Contact us
Contact us:darkbrowser123456@gmail.com
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

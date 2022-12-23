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
The following terms and conditions (the “Terms”) govern your use of the VPN services we provide (the “Service”) and their associated website domains (the “Site”). These Terms constitute a legally binding agreement (the “Agreement”) between you and Tap VPN. (the “Tap VPN”).

Activation of your account constitutes your agreement to be bound by the Terms and a representation that you are at least eighteen (18) years of age, and that the registration information you have provided is accurate and complete.

Tap VPN may update the Terms from time to time without notice. Any changes in the Terms will be incorporated into a revised Agreement that we will post on the Site. Unless otherwise specified, such changes shall be effective when they are posted. If we make material changes to these Terms, we will aim to notify you via email or when you log in at our Site.

By using Tap VPN
You agree to comply with all applicable laws and regulations in connection with your use of this service.regulations in connection with your use of this service.
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

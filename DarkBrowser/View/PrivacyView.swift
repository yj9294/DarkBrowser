//
//  PrivacyView.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/20.
//

import SwiftUI

struct PrivacyView: View {
    
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
                Text("Privacy Policy")
                    .foregroundColor(.white)
            }
            ScrollView{
                Text("""
Please read this privacy policy in detail
About information collection and use
We only collect information specified in this privacy policy, including but not limited to contact information, device type, operating system type and its version, model and manufacturer, device identifier, mobile operator, network provider, network type, IP address
We collect this information to improve and optimize the service, update and develop the service, improve your experience, respond to your comments and questions, and provide support to provide you with a better experience when you use our applications.
We use this information to effectively reply to you, meet your request, send you the communication you requested, and perform the requested service.
We may use the information for advertising or marketing purposes
About information disclosure
Our partners can collect your personal data. We do not control the behavior of these third-party partners and service providers. Our partners include Google Play services, Google Analytics for Firebase, Firebase Crashlytics, Facebook, AdMob. Please read their privacy policies
Children's Privacy
These services are not intended for anyone under the age of 13. We do not knowingly collect personally identifiable information from children under the age of 13. If we become aware that a child under the age of 13 has provided us with personal information, we will delete it from our servers immediately. If you are a parent or guardian and you know that your child has provided us with personal information, please contact us so that we can take necessary action.
Update
We will update this privacy policy from time to time. We suggest you follow this page to learn about the updated status and content
Contact
Contact us:darkbrowser123456@gmail.com
""").foregroundColor(.white)
            }
            .padding(.all)
        }
        .background(Color(hex: 0x000100).ignoresSafeArea(.all))
    }
}

extension PrivacyView {
    
    func backAction() {
        store.dispatch(.privacyShow(false))
    }
    
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}

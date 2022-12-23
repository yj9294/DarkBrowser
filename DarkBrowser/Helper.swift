//
//  Helper.swift
//  DarkBrowser
//
//  Created by yangjian on 2022/12/16.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(.sRGB, red: components.R, green: components.G, blue: components.B, opacity: alpha)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View {
    @MainActor
    func alert(title: String, isPresent: Binding<Bool>) -> some View {
        ZStack{
            self
            if isPresent.wrappedValue {
                Color(hex: 0x333333, alpha: 0.6).ignoresSafeArea()
                Text(title).padding(.all, 16)
                    .background(Color.white.cornerRadius(8))
                    .foregroundColor(.blue)
                    .onAppear{
                        Task{
                            if !Task.isCancelled {
                                try await Task.sleep(nanoseconds: 2_000_000_000)
                                isPresent.wrappedValue.toggle()
                            }
                        }
                    }
            }
        }
    }
}

extension String {
    var isUrl: Bool {
        let url = "[a-zA-z]+://.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
    }
}

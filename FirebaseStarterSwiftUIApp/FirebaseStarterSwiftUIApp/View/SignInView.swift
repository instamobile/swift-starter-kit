//
//  SignUpView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/8/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI
import Combine
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

struct SignInView: View {
    @State var pushActive = false
    @ObservedObject private var viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 30) {
                Text("Log in")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.tintColor))
                    .padding(.leading, 25)
                    .padding(.bottom, 80)
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 25) {
                        CustomTextField(placeHolderText: "E-mail",
                                      text: $viewModel.email)
                        CustomTextField(placeHolderText: "Password",
                                      text: $viewModel.password,
                                      isPasswordType: true)
                    }.padding(.horizontal, 25)
                    
                    VStack(alignment: .center, spacing: 40) {
                        customButton(title: "Log In",
                                     backgroundColor: UIConfiguration.tintColor,
                                     action: { self.viewModel.login() })
                        Text("OR")
                        customButton(title: "Facebook Login",
                                     backgroundColor: UIColor(hexString: "#334D92"),
                                     action: { self.viewModel.facebookLogin() })
                    }
                }
            }
            Spacer()
        }.alert(item: self.$viewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                  message: Text(status.message),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private func customButton(title: String,
                              backgroundColor: UIColor,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .modifier(ButtonModifier(font: UIConfiguration.buttonFont,
                                         color: backgroundColor,
                                         textColor: .white,
                                         width: 275,
                                         height: 55))
        }
    }
}

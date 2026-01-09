//
//  SignInViewModel.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/16/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import Combine
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var statusViewModel: StatusViewModel?
    
    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    init(authAPI: AuthAPI) {
        self.authAPI = authAPI
    }
    
    func login() {
        authAPI.login(email: email, password: password)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
    
    func facebookLogin() {
        authAPI.loginWithFacebook()
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension SignInViewModel {
    private func resultMapper(with result: Bool) -> StatusViewModel {
        return result ? StatusViewModel.logInSuccessStatus : StatusViewModel.errorStatus
    }
}

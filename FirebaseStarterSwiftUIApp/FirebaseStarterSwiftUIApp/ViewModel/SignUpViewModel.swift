//
//  SignUpViewModel.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/9/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var phoneNumber: String = ""
    @Published var statusViewModel: StatusViewModel?
    
    private var cancellableBag = Set<AnyCancellable>()
    private let authAPI: AuthAPI
    
    init(authAPI: AuthAPI) {
        self.authAPI = authAPI
    }
    
    func signUp() {
        authAPI.signUp(email: email, password: password)
            .receive(on: RunLoop.main)
            .map(resultMapper)
            .replaceError(with: StatusViewModel.errorStatus)
            .assign(to: \.statusViewModel, on: self)
            .store(in: &cancellableBag)
    }
}

// MARK: - Private helper function
extension SignUpViewModel {
    private func resultMapper(with result: Bool) -> StatusViewModel {
        return result ? StatusViewModel.signUpSuccessStatus : StatusViewModel.errorStatus
    }
}

//
//  AuthService.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/16/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class AuthService: AuthAPI {
    
    func loginWithFacebook() -> Future<Bool, Never> {
        return Future<Bool, Never> { promise in
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["email"], from: nil) { (result, error) in
                guard let token = AccessToken.current, error == nil else {
                    promise(.success(false))
                    return
                }
                Auth.auth().signIn(with: FacebookAuthProvider.credential(withAccessToken: token.tokenString), completion: { (firebaseUser, error) in
                    print(firebaseUser)
                    promise(.success(error == nil))
                })
            }
        }
    }
    
    func login(email: String, password: String) -> Future<Bool, Never> {
        return Future<Bool, Never> { promise in
            Auth.auth().signIn(withEmail: email, password: password) {(authResult, error) in
                if let user = authResult?.user {
                    print(user)
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            }
        }
    }
    
    func signUp(email: String, password: String) -> Future<Bool, Never> {
        return Future<Bool, Never> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let user = authResult?.user {
                    print(user)
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            }
        }
    }
}

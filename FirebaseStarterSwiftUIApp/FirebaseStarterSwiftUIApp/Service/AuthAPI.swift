//
//  AuthAPI.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/16/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth

protocol AuthAPI {
    func login(email: String, password: String) -> Future<Bool, Never>
    func signUp(email: String, password: String) -> Future<Bool, Never>
    func loginWithFacebook() -> Future<Bool, Never>
}

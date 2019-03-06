//
//  ATCClassicLoginScreenViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/9/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import FacebookCore
import FacebookLogin
import FirebaseAuth
import UIKit

class ATCClassicLoginScreenViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var passwordTextField: ATCTextField!
    @IBOutlet var contactPointTextField: ATCTextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var separatorLabel: UILabel!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var backButton: UIButton!

    private let backgroundColor: UIColor = .white
    private let tintColor = UIColor(hexString: "#ff5a66")

    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)

    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let textFieldColor = UIColor(hexString: "#B0B3C6")
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")

    private let separatorFont = UIFont.boldSystemFont(ofSize: 14)
    private let separatorTextColor = UIColor(hexString: "#464646")

    private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(UIImage.localImage("arrow-back-icon", template: true), for: .normal)
        backButton.tintColor = UIColor(hexString: "#282E4F")
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        titleLabel.font = titleFont
        titleLabel.text = "Log In"
        titleLabel.textColor = tintColor

        contactPointTextField.configure(color: textFieldColor,
                                        font: textFieldFont,
                                        cornerRadius: 55/2,
                                        borderColor: textFieldBorderColor,
                                        backgroundColor: backgroundColor,
                                        borderWidth: 1.0)
        contactPointTextField.placeholder = "E-mail"
        contactPointTextField.textContentType = .emailAddress
        contactPointTextField.clipsToBounds = true

        passwordTextField.configure(color: textFieldColor,
                                font: textFieldFont,
                                cornerRadius: 55/2,
                                borderColor: textFieldBorderColor,
                                backgroundColor: backgroundColor,
                                borderWidth: 1.0)
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .emailAddress
        passwordTextField.clipsToBounds = true

        separatorLabel.font = separatorFont
        separatorLabel.textColor = separatorTextColor
        separatorLabel.text = "OR"

        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginButton.configure(color: backgroundColor,
                              font: buttonFont,
                              cornerRadius: 55/2,
                              backgroundColor: tintColor)

        facebookButton.setTitle("Facebook Login", for: .normal)
        facebookButton.addTarget(self, action: #selector(didTapFacebookButton), for: .touchUpInside)
        facebookButton.configure(color: backgroundColor,
                                 font: buttonFont,
                                 cornerRadius: 55/2,
                                 backgroundColor: UIColor(hexString: "#334D92"))
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func didTapLoginButton() {
        let loginManager = FirebaseAuthManager()
        guard let email = contactPointTextField.text, let password = passwordTextField.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                message = "User was sucessfully logged in."
            } else {
                message = "There was an error."
            }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.display(alertController: alertController)
        }
    }

    @objc func didTapFacebookButton() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
    }

    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }

    private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
        switch loginResult {
        case .success:
            didLoginWithFacebook()
        case .failed(_): break
        default: break
        }
    }

    fileprivate func didLoginWithFacebook() {
        // Successful log in with Facebook
        if let accessToken = AccessToken.current {
            // If Firebase enabled, we log the user into Firebase
            FirebaseAuthManager().login(credential: FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    message = "User was sucessfully logged in."
                } else {
                    message = "There was an error."
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.display(alertController: alertController)
            }
        }
    }
}

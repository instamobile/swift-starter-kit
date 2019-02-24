//
//  ATCClassicSignUpViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/10/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCClassicSignUpViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nameTextField: ATCTextField!
    @IBOutlet var phoneNumberTextField: ATCTextField!
    @IBOutlet var passwordTextField: ATCTextField!
    @IBOutlet var emailTextField: ATCTextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!

    private let tintColor = UIColor(hexString: "#ff5a66")
    private let backgroundColor: UIColor = .white
    private let textFieldColor = UIColor(hexString: "#B0B3C6")
    
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")

    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(hexString: "#282E4F")
        backButton.tintColor = color
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        titleLabel.font = titleFont
        titleLabel.text = "Sign Up"
        titleLabel.textColor = tintColor

        nameTextField.configure(color: textFieldColor,
                                font: textFieldFont,
                                cornerRadius: 40/2,
                                borderColor: textFieldBorderColor,
            backgroundColor: backgroundColor,
            borderWidth: 1.0)
        nameTextField.placeholder = "Full Name"
        nameTextField.clipsToBounds = true

        emailTextField.configure(color: textFieldColor,
                                 font: textFieldFont,
                                 cornerRadius: 40/2,
                                 borderColor: textFieldBorderColor,
            backgroundColor: backgroundColor,
            borderWidth: 1.0)
        emailTextField.placeholder = "E-mail Address"
        emailTextField.clipsToBounds = true

        phoneNumberTextField.configure(color: textFieldColor,
                                       font: textFieldFont,
                                       cornerRadius: 40/2,
                                       borderColor: textFieldBorderColor,
            backgroundColor: backgroundColor,
            borderWidth: 1.0)
        phoneNumberTextField.placeholder = "Phone Number"
        phoneNumberTextField.clipsToBounds = true

        passwordTextField.configure(color: textFieldColor,
                                    font: textFieldFont,
                                    cornerRadius: 40/2,
                                    borderColor: textFieldBorderColor,
                                    backgroundColor: backgroundColor,
                                    borderWidth: 1.0)
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
            passwordTextField.clipsToBounds = true

        signUpButton.setTitle("Create Account", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        signUpButton.configure(color: backgroundColor,
                               font: buttonFont,
                               cornerRadius: 40/2,
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

    @objc func didTapSignUpButton() {
        let signUpManager = FirebaseAuthManager()
        if let email = emailTextField.text, let password = passwordTextField.text {
            signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    message = "User was sucessfully created."
                } else {
                    message = "There was an error."
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.display(alertController: alertController)
            }
        }
    }

    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}

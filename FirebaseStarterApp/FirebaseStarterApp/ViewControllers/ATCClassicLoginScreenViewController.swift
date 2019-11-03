//
//  ATCClassicLoginScreenViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/9/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
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
  
  private let backgroundColor = HelperDarkMode.mainThemeBackgroundColor
  private let tintColor = UIColor(hexString: "#ff5a66")
  
  private let titleFont = UIFont.boldSystemFont(ofSize: 30)
  private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
  
  private let textFieldFont = UIFont.systemFont(ofSize: 16)
  private let textFieldColor = UIColor(hexString: "#B0B3C6")
  private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")
  
  private let separatorFont = UIFont.boldSystemFont(ofSize: 14)
  private let separatorTextColor = UIColor(hexString: "#464646")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = backgroundColor
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
      self?.showPopup(isSuccess: success)
    }
  }
  
  @objc func didTapFacebookButton() {
    let loginManager = LoginManager()
    loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
      if error != nil {
        self.showPopup(isSuccess: false)
        return
      }
      guard let token = AccessToken.current else {
        print("Failed to get access token")
        self.showPopup(isSuccess: false)
        return
      }
      
      FirebaseAuthManager().login(credential: FacebookAuthProvider.credential(withAccessToken: token.tokenString)) {[weak self] (success) in
        self?.showPopup(isSuccess: true)
      }
    }
  }
  
    func display(alertController: UIAlertController) {
      self.present(alertController, animated: true, completion: nil)
    }
    
  }
  
  extension ATCClassicLoginScreenViewController {
    
    func showPopup(isSuccess: Bool) {
      let successMessage = "User was sucessfully logged in."
      let errorMessage = "Something went wrong. Please try again"
      let alert = UIAlertController(title: isSuccess ? "Success": "Error", message: isSuccess ? successMessage: errorMessage, preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
}

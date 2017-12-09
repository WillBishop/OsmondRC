//
//  onboardTwoController.swift
//  OsmondRC
//
//  Created by Will Bishop on 11/11/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import UIKit

class onboardTwoController: UIViewController {
	
	@IBOutlet weak var dummyBackground: UIImageView!
	
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	
	@IBOutlet weak var loginButton: UIButton!
	
	@IBOutlet weak var invalidUsername: UILabel!
	@IBOutlet weak var beginLogInIndicator: UIActivityIndicatorView!
	
	
	override func viewWillAppear(_ animated: Bool) {
		invalidUsername.isHidden = true
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		dummyBackground.isHidden = true
		stopAnimating()
		let attributes = [
			NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: .light)
		]
		
		usernameField.layer.cornerRadius = 6.0
		usernameField.layer.borderColor = UIColor.flatColors.light.blue.cgColor
		usernameField.layer.borderWidth = 2.0
		usernameField.borderStyle = .roundedRect
		usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: attributes)
		
		passwordField.layer.cornerRadius = 6.0
		passwordField.layer.borderColor = UIColor.flatColors.light.blue.cgColor
		passwordField.layer.borderWidth = 2.0
		passwordField.borderStyle = .roundedRect
		passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		// Do any additional setup after loading the view.
	}
	@objc func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0{
				self.view.frame.origin.y -= keyboardSize.height / 4
			}
		}
	}
	func startAnimating(){
		beginLogInIndicator.isHidden = false
		beginLogInIndicator.startAnimating()
	}
	func stopAnimating(){
		beginLogInIndicator.isHidden = true
		beginLogInIndicator.stopAnimating()
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y != 0{
				self.view.frame.origin.y += keyboardSize.height / 4
			}
		}
	}
	
	@IBAction func goBack(_ sender: Any) {
		NotificationCenter.default.post(name: Notification.Name("goToMenu"), object: nil)
	}
	@IBAction func beginLogin(_ sender: Any) {
		startAnimating()
		Stirling.accounts().testCredentials(username: usernameField.text, password: passwordField.text, completionHandler: {
			result in
			switch result{
				
			case true:
				print("Going")
				Stirling.accounts().login(username: self.usernameField.text?.lowercased(), password: self.passwordField.text)
			case false:
				self.stopAnimating()
				self.invalidUsername.isHidden = false
			}
		}
		)
	}
	
	
}

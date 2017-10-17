//
//  Stirling.swift
//  OsmondRC
//
//  Created by Will Bishop on 17/10/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

class Stirling{
	
	let keychain = KeychainSwift()
	var username: String?
	var password: String?
	var school: String?
	
	
	init() {
		username = keychain.get("stirlingUsername")
		password = keychain.get("stirlingPassword")
		school = keychain.get("stirlingEndpoint")
	}
	
	func getAvailableCalls(completionHandler: @escaping (String) -> ()) {
		if let school = school{
			Alamofire.request(school + "/stirling/v3/supportedCalls")
				.responseString { response in
					if response.response?.statusCode == 200 {
						completionHandler(response.result.value!)
					} else{
						completionHandler("Failed with status: \(response.response?.statusCode)")
					}
			}
		} else{
			completionHandler("Haven't set school")
		}
	}
	struct accounts{
		let keychain = KeychainSwift()
		var username: String?
		var password: String?
		var school: String?
		
		init() {
			username = keychain.get("stirlingUsername")
			password = keychain.get("stirlingPassword")
			school = keychain.get("stirlingEndpoint")
		}
		func createAccount(username: String?, password: String?, email: String?, school: String?, completionHandler: @escaping (String) -> ()) {
			if let school = school, let password = password, let username = username, let email = email{
				let parameters = [
					"emailAddress": email,
					"password": password,
					"accountName": username
				]
				Alamofire.request(school + "stirling/v3/accounts/create", method: .post, parameters: parameters)
					.responseString { response in
						if response.response?.statusCode == 200 {
							completionHandler(response.result.value!)
						}
				}
			}
		}
		func deleteAccount(username: String?, password: String?, completionHandler: @escaping (String) -> ()) {
			if let school = school, let password = password, let username = username{
				let parameters = [
					"password": password,
					"accountName": username
				]
				Alamofire.request(school + "stirling/v3/accounts/delete", method: .post, parameters: parameters)
					.responseString { response in
						if response.response?.statusCode == 200 {
							completionHandler(response.result.value!)
						}
				}
			}
		}
		class update{
			let keychain = KeychainSwift()
			var username: String?
			var password: String?
			var school: String?
			
			init() {
				username = keychain.get("stirlingUsername")
				password = keychain.get("stirlingPassword")
				school = keychain.get("stirlingEndpoint")
			}
			func displayName(username: String?, password: String?, displayName: String?, completionHandler: @escaping (_ result: String) -> Void){
				if let school = school, let password = password, let username = username, let displayName = displayName{
					let parameters = [
						"password": password,
						"accountName": username,
						"displayName": displayName
					]
					Alamofire.request(school + "stirling/v3/accounts/update/displayName", method: .post, parameters: parameters)
						.responseString { response in
							if response.response?.statusCode == 200 {
								completionHandler(response.result.value!)
							} else {
								completionHandler("Failed with status: \(response.response?.statusCode)")
							}
					}
				} else{
					completionHandler("Wouldn't let variables")
				}
			}
		}
	}
	
	//stirling/v3/accounts/update/displayName
	//stirling/v3/accounts/update/emailAddress
	//stirling/v3/accounts/update/locale
	//stirling/v3/accounts/update/password
	//stirling/v3/accounts/update/avatar
	//stirling/v3/accounts/delete
	//stirling/v3/accounts/create
	//stirling/v3/version
	//stirling/v3/loadedModules
	//stirling/v3/supportedLocales
	//stirling/v3/status
}

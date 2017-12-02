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
		func login(username: String?, password: String?){
			//Woo! Credentials are correct
			UserDefaults.standard.set(true, forKey: "loggedIn")
			if let username = username, let password = password{
				KeychainSwift().set(username, forKey: "accountName")
				KeychainSwift().set(password, forKey: "password")
			}
			loggedIn()
			
		}
		func testCredentials(username: String?, password: String?, completionHandler: @escaping (_ result: Bool) -> Void){
			if let username = username, let password = password{
				let parameters = [
					"accountName": username,
					"password": password
				]
				Alamofire.request("https:/da.gihs.sa.edu.au/stirling/v3/accounts/validCredentials", method: .get, parameters: parameters)
					.responseString { response in
						if response.result.value?.range(of: "false") != nil{
							completionHandler(false)
						}
						if response.result.value?.range(of: "true") != nil{
							completionHandler(true)
						}
				}
			} else{
				print("Wouldn't let")
			}
		}
		func loggedIn() {//Switches user to logged in state.
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			//let mainController = storyboard.instantiateViewController(withIdentifier: "tabcontrollerforMain") as UIViewController
			let mainController = storyboard.instantiateViewController(withIdentifier: "initialView") as UIViewController
			
			let appDelegate =  UIApplication.shared.delegate as! AppDelegate
			appDelegate.window?.rootViewController = mainController
		}
	}
	struct classes{
		let keychain = KeychainSwift()
		var username: String?
		var password: String?
		var school: String?
		init() {
			username = keychain.get("accountName")
			password = keychain.get("password")
		}
		func getDaily(completionHandler: @escaping (_ result: [dailyClass]) -> Void){
			let parameters = [
				"accountName": username!,
				"password": password!,
				"date": "1/12/17"
			]
			Alamofire.request("https://da.gihs.sa.edu.au/stirling/v3/classes/get/daily", method: .get, parameters: parameters)
				.responseJSON { response in
					var classes = [dailyClass]()
					var times = [Date: dailyClass]()
					let dateformatter = DateFormatter()
					dateformatter.dateFormat = "d/M/yyyy, H:mm"
					dateformatter.timeZone = TimeZone(abbreviation: "UTC")
					guard let responseV = response.result.value as? NSArray else{
						print("Blame obadiah but it's your fault")
						return
					}
					for (index, element) in responseV.enumerated(){
						if let unwrappedElement = element as? [String: Any]{
							if let currentClass = dailyClass(unwrappedElement){
								let currentDate = "\(currentClass.startDateTime["date"]!), \(currentClass.startDateTime["time"]!)"
								let date = dateformatter.date(from: currentDate)
								times[date!] = currentClass
								classes.append(currentClass)
							}
						
						} else {
							print("Error during enumeration")
							return
						}
						
					}
					var timeList = [Date]()
					for (key, value) in times.enumerated(){
						
						timeList.append(value.key)
					}
					timeList = timeList.sorted(by: { $0.compare($1) == .orderedAscending })
					classes.removeAll()
					for (index, element) in timeList.enumerated(){
						classes.append(times[element]!)
					}
					completionHandler(classes)
					
					
					//dailyClass(uuid: "8684f49f-ad16-4ffe-a9fd-1f54ea85d539", title: "10 Health and PE2H Lesson", desc: "Lesson on 1/12/2017", startDateTime: ["date": "1/12/2017", "time": "14:05"], endDateTime: ["date": "1/12/2017", "time": "15:25"], location: "2TR01")

			}
		}
	}
}
struct dailyClass: Codable{
	var uuid: String
	var title: String
	var desc: String
	var startDateTime: [String: String]
	var endDateTime: [String: String]
	var location: String
	
	init?(_ json: [String: Any]){
		guard let uuid = json["uuid"] as? String,
			let title = json["title"] as? String,
			let desc = json["desc"] as? String,
			let startDateTime = json["startDateTime"] as? [String: String],
			let endDateTime = json["endDateTime"] as? [String: String],
			let location = json["location"] as? String else {
				return nil
		}
		self.uuid = uuid
		self.title = title
		self.desc = desc
		self.startDateTime = startDateTime
		self.endDateTime = endDateTime
		self.location = location
		
	}
	init() {
		self.uuid = "uuid"
		self.title = "title"
		self.desc = "desc"
		self.startDateTime = ["Start": "End"]
		self.endDateTime = ["Start": "End"]
		self.location = ""
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


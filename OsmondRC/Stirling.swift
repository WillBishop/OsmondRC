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
			username = keychain.get("accountName")
			password = keychain.get("password")
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
			
			classes().getDaily(completionHandler: {_ in
				self.getProfilePicture(completionHandler: {_ in
					self.loggedIn()
				})
			})
			
			
			
		}
		func testCredentials(username: String?, password: String?, shouldLogOut:Bool = false, completionHandler: @escaping (_ result: Bool) -> Void){
			if let username = username, let password = password{
				let parameters = [
					"accountName": username,
					"password": password
				]
				Alamofire.request("https://da.gihs.sa.edu.au/stirling/v3/accounts/validCredentials", method: .get, parameters: parameters)
					.responseString { response in
						if response.result.value?.range(of: "false") != nil{
							completionHandler(false)
							if shouldLogOut{
								UserDefaults.standard.set(false, forKey: "loggedIn")
								let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
								//let mainController = storyboard.instantiateViewController(withIdentifier: "tabcontrollerforMain") as UIViewController
								let mainController = storyboard.instantiateViewController(withIdentifier: "onboardPage") as! onboardPageController
								
								let appDelegate =  UIApplication.shared.delegate as! AppDelegate
								appDelegate.window?.rootViewController = mainController
								
							}
						}
						if response.result.value?.range(of: "true") != nil{
							completionHandler(true)
						}
				}
			} else{
				print("Wouldn't letttt")
			}
		}
		func loggedIn() {//Switches user to logged in state.
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			//let mainController = storyboard.instantiateViewController(withIdentifier: "tabcontrollerforMain") as UIViewController
			let mainController = storyboard.instantiateViewController(withIdentifier: "initialView") as UIViewController
			
			let appDelegate =  UIApplication.shared.delegate as! AppDelegate
			appDelegate.window?.rootViewController = mainController
			getDisplayName(completionHandler: {_ in
				self.getProfileBanner(completionHandler: {_ in
					
				})
			})
		}
		func getProfilePicture(completionHandler: @escaping (_ result: UIImage) -> Void){
			if let username = username, let password = password{
				let parameters = [
					"accountName": username,
					"password": password
				]
				Alamofire.request("https://da.gihs.sa.edu.au/stirling/v3/accounts/get/avatar", method: .get, parameters: parameters)
					.responseData { response in
						if let data = response.data{
							let image = UIImage(data: data)
							if let img = image{
								UserDefaults.standard.set(UIImagePNGRepresentation(img), forKey: "userImage")
								completionHandler(img)
							} else {print("bad image")}
						} else {
							print("No go")
						}
				}
			}
		}
		func getProfileBanner(completionHandler: @escaping (_ result: UIImage) -> Void){
			if let username = username, let password = password{
				let parameters = [
					"accountName": username,
					"password": password
				]
				Alamofire.request("https://da.gihs.sa.edu.au/stirling/v3/accounts/get/banner", method: .get, parameters: parameters)
					.responseData { response in
						if let data = response.data{
							let image = UIImage(data: data)
							if let img = image{
								UserDefaults.standard.set(UIImagePNGRepresentation(img), forKey: "userBanner")
								completionHandler(img)
							} else {print("bad image")}
						} else {
							print("No go")
						}
				}
			} else{
				print("wouldn't lettt")
			}
		}
		func getDisplayName(completionHandler: @escaping (_ result: String) -> Void){
			if let username = username, let password = password{
				let parameters = [
					"accountName": username,
					"password": password
				]
				
				Alamofire.request("https://da.gihs.sa.edu.au/stirling/v3/accounts/get/displayName", method: .get, parameters: parameters)
					.responseString { response in
						if let username = response.result.value{
							UserDefaults.standard.set(username, forKey: "accountDisplayName")
							completionHandler(username)
						} else{
							print("Wouldn't lett")
						}
				}
			}
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
					var timeList = [Date]() //Create an empty array that only stores dates
					for (key, value) in times.enumerated(){ //For each key, value pair in times
						
						timeList.append(value.key) //Unfortunately, the key from (key, value) and value.key are not the same
						
					}
					timeList = timeList.sorted(by: { $0.compare($1) == .orderedAscending }) //Sort it
					classes.removeAll()
					for (index, element) in timeList.enumerated(){
						classes.append(times[element]!) //Add back to classes in order of their dates
					}
					let encoder = JSONEncoder()
					
					if let encoded = try? encoder.encode(classes){
						UserDefaults().set(encoded, forKey: "dailyClasses")
					}
					completionHandler(classes)
					
					
					//dailyClass(uuid: "8684f49f-ad16-4ffe-a9fd-1f54ea85d539", title: "10 Health and PE2H Lesson", desc: "Lesson on 1/12/2017", startDateTime: ["date": "1/12/2017", "time": "14:05"], endDateTime: ["date": "1/12/2017", "time": "15:25"], location: "2TR01")
					
			}
		}
		func getLatestNote(_ uuid: String, completionHandler: @escaping (_ result: classNoteee) -> Void){
			
			if let username = username, let password = password{
				let parameters = [
					"accountName": username,
					"password": password,
					"classUuid": uuid
				]
				Alamofire.request("https://da.gihs.sa.edu.au/stirling/v3/classes/get/notes", method: .get, parameters: parameters)
					.responseJSON { response in
						//print(response.result.value)
						var times = [Date: classNoteee]()
						let dateformatter = DateFormatter()
						dateformatter.dateFormat = "d/M/yyyy, H:mm"
						dateformatter.timeZone = TimeZone(abbreviation: "UTC")
						if let value = response.result.value as? NSArray{
							for (index, element) in value.enumerated(){
								if let note = element as? [String: Any]{
									
									if let parsed = classNoteee(note){
										let date = "\(parsed.postDateTime["date"]!), \(parsed.postDateTime["time"]!)"
										let realdate = dateformatter.date(from: date)
										times[realdate!] = parsed
									}
								}
							}
							var timeList = [Date]()
							for (key, value) in times.enumerated(){
								timeList.append(value.key)
							}
							timeList = timeList.sorted(by: { $0.compare($1) == .orderedDescending })
							completionHandler(times[timeList.first!]!)
						} else {print(" wouldn't let as NSARRY")}
						
					}
				}
		}
	}
	struct announcements{
		let keychain = KeychainSwift()
		var username: String?
		var password: String?
		var school: String?
		init() {
			username = keychain.get("accountName")
			password = keychain.get("password")
		}
		func getAnnouncements(completionHandler: @escaping (_ result: [annoncement]) -> Void){
			
			if let username = username, let password = password{
				let parameters = [
					"accountName": username,
					"password": password
				]
				Alamofire.request("https://da.gihs.sa.edu.au/stirling/v3/announcements/getAll", method: .get, parameters: parameters)
					.responseJSON { json in
						if let value = json.result.value as? NSArray{
							var announcements = [annoncement]()
							for (_, element) in value.enumerated(){
								if let parsed = element as? [String: Any]{
									
									if let plsparse = annoncement(parsed){
										announcements.append(plsparse)
									} else{
										print("you messed up announcements")
									}
								} else{
									print("Wouldn't let")
								}
							}
							
							completionHandler(announcements)
							
						}
				
				}
			}
		}
	}
}
struct classNoteee: Codable{
	var uuid: String
	var title: String
	var content: String
	var postDateTime: [String: String]
	
	init?(_ json: [String: Any]){
		guard let uuid = json["uuid"] as? String,
			let title = json["title"] as? String,
			let content = json["content"] as? String,
			let postDateTime = json["postDateTime"] as? [String: String] else{
				return nil
		}
		self.uuid = uuid
		self.title = title
		self.content = content
		self.postDateTime = postDateTime
	}
	init(){
		self.uuid = ""
		self.title = ""
		self.content = ""
		self.postDateTime = ["": ""]
	}
}



struct dailyClass: Codable{
	var uuid: String
	var title: String
	var startDateTime: [String: String]
	var endDateTime: [String: String]
	var location: String
	var teacher: String
	var classNote: classNoteee
	
	init?(_ json: [String: Any]){
		var localshit = classNoteee()
		guard let uuid = json["classUuid"] as? String, //Guranteed Shit
			let title = json["className"] as? String,
			
			let startDateTime = json["startTime"] as? [String: String],
			let endDateTime = json["endTime"] as? [String: String],
			let location = json["room"] as? String,
			let teacher = json["teacher"] as? String
			
			
			else {
				return nil
		}
		
		//Special optional shit
		if let classNotee = json["classNote"] as? [String: Any]{
			if let note = classNoteee(classNotee){
				localshit = note
				
			}
		} else {
			self.classNote = classNoteee()
		}
		let desc = "PLACEHOLDER"
		self.uuid = uuid
		self.title = title
		self.startDateTime = startDateTime
		self.endDateTime = endDateTime
		self.location = location
		self.teacher = teacher
		self.classNote = localshit
		
	}
	init() {
		self.uuid = "uuid"
		self.title = "title"
		self.startDateTime = ["Start": "End"]
		self.endDateTime = ["Start": "End"]
		self.location = "location"
		self.teacher = "teacher"
		self.classNote = classNoteee()
	}
	
}

struct annoncement: Codable{
	var id: [String: Int]
	var title: String
	var desc: String
	var poster: String
	var type: String
	var bannerImage: [String: String]
	var content: String
	var uuid: String
	var postDateTime:[String: String]
	var editDateTime:[String: String]
	var resources: [[String: String]]
	var targetAudience: [String]
	var tags: [String]
	
	init?(_ json: [String: Any]){
		guard
			let id = json["id"] as? [String: Int],
			let title = json["title"] as? String,
			let desc = json["desc"] as? String,
			let poster = json["poster"] as? String,
			let type = json["type"] as? String,
			let bannerImage = json["bannerImage"] as? [String: String],
			let content = json["content"] as? String,
			let uuid = json["uuid"] as? String,
			let postDateTime = json["postDateTime"] as? [String: String],
			let editDateTime = json["editDateTime"] as? [String: String],
			let resources = json["resources"] as? [[String: String]],
			let targetAudience = json["targetAudience"] as? [String],
			let tags = json["tags"] as? [String]
		else{
				return nil
		}
		
		self.id = id
		self.title = title
		self.desc = desc
		self.poster = poster
		self.type = type
		self.bannerImage = bannerImage
		self.content = content
		self.uuid = uuid
		self.postDateTime = postDateTime
		self.editDateTime = editDateTime
		self.resources = resources
		self.targetAudience = targetAudience
		self.tags = tags
	}
	
	init(){
		self.id = ["": 0]
		self.title = ""
		self.desc = ""
		self.poster = ""
		self.type = ""
		self.bannerImage = ["": ""]
		self.content = ""
		self.uuid = ""
		self.postDateTime = ["": ""]
		self.editDateTime = ["": ""]
		self.resources =  [["": ""]]
		self.targetAudience = [""]
		self.tags = [""]
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


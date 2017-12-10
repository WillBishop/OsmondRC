//
//  dataModels.swift
//  OsmondRC
//
//  Created by Will Bishop on 9/12/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import Foundation

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

struct homework: Codable{
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
}

struct stirlingClass: Codable{
	var className: String?
	var classUuid: String?
	
	init?(_ json: [String: Any]){
		guard let className = json["className"] as? String,
			let classUuid = json["classUuid"] as? String else {
				return nil
		}
		self.className = className
		self.classUuid = classUuid
	}
	init(){
		self.className = ""
		self.classUuid = ""
	}
}

struct resource: Codable{
	var owner: String
	var resUuid: String
	var filePath: String
	var arType: String
	
	init?(_ json: [String: Any]){
		guard let owner = json["owner"] as? String,
		let resUuid = json["resUuid"] as? String,
		let filePath = json["filePath"] as? String,
			let arType = json["arType"] as? String else{
				return nil
		}
		self.owner = owner
		self.resUuid = resUuid
		self.filePath = filePath
		self.arType = arType
	}
}


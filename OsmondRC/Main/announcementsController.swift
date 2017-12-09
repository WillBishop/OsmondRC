//
//  announcementsController.swift
//  OsmondRC
//
//  Created by Will Bishop on 9/12/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import UIKit

class announcementsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var announcementTable: UITableView!
	

	var announcements = [annoncement]()
	var selectedRow = IndexPath()
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		Stirling.announcements().getAnnouncements(completionHandler: {numpty in
			let encoder = JSONEncoder()
			if let encoded = try? encoder.encode(numpty){
				UserDefaults().set(encoded, forKey: "announcements")
				self.announcements = numpty
				self.announcementTable.reloadData()
			}
		})
		announcementTable.separatorColor = UIColor.flatColors.light.red
		
		if let exisitingData = UserDefaults.standard.object(forKey: "announcements") as? Data{
			
			//Data Exisits
			let decoder = JSONDecoder()
			if let announcement = try? decoder.decode([annoncement].self, from: exisitingData) as [annoncement]{
				announcements = announcement
			}
			
		} else{
			//print("Wouldn't let")
		}
		
		
		announcementTable.delegate = self
		announcementTable.dataSource = self
		announcementTable.tableFooterView = UIView()
		announcementTable.backgroundColor = UIColor.flatColors.dark.red
		view.backgroundColor = UIColor.flatColors.dark.red
		
	}
	

	override func viewWillAppear(_ animated: Bool) {
		tabBarController?.navigationItem.title = "Announcements"

	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return announcements.count
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 124
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = announcementTable.dequeueReusableCell(withIdentifier: "announcementCell") as! announcementCell
		let info = announcements[indexPath.row]
		
		cell.title = info.title
		cell.time = info.postDateTime["time"]!
		cell.subject = info.desc
		cell.announcementText = info.content
		cell.poster = info.poster
		cell.contentView.backgroundColor = UIColor.flatColors.dark.red
		cell.update()
		
		return cell
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let classView = storyboard?.instantiateViewController(withIdentifier: "viewAnnouncement")
		self.navigationController?.pushViewController(classView!, animated: true)
		
		let jsonencoder = JSONEncoder()
		
		if let announce = try? jsonencoder.encode(announcements[indexPath.row]){
			UserDefaults().set(announce, forKey: "selectedAnnouncement")
		}
		selectedRow = indexPath
	}
	override func viewDidDisappear(_ animated: Bool) {
		announcementTable.deselectRow(at: selectedRow, animated: true)
	}
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
			cell.separatorInset = UIEdgeInsets.zero
		}
		if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
			cell.layoutMargins = UIEdgeInsets.zero
		}
		if cell.responds(to: #selector(setter: UITableViewCell.preservesSuperviewLayoutMargins)) {
			cell.preservesSuperviewLayoutMargins = false
		}
	}
}

class announcementCell: UITableViewCell{
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var posterLabel: UILabel!
	@IBOutlet weak var subjectLabel: UILabel!
	@IBOutlet weak var announcementTextView: UITextView!
	@IBOutlet weak var titleLabel: UILabel!
	
	var title = ""
	var time = ""
	var poster = ""
	var subject = ""
	var announcementText = ""
	
	func update(){
		timeLabel.text = time
		posterLabel.text = poster
		subjectLabel.text = subject
		announcementTextView.text = announcementText
		titleLabel.text = title
	}
}

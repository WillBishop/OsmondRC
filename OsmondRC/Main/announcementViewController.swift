//
//  announcementViewController.swift
//  OsmondRC
//
//  Created by Will Bishop on 9/12/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import UIKit

class announcementViewController: UIViewController {

	@IBOutlet weak var textVw: UITextView!
	var theannouncement = annoncement()
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var posterLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		let decoder = JSONDecoder()
		if let decodable = UserDefaults().value(forKey: "selectedAnnouncement") as? Data{
			if let unwrappedannouncement = try? decoder.decode(annoncement.self, from: decodable) as annoncement{
				theannouncement = unwrappedannouncement
				
			}
		}
		self.navigationItem.title = theannouncement.title
		navigationController?.navigationBar.largeTitleTextAttributes = [
			NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32.0, weight: .bold),
			NSAttributedStringKey.foregroundColor: UIColor.white
		]
		dateLabel.text = "\(theannouncement.postDateTime["time"]!) - \(theannouncement.postDateTime["date"]!)"
		posterLabel.text = theannouncement.poster
		textVw.text = theannouncement.content
		
		
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.navigationBar.largeTitleTextAttributes = [
			NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32.0, weight: .bold),
			NSAttributedStringKey.foregroundColor: UIColor.white
		]
	}
}



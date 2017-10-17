//
//  ViewController.swift
//  OsmondRC
//
//  Created by Will Bishop on 15/10/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import UIKit
import KeychainSwift

class todayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var classTable: UITableView!
	
	let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	let colors = UIColor.flatColors().flatColorRainbow
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let weekday = Calendar.current.component(.weekday, from: Date())
		navigationItem.title = days[weekday - 1] //-1 Because array starts at 0
		//navigationController?.navigationBar.prefersLargeTitles = true
		let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
		self.navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
		classTable.separatorColor = UIColor.clear
		// Do any additional setup after loading the view, typically from a nib.
		classTable.delegate = self
		classTable.dataSource = self
		classTable.tableFooterView = UIView()
	}
	override func viewDidAppear(_ animated: Bool) {
		

		self.navigationController?.navigationBar.barTintColor = classTable.cellForRow(at: IndexPath(row: 0, section: 0))?.backgroundColor
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70.0
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = classTable.dequeueReusableCell(withIdentifier: "classCellReuse") as? classCell
		cell?.backgroundColor = colors[indexPath.row]
		
		cell?.classRoom = "2FT03"
		cell?.classTime = "8:45 AM - 9:00 AM"
		cell?.classTeacher = "Damon Smith"
		cell?.className = "Home Group"
		cell?.update()
		
		
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vrigerg = storyboard?.instantiateViewController(withIdentifier: "classView")
		self.navigationController?.pushViewController(vrigerg!, animated: true)
		let color = classTable.cellForRow(at: indexPath)?.backgroundColor
		
		UserDefaults().setColor(color: color, forKey: "selectedColor")
		
		classTable.deselectRow(at: indexPath, animated: true)
	}
}

class classCell: UITableViewCell{
	@IBOutlet weak var classOutlet: UILabel!
	@IBOutlet weak var timeOutlet: UILabel!
	@IBOutlet weak var teacherOutlet: UILabel!
	@IBOutlet weak var roomOutlet: UILabel!
	
	var className = String()
	var classTime = String()
	var classTeacher = String()
	var classRoom = String()
	func update(){
		classOutlet.text = className
		timeOutlet.text = classTime
		teacherOutlet.text = classTeacher
		roomOutlet.text = classRoom
	}
}


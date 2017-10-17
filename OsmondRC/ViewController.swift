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
	let darkColors = UIColor.flatColors().darkColorRainbow
	
	override func viewDidLoad() {
		super.viewDidLoad()
		classTable.separatorColor = UIColor.clear
		// Do any additional setup after loading the view, typically from a nib.
		classTable.delegate = self
		classTable.dataSource = self
		classTable.tableFooterView = UIView()
		
	}
	override func viewDidAppear(_ animated: Bool) {
		setupNavBar()
		let bgColor = classTable.cellForRow(at: IndexPath(row: 0, section: 0))?.backgroundColor
		self.navigationController?.navigationBar.barTintColor = bgColor
		view.backgroundColor = bgColor
		classTable.backgroundColor = bgColor
		navigationController?.navigationBar.backgroundColor = bgColor
		UserDefaults().setColor(color: classTable.cellForRow(at: IndexPath(row: 0, section: 0))?.backgroundColor, forKey: "todayColor")
		
	}
	
	func setupNavBar(){
		let weekday = Calendar.current.component(.weekday, from: Date())
		navigationItem.title = days[weekday - 1] //-1 Because array starts at 0
		let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
		navigationController?.navigationBar.shadowImage = UIImage()
		let suggestImage  = UIImage(named: "profilePicture")!.withRenderingMode(.alwaysOriginal)
		let suggestButton = UIButton(frame: CGRect(x:0, y:0, width:40, height:40))
		suggestButton.setBackgroundImage(suggestImage, for: .normal)
		suggestButton.addTarget(self, action: #selector(selectedProfile), for:.touchUpInside)
		
		// here where the magic happens, you can shift it where you like
		suggestButton.transform = CGAffineTransform(translationX: 10, y: 0)
		
		// add the button to a container, otherwise the transform will be ignored
		let suggestButtonContainer = UIView(frame: suggestButton.frame)
		suggestButtonContainer.addSubview(suggestButton)
		let suggestButtonItem = UIBarButtonItem(customView: suggestButtonContainer)
		
		// add button shift to the side
		navigationItem.rightBarButtonItem = suggestButtonItem
		
		self.tabBarController?.tabBar.barTintColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.00)
		self.tabBarController?.tabBar.tintColor = UIColor.black
	}
	@objc func selectedProfile(){
		print("Go")
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 7
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70.0
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = classTable.dequeueReusableCell(withIdentifier: "classCellReuse") as? classCell
		cell?.backgroundColor = colors[indexPath.row]
		cell?.darkColor = darkColors[indexPath.row]
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
		let color = classTable.cellForRow(at: indexPath) as? classCell
		
		UserDefaults().setColor(color: color?.backgroundColor, forKey: "selectedColor")
		UserDefaults().setColor(color: color?.darkColor, forKey: "selectedDarkColor")
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
	var darkColor = UIColor()
	func update(){
		classOutlet.text = className
		timeOutlet.text = classTime
		teacherOutlet.text = classTeacher
		roomOutlet.text = classRoom
	}
}


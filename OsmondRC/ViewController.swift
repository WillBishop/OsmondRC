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
	var selectedRow = IndexPath()
	
	let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	let colors = UIColor.flatColors().flatColorRainbow
	let darkColors = UIColor.flatColors().darkColorRainbow
	var dailyClasses = [dailyClass]()
	
	override func viewWillAppear(_ animated: Bool) {
		if let exisitingData = UserDefaults.standard.object(forKey: "dailyClasses") as? Data{
			
			//Data Exisits
			let decoder = JSONDecoder()
			if let dailyClass = try? decoder.decode([dailyClass].self, from: exisitingData) as [dailyClass]{
					dailyClasses = dailyClass
			}
			
		} else{
			print("Wouldn't let")
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		classTable.separatorColor = UIColor.clear
		// Do any additional setup after loading the view, typically from a nib.
		classTable.delegate = self
		classTable.dataSource = self
		
		classTable.tableFooterView = UIView()
		self.automaticallyAdjustsScrollViewInsets = false
		
		UIGraphicsEndImageContext()
		Stirling.classes().getDaily(completionHandler: {result in
			self.dailyClasses.removeAll()
			for (_, element) in result.enumerated(){
				self.dailyClasses.append(element)
				self.classTable.reloadData()
				print("done")


			}
			let encoder = JSONEncoder()
			
			if let encoded = try? encoder.encode(result){
				UserDefaults().set(encoded, forKey: "dailyClasses")
			}
		})
		
	}
	override func viewDidAppear(_ animated: Bool) {
		setupNavBar()
		let bgColor = classTable.cellForRow(at: IndexPath(row: 0, section: 0))?.backgroundColor
		self.navigationController?.navigationBar.barTintColor = bgColor
		view.backgroundColor = bgColor
		navigationController?.navigationItem.largeTitleDisplayMode = .always
		self.tabBarController?.tabBar.barTintColor = UIColor.white
		
		classTable.backgroundColor = bgColor
		navigationController?.navigationBar.backgroundColor = bgColor
		UserDefaults().setColor(color: classTable.cellForRow(at: IndexPath(row: 0, section: 0))?.backgroundColor, forKey: "todayColor")
		
	}
	
	func setupNavBar(){
		let weekday = Calendar.current.component(.weekday, from: Date())
		navigationItem.title = days[weekday - 1] //-1 Because array starts at 0
		let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
		//navigationController?.navigationBar.prefersLargeTitles = true
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
		
	}
	@objc func selectedProfile(){
		print("Go")
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dailyClasses.count
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return classTable.bounds.height / CGFloat(dailyClasses.count)
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = classTable.dequeueReusableCell(withIdentifier: "classCellReuse") as? classCell
		cell?.backgroundColor = colors[indexPath.row]
		cell?.darkColor = darkColors[indexPath.row]
		let info = dailyClasses[indexPath.row]
		
		cell?.classRoom = info.location
		cell?.classTime = "\(info.startDateTime["time"]!) - \(info.endDateTime["time"]!) "
		cell?.classTeacher = "Placeholder"
		cell?.className = info.title
								.replacingOccurrences(of: "10 ", with: "")
								.replacingOccurrences(of: " Lesson", with: "")
		cell?.update()
		
		
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let classView = storyboard?.instantiateViewController(withIdentifier: "classView")
		self.navigationController?.pushViewController(classView!, animated: true)
		
		let backItem = UIBarButtonItem()
		let weekday = Calendar.current.component(.weekday, from: Date())
		backItem.title = days[weekday - 1]
		navigationItem.backBarButtonItem = backItem
		let color = classTable.cellForRow(at: indexPath) as? classCell
		
		UserDefaults().setColor(color: color?.backgroundColor, forKey: "selectedColor")
		UserDefaults().setColor(color: color?.darkColor, forKey: "selectedDarkColor")
		let encoder = JSONEncoder()
		if let encoded = try? encoder.encode(dailyClasses[indexPath.row]){
			UserDefaults().set(encoded, forKey: "selectedClass")
		}
		selectedRow = indexPath
	}
	override func viewDidDisappear(_ animated: Bool) {
		classTable.deselectRow(at: selectedRow, animated: true)
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


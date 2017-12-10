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
	var profileImage = UIImage()
	
	override func viewWillAppear(_ animated: Bool) {
		if let existingImage = UserDefaults.standard.object(forKey: "userImage") as? Data{
			if let converted = UIImage(data: existingImage){
				profileImage = converted
			}
		}
		if let exisitingData = UserDefaults.standard.object(forKey: "dailyClasses") as? Data{
			
			//Data Exisits
			let decoder = JSONDecoder()
			if let dailyClass = try? decoder.decode([dailyClass].self, from: exisitingData) as [dailyClass]{
					dailyClasses = dailyClass
			}
			
		} else{
			//print("Wouldn't let")
		}
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		classTable.separatorColor = UIColor.clear
		// Do any additional setup after loading the view, typically from a nib.
		classTable.delegate = self
		classTable.dataSource = self
		//classTable.isScrollEnabled = false
		classTable.tableFooterView = UIView()
		self.automaticallyAdjustsScrollViewInsets = true
		UIGraphicsEndImageContext()
		Stirling.classes().getDaily(completionHandler: {result in
			self.dailyClasses.removeAll()
			for (_, element) in result.enumerated(){
				self.dailyClasses.append(element)
				self.classTable.reloadData()
				//print("done")


			}
		})
		
		if let existingImage = UserDefaults.standard.object(forKey: "userImage") as? Data{
			if let converted = UIImage(data: existingImage){
				let suggestImage  = converted
				let suggestButton = UIButton(frame: CGRect(x:0, y:0, width:40, height:40))
				suggestButton.setBackgroundImage(suggestImage, for: .normal)
				suggestButton.addTarget(self, action: #selector(selectedProfile), for:.touchUpInside)
				
				// here where the magic happens, you can shift it where you like
				suggestButton.transform = CGAffineTransform(translationX: 10, y: 0)
				
				// add the button to a container, otherwise the transform will be ignored
				let suggestButtonContainer = UIView(frame: suggestButton.frame)
				suggestButtonContainer.addSubview(suggestButton)
				let suggestButtonItem = UIBarButtonItem(customView: suggestButtonContainer)
				
				// add button shift to the sides
				tabBarController?.navigationItem.rightBarButtonItem = suggestButtonItem
			}
		}
		
	}
	@objc func selectedProfile(){
		let classView = storyboard?.instantiateViewController(withIdentifier: "accountView")
		self.navigationController?.pushViewController(classView!, animated: true)
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
		tabBarController?.tabBar.tintColor = UserDefaults().colorForKey(key: "todayColor")
		view.backgroundColor = UserDefaults().colorForKey(key: "todayColor")
		navigationController?.view.backgroundColor = UserDefaults().colorForKey(key: "todayColor")
		tabBarController?.navigationController?.view.backgroundColor = UserDefaults().colorForKey(key: "todayColor")
		navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "signInOut").withRenderingMode(.alwaysOriginal)
		Stirling.accounts().getProfilePicture(completionHandler: { image in
			self.setupNavBar()
			UserDefaults.standard.set(UIImagePNGRepresentation(image), forKey: "userImage")
		})
	}
	
	func setupNavBar(){
		let weekday = Calendar.current.component(.weekday, from: Date())
		navigationItem.title = days[weekday - 1] //-1 Because array starts at 0
		let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
		//navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
		
		tabBarController?.navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
		tabBarController?.navigationController?.navigationBar.shadowImage = UIImage()
		let parent = self.parent as! UITabBarController
		parent.navigationItem.title = days[weekday - 1]
		
		
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
		cell?.classTime = "\(info.startDateTime["time"]!)"
		cell?.classTeacher = info.teacher
		cell?.className = info.title
								.replacingOccurrences(of: "10 ", with: "")
								.replacingOccurrences(of: " Lesson", with: "")
		
		cell?.classNote = info.classNote.title + "\n" + info.classNote.content.replacingOccurrences(of: "\n\n", with: "\n")
		if info.classNote.title.isEmpty && info.classNote.content.isEmpty{
			Stirling.classes().getLatestNote(info.uuid, completionHandler: {note in
				(tableView.cellForRow(at: indexPath) as? classCell)?.storedNote = note
				if note.content.range(of: note.title) != nil{ //If title in note itself, omit title from view
					(tableView.cellForRow(at: indexPath) as? classCell)?.noteOutlet.text = "LAST NOTE: " + note.content.trimmingCharacters(in: .whitespacesAndNewlines)
									.replacingOccurrences(of: "\n\n", with: "\n")
				} else{
					(tableView.cellForRow(at: indexPath) as? classCell)?.noteOutlet.text = "LAST NOTE: " + note.title + "\n" + note.content
	
						.trimmingCharacters(in: .whitespacesAndNewlines)
						.replacingOccurrences(of: "\n\n", with: "\n")
				}
				
			})
		}
		
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
		if let encoded = try? encoder.encode((classTable.cellForRow(at: indexPath) as? classCell)?.storedNote){
			UserDefaults().set(encoded, forKey: "oldNote")
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
	@IBOutlet weak var noteOutlet: UITextView!
	
	var storedNote = classNoteee()
	var className = String()
	var classTime = String()
	var classTeacher = String()
	var classRoom = String()
	var classNote = String()
	var darkColor = UIColor()
	func update(){
		classOutlet.text = className
		timeOutlet.text = classTime
		teacherOutlet.text = classTeacher
		roomOutlet.text = classRoom
		noteOutlet.text = classNote
	}
}


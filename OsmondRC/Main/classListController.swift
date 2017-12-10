//
//  classListController.swift
//  OsmondRC
//
//  Created by Will Bishop on 10/12/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import UIKit

class classListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var classTable: UITableView!
	var classes = [stirlingClass]()
	var selectedRow = IndexPath()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		classTable.delegate = self
		classTable.dataSource = self
		classTable.backgroundColor = UIColor.flatColors.dark.red
		classTable.separatorColor = UIColor.flatColors.light.red

		let jsondecoder = JSONDecoder()
		if let data = UserDefaults().value(forKey: "completeClassList") as? Data{
			if let decod = try? jsondecoder.decode([stirlingClass].self, from: data){
				self.classes = decod
				classTable.reloadData()
			}
			
		}
		Stirling.classes().getClassList(completionHandler: { result in
			self.classes = result
			self.classTable.reloadData()
		})
        // Do any additional setup after loading the view.
    }
	override func viewWillAppear(_ animated: Bool) {
		tabBarController?.navigationItem.title = "Resources"
		
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return classes.count
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return (classTable.frame.height / CGFloat(classes.count))
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = classTable.dequeueReusableCell(withIdentifier: "classListCell") as! UITableViewCell
		cell.textLabel?.text = classes[indexPath.row].className
		cell.textLabel?.textColor = UIColor.white
		cell.contentView.backgroundColor = UIColor.flatColors.dark.red
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedRow = indexPath
		let classView = storyboard?.instantiateViewController(withIdentifier: "classController")
		self.navigationController?.pushViewController(classView!, animated: true)
		
		let encoder = JSONEncoder()
		if let encoded = try? encoder.encode(classes[indexPath.row]){
			UserDefaults().set(encoded, forKey: "selectedGlobalClass")
		}
		
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

	override func viewDidDisappear(_ animated: Bool) {
		classTable.deselectRow(at: selectedRow, animated: true)
	}

}


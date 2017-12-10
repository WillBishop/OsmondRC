//
//  classController.swift
//  OsmondRC
//
//  Created by Will Bishop on 10/12/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import UIKit
import PDFReader

import KeychainSwift

class classController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var resourceTable: UITableView!
	var resources = [resource]()
	var selectedClass = stirlingClass()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Files"
		let decoder = JSONDecoder()
		
		
		
		resourceTable.tableFooterView = UIView()
		resourceTable.backgroundColor = UIColor.flatColors.dark.red
		if let decodable = UserDefaults().value(forKey: "selectedGlobalClass") as? Data{
			if let resourcess = try? decoder.decode(stirlingClass.self, from: decodable) as stirlingClass{
				if let decoded = UserDefaults().value(forKey: "resources-\(resourcess.classUuid!)") as? Data{
					print("Found a cache")
					if let decod = try? decoder.decode([resource].self, from: decoded){
						self.resources = decod
						print("Already cache")
						resourceTable.reloadData()
					}
				}
				Stirling.classes().getResouces(resourcess.classUuid!, completionHandler: {result in
					self.resources = result
					self.selectedClass = resourcess
					self.resourceTable.reloadData()
				})
			}
		}
		resourceTable.delegate = self
		resourceTable.dataSource = self
		
		
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 71
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return resources.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = resourceTable.dequeueReusableCell(withIdentifier: "resourceCell") as? resourceCell
		let info = resources[indexPath.row]
		cell?.fileNameString = info.filePath
		cell?.contentView.backgroundColor = UIColor.flatColors.dark.red
		cell?.hide()
		cell?.update()
		
		return cell!
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let indicator = UIActivityIndicatorView(frame: (resourceTable.cellForRow(at: indexPath)?.frame)!)
		indicator.startAnimating()
		resourceTable.cellForRow(at: indexPath)?.contentView.addSubview(indicator)
		let info = resources[indexPath.row]
		let keychain = KeychainSwift()
		let password = keychain.get("password")
		let accountName = keychain.get("accountName")
		if let password = password, let accountName = accountName{
			
			let remotePDFDocumentURLPath = "https://da.gihs.sa.edu.au/stirling/v3/classes/download/resource?accountName=\(accountName)&password=\(password)&classUuid=\(selectedClass.classUuid!)&resourceUuid=\(info.resUuid)"

			let documentRemoteURL = URL(string: remotePDFDocumentURLPath)!
			if let document = PDFDocument(url: documentRemoteURL){

				let readerController = PDFViewController.createNew(with: document)
				readerController.title = info.filePath

				navigationController?.pushViewController(readerController, animated: true)
			
				
			} else{
				resourceTable.deselectRow(at: indexPath, animated: true)
			}
			
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
	
	
}

class resourceCell: UITableViewCell{
	@IBOutlet weak var fileName: UILabel!
	@IBOutlet weak var progressIndicator: UIProgressView!
	
	
	var progress = Float()
	var fileNameString = String()
	func hide(){
		progressIndicator.isHidden = true
	}
	func unhide(){
		progressIndicator.isHidden = false
	}
	func update(){
		fileName.text = fileNameString
		progressIndicator.progress = 0
		
	}
}

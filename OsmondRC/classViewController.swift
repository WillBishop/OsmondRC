//
//  classViewController.swift
//  OsmondRC
//
//  Created by Will Bishop on 17/10/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import UIKit

class classViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.navigationBar.barTintColor = UserDefaults().colorForKey(key: "selectedColor")
		UIView.animate(withDuration: 5.0, animations: {
			self.tabBarController?.tabBar.barTintColor = UserDefaults().colorForKey(key: "selectedColor")
			
		})
		navigationItem.title = "Home Group"
		self.view.backgroundColor = UserDefaults().colorForKey(key: "selectedDarkColor")
        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		navigationController?.navigationBar.barTintColor = UserDefaults().colorForKey(key: "selectedColor")
		self.tabBarController?.tabBar.barTintColor = UserDefaults().colorForKey(key: "selectedColor")
		

	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func willMove(toParentViewController parent: UIViewController?) { //Don't ask question, this smoothly changes color, no idea how
		UIView.animate(withDuration: 1.0, animations: {
			print("setting color")
			self.navigationController?.navigationBar.barTintColor = UserDefaults().colorForKey(key: "todayColor")
			self.tabBarController?.tabBar.barTintColor =  UserDefaults().colorForKey(key: "todayColor")

		})
		
	}
	override func didMove(toParentViewController parent: UIViewController?) {
		print("doen")

	}

}

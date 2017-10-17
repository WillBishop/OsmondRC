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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func willMove(toParentViewController parent: UIViewController?) { //Don't ask question, this smoothly changes color, no idea how
		UIView.animate(withDuration: 0.0, animations: {
			self.navigationController?.navigationBar.barTintColor = UIColor.flatColors.light.red
		})
	}

}

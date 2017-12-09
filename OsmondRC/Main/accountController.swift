//
//  accountController.swift
//  OsmondRC
//
//  Created by Will Bishop on 2/12/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import UIKit

class accountController: UIViewController {
	let displayName =  UserDefaults.standard.object(forKey: "accountDisplayName") as? String ?? UserDefaults.standard.object(forKey: "accountName") as? String
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = displayName
		Stirling.accounts().getDisplayName(completionHandler: { name in
			self.navigationItem.title = name
			UserDefaults.standard.set(name, forKey: "accountDisplayName")
		})
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

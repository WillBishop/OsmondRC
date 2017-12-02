//
//  onboardOneController.swift
//  OsmondRC
//
//  Created by Will Bishop on 28/10/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import UIKit
import Alamofire
class onboardOneController: UIViewController {
	
	
	@IBOutlet weak var dummyBackground: UIImageView!
	
	@IBOutlet weak var getStarted: UIButton!
	@IBOutlet weak var signedUp: UIButton!
	
	override func viewWillAppear(_ animated: Bool) {
		if let logged = UserDefaults.standard.object(forKey: "loggedIn") as? Bool{
			if logged{
				Stirling.accounts().loggedIn()
			}
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dummyBackground.isHidden = true
		signedUp.layer.borderColor = UIColor.flatColors.light.blue.cgColor
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	@IBAction func proceed(_ sender: Any) {
		NotificationCenter.default.post(name: Notification.Name(rawValue: "moveNext"), object: nil)
		
	}
	func checkDaymapCredentials(_ username: String, _ password: String, completion: @escaping (_: Int) -> Void){
		Alamofire.request("https://daymap.gihs.sa.edu.au/daymap/student/dayplan.aspx", method: .get)
			.authenticate(user: username, password: password)
			.responseString { response in
				if let status = response.response?.statusCode{
					completion(status)
				}
		}
	}
	
	
	
}

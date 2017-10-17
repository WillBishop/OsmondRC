//
//  classViewController.swift
//  OsmondRC
//
//  Created by Will Bishop on 17/10/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import UIKit

class classViewController: UIViewController, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.navigationBar.barTintColor = UserDefaults().colorForKey(key: "selectedColor")
		UIView.animate(withDuration: 5.0, animations: {
			self.tabBarController?.tabBar.barTintColor = UserDefaults().colorForKey(key: "selectedColor")
			
		})
		self.navigationController?.transitioningDelegate = self
		let selectedClass = UserDefaults().object(forKey: "selectedClass") as! [String: String]
		navigationController?.navigationItem.largeTitleDisplayMode = .always
		navigationItem.title = selectedClass["className"]
		self.view.backgroundColor = UserDefaults().colorForKey(key: "selectedDarkColor")
		let length = selectedClass["className"]?.count
		if length! > 18{
			navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 28.0), NSAttributedStringKey.foregroundColor : UIColor.white]
		}
		
		
        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		navigationController?.navigationBar.barTintColor = UserDefaults().colorForKey(key: "selectedColor")
		navigationController?.interactivePopGestureRecognizer?.delegate = self
		navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(onGesture(_:)))
	//	navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		let todayColor = UserDefaults().colorForKey(key: "todayColor")
		let selectedColor = UserDefaults().colorForKey(key: "selectedColor")
		
		
		
		

		
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func willMove(toParentViewController parent: UIViewController?) { //Don't ask question, this smoothly changes color, no idea how
		UIView.animate(withDuration: 0.0, animations: {
			print("setting color")
			self.navigationController?.navigationBar.barTintColor = UserDefaults().colorForKey(key: "todayColor")

		})

		
	}
	@objc func going(_ sender: UIGestureRecognizer?){
		if let sender = sender as? UIScreenEdgePanGestureRecognizer{
			print(sender.edges)
		}
	}
	private var currentTransitionCoordinator: UIViewControllerTransitionCoordinator?
	func blend(from: UIColor, to: UIColor, percent: Double) -> UIColor {
		var fR : CGFloat = 0.0
		var fG : CGFloat = 0.0
		var fB : CGFloat = 0.0
		var tR : CGFloat = 0.0
		var tG : CGFloat = 0.0
		var tB : CGFloat = 0.0
		
		from.getRed(&fR, green: &fG, blue: &fB, alpha: nil)
		to.getRed(&tR, green: &tG, blue: &tB, alpha: nil)
		
		let dR = tR - fR
		let dG = tG - fG
		let dB = tB - fB
		
		let rR = fR + dR * CGFloat(percent)
		let rG = fG + dG * CGFloat(percent)
		let rB = fB + dB * CGFloat(percent)
		
		return UIColor(red: rR, green: rG, blue: rB, alpha: 1.0)
	}
	@objc private func onGesture(_ sender: UIGestureRecognizer) {
		switch sender.state {
		case .began, .changed:
			if let ct = navigationController?.transitionCoordinator {
				currentTransitionCoordinator = ct
				navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
			}
		case .cancelled, .ended:
			currentTransitionCoordinator = nil
		case .possible, .failed:
			break
		}
		
		if let currentTransitionCoordinator = currentTransitionCoordinator {
			
		}
		}
		
	
	override func didMove(toParentViewController parent: UIViewController?) {
		print("doen")

	}

}

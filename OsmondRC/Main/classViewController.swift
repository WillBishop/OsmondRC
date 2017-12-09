//
//  classViewController.swift
//  OsmondRC
//
//  Created by Will Bishop on 17/10/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import UIKit

class classViewController: UIViewController, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate{
	@IBOutlet weak var noteContent: UITextView!
	@IBOutlet weak var noteTitle: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
	//	noteTitle.text = ""
		noteContent.text = ""
		self.navigationController?.navigationBar.barTintColor = UserDefaults().colorForKey(key: "selectedColor")
		navigationController?.navigationItem.largeTitleDisplayMode = .always
		self.navigationController?.transitioningDelegate = self
		let decoder = JSONDecoder()
		var selectedClass = dailyClass()
		
		if let decodable = UserDefaults().value(forKey: "selectedClass") as? Data{
			if let dailyClasses = try? decoder.decode(dailyClass.self, from: decodable) as dailyClass{
				selectedClass = dailyClasses
				if !(dailyClasses.classNote.content.isEmpty){
					
					var yourString = "\(dailyClasses.classNote.title) \n\(dailyClasses.classNote.content)"
					var yourAttributedString = NSMutableAttributedString(string: yourString)
					var boldString = dailyClasses.classNote.title
					var boldRange: NSRange? = (yourString as NSString).range(of: boldString)
					yourAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17.0), range: ((yourString as? NSString)?.range(of: yourString))!)
					yourAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 32), range: boldRange ?? NSRange())
					yourAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: ((yourString as? NSString)?.range(of: yourString))!)
					
					noteContent.attributedText = yourAttributedString
					//noteTitle.text = dailyClasses.classNote.title
					
				}
			}
		}
		if (noteContent.text?.isEmpty)!{
			if let decodable = UserDefaults().value(forKey: "oldNote") as? Data{
				if let oldNote = try? decoder.decode(classNoteee.self, from: decodable) as classNoteee{
					var yourString = "\(oldNote.title) \n\(oldNote.content)"
					var yourAttributedString = NSMutableAttributedString(string: yourString)
					var boldString = oldNote.title
					var boldRange: NSRange? = (yourString as NSString).range(of: boldString)
					yourAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17.0), range: ((yourString as? NSString)?.range(of: yourString))!)

					yourAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 32), range: boldRange ?? NSRange())
					yourAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: ((yourString as? NSString)?.range(of: yourString))!)
					noteContent.attributedText = yourAttributedString
				}
			}
		}
		noteContent.sizeToFit()
		navigationController?.navigationItem.largeTitleDisplayMode = .always
		navigationItem.title = selectedClass.title
											.replacingOccurrences(of: "10 ", with: "")
											.replacingOccurrences(of: " Lesson", with: "")
		self.view.backgroundColor = UserDefaults().colorForKey(key: "selectedDarkColor")
		
		//Setup Nav-bar large title size per device
		let length = selectedClass.title.count
		

//		if length > 18{
//			navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 28.0), NSAttributedStringKey.foregroundColor : UIColor.white]
//		}
		
		
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

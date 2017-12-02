//
//  onboardPageController.swift
//  OsmondRC
//
//  Created by Will Bishop on 8/11/17.
//  Copyright © 2017 Will Bishop. All rights reserved.
//

import UIKit

class onboardPageController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	lazy var orderedViewControllers: [UIViewController] = {
		return [self.newVc(viewController: "osmondOnboardOne"), self.newVc(viewController: "osmondOnboardTwo") ]
	}()
	var current = 0;
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//self.dataSource = self
		if let firstViewController = orderedViewControllers.first {
			setViewControllers([firstViewController],
							   direction: .forward,
							   animated: true,
							   completion: nil
			)}
		
		var label: UILabel = {
			let newLabel = UILabel()
			newLabel.frame = CGRect(x: 52, y: 49, width: 310, height: 102)
			newLabel.textColor = UIColor.white
			newLabel.font = UIFont.systemFont(ofSize: 64, weight: .semibold)
			newLabel.text = "Osmond"
			newLabel.textAlignment = .center
			return newLabel
		}()
		self.view.addSubview(label)
		self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "gihsTwo"))
		NotificationCenter.default.addObserver(self, selector: #selector(moveNext), name: NSNotification.Name(rawValue: "moveNext"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(moveToMenu), name: NSNotification.Name(rawValue: "goToMenu"), object: nil)
		// Do any additional setup after loading the view.
	}
	
	@objc func moveToMenu(){
		setViewControllers([orderedViewControllers.first!], direction: .reverse, animated: true, completion: nil)
	}
	func newVc(viewController: String) -> UIViewController{
		return UIStoryboard(name: "Onboard", bundle: nil).instantiateViewController(withIdentifier: viewController)
	}
	
	@objc func moveNext(){
		setViewControllers([orderedViewControllers[current + 1]], direction: .forward, animated: true, completion: nil)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else{ return nil}
		
		let previousIndex = viewControllerIndex - 1
		
		guard previousIndex >= 0 else {
			return orderedViewControllers.last
		}
		guard orderedViewControllers.count > previousIndex else {
			return nil
		}
		
		return orderedViewControllers[previousIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else{ return nil}
		
		let nextIndex = viewControllerIndex + 1
		
		guard orderedViewControllers.count != nextIndex else {
			return orderedViewControllers.first
		}
		guard orderedViewControllers.count > nextIndex else {
			return nil
		}
		
		return orderedViewControllers[nextIndex]
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
}

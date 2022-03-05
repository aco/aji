//
//  LiveTabBar.swift
//  nea
//
//  Created by ac on 01/01/2019.
//  Copyright © 2019 abstersi. All rights reserved.
//

import Foundation
import UIKit

public class AnimatedTabBar: UITabBarController, UITabBarControllerDelegate {
	
	internal var entered = false
	
	public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		guard
			let tabViewControllers = tabBarController.viewControllers,
			let toIndex = tabViewControllers.firstIndex(of: viewController)
		else {
			return false
		}
		
		animateToTab(toIndex: toIndex)
		
		return true
	}
	
	func animateToTab(toIndex: Int) {
		guard
			let selectedVC = selectedViewController,
			let fromIndex = viewControllers?.firstIndex(of: selectedVC), fromIndex != toIndex,
			let fromView = selectedVC.view,
			let toView = viewControllers?[toIndex].view
		else {
			return
		}
		
		fromView.superview?.addSubview(toView)
		
		let screenWidth = Constant.padding * 2 // UIScreen.main.bounds.size.width / 8
		let offset = (toIndex > fromIndex ? screenWidth : -screenWidth)
		
		toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
		toView.alpha = 0
		
		self.view.isUserInteractionEnabled = false
		
		let animator = UIViewPropertyAnimator(duration: 0.66, timingParameters: Animator.shared.springTimingFunction)
		
		animator.addAnimations {
			fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y)
			toView.center = CGPoint(x: toView.center.x - offset, y: toView.center.y)
			toView.alpha = 1
			fromView.alpha = 0
		}
		
		animator.addCompletion { (position) in
			fromView.removeFromSuperview()
			
			self.selectedIndex = toIndex
			self.view.isUserInteractionEnabled = true
		}
		
		animator.startAnimation()
	}
	
	public override func viewWillLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		guard !self.entered, let items = self.tabBar.items else {
			return
		}
		
		for (index, item) in items.enumerated() {
			guard let itemView = item.value(forKey: "view") as? UIView else {
				return
			}

			Animator.applyEntranceAnimation(target: itemView, duration: 1.6, offset: Constant.padding, delay: Double(index) * 0.05,
																			direction: .up, fade: true)
		}
		
		self.entered = true
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self
		
		self.view.backgroundColor = Style.Colors.mainBackground
		
		let appearance = UITabBarAppearance()
		
		appearance.configureWithTransparentBackground()
		appearance.backgroundEffect = UIBlurEffect(style: .prominent)
		
		self.tabBar.standardAppearance = appearance
	}
}

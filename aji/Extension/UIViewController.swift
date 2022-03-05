//
//  UIViewController+Helpers.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/9/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

import UIKit

extension UIViewController {
	
	var statusBarManager: UIStatusBarManager? {
		return view.window?.windowScene?.statusBarManager
	}
	
	var statusBarFrame: CGRect {
		return statusBarManager?.statusBarFrame ?? .zero
	}
	
	var statusBarHeight: CGFloat {
		return statusBarFrame.height
	}
	
	var navigationBarHeight: CGFloat {
		return navigationController?.navigationBar.frame.height ?? .zero
	}

	var navigationControllerHeight: CGFloat {
		return statusBarHeight + navigationBarHeight
	}
}

extension UINavigationController {

	func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
		pushViewController(viewController, animated: animated)
		
		if animated, let coordinator = transitionCoordinator {
			coordinator.animate(alongsideTransition: nil) { _ in
				completion()
			}
		} else {
			completion()
		}
	}
}

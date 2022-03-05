//
//  SavedController+Interact.swift
//  aji
//
//  Created by aco on 18/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

extension SavedController: UpdateCookbooks {
	
	func cookbookChanged(database: Database) {
		DispatchQueue.main.async {
			if DataManager.sharedInstance.recipes(from: database).count < 1 {
				guard let index = self.collections.firstIndex(of: database) else {
					return
				}
				
				self.collections.remove(at: index)
				self.viewControllers.remove(at: index)
			} else if !self.collections.contains(database) {
				self.collections.append(database)
				self.viewControllers.append(RecipeCollectionController(database: database))
			}
			
			let animator = UIViewPropertyAnimator(duration: 1, timingParameters: Animator.shared.springTimingFunction)
			
			animator.addAnimations {
				self.reloadData()
				self.adjustTabScrollContentMode()
			}
			
			animator.startAnimation()
		}
	}
}

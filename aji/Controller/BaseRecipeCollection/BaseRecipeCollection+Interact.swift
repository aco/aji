//
//  BaseRecipeCollection+Interact.swift
//  aji
//
//  Created by aco on 18/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

extension BaseRecipeCollectionController {
	
	internal func presentProductBulletin() {
		self.manager = BLTNItemManager(rootItem: UpgradeBulletin(description: "Cook further."))
		self.manager?.showBulletin(above: self)
	}
	
	internal func presentNewCookbookBulletin(for recipe: Recipe) {
		let item = BulletinFactory.makeTextFieldPage(title: "New Cookbook", brief: "Enter a new name for your cookbook", buttonTitle: "Create", defaultValue: nil, placeholder: "Desserts", handler: { (item, text) in
			item.manager?.dismissBulletin(animated: true)
			
			guard let text = text else {
				return
			}
			
			DataManager.sharedInstance.append(recipe: recipe, to: .cookbook(name: text), broadcast: true)

			self.navigationController?.view.makeToast("Added to \(text.capitalized)")
		})
		
		self.manager = BLTNItemManager(rootItem: item)
		
		self.manager?.showBulletin(above: self, animated: true, completion: {
			item.textField.becomeFirstResponder()
		})
	}
}

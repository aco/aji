//
//  RecipeController+Modify.swift
//  aji
//
//  Created by aco on 22/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation

extension RecipeController {
	
	internal func modifyRecipeStage(indexPath: IndexPath) {
		let section = Section.allCases[indexPath.section]
		let item: FeedbackPageBLTNItem
		
		switch section {
			case .name:
				item = BulletinFactory.makeTextFieldPage(title: "Recipe Name", brief: "Enter a name for the recipe", buttonTitle: "Save", defaultValue: recipe.name, placeholder: "Creamy mac and cheese", handler: { (item, text) in
					item.manager?.dismissBulletin()
					
					self.recipe.name = text!
					self.captureSnapshot(broadcast: true)
				})
				
				break
			case .author:
				if let urlString = recipe.urlString {
					self.presentSafariViewController(urlString: urlString)
				}
				
				return
			case .prep:
				item = BulletinFactory.makeIntervalPickerPage(title: "Preparation Time", brief: "Total time chopping, slicing, seasoning, etc. of all ingredients", buttonTitle: "Next", defaultValue: recipe.prepTime * 60, handler: { (item) in
					guard let item = item as? IntervalPickerBulletin else {
						return
					}
					
					let cookItem = BulletinFactory.makeIntervalPickerPage(title: "Time to Cook", brief: "Total time in the oven, on the burner, resting, etc.", buttonTitle: "Next", defaultValue: self.recipe.cookTime * 60, handler: { (item) in
						guard let item = item as? IntervalPickerBulletin else {
							return
						}
						
						item.manager?.dismissBulletin()
						
						self.recipe.cookTime = Int(item.picker.countDownDuration / 60)
						
						self.captureSnapshot(broadcast: true)
					})
					
					item.manager?.push(item: cookItem)
					
					self.recipe.prepTime = Int(item.picker.countDownDuration / 60)
				})
				
				break
			case .description:
				item = BulletinFactory.makeTextFieldPage(title: "Description", brief: "Enter a backstory, description or extra information", buttonTitle: "Save", defaultValue: recipe.description, placeholder: nil, handler: { (item, text) in
					item.manager?.dismissBulletin()
					
					self.recipe.description = text!
					self.captureSnapshot(broadcast: false)
				})
				
				break
			case .ingredients:
				let ingredient = self.recipe.ingredients[indexPath.row]
				
				item = BulletinFactory.makeTextFieldPage(title: "Modify Ingredient", brief: "Adjust quantity, preparation method, etc. and aji will pick everything out automatically", buttonTitle: "Save", defaultValue: ingredient.originalString, placeholder: "1 tsp of salt", handler: { (item, text) in
					item.manager?.dismissBulletin()
					
					guard let text = text else {
						return
					}
					
					self.recipe.ingredients[indexPath.row] = RecipeParser.sharedInstance.parseIngredient(ingredientString: text, index: indexPath.row)
					
					self.captureSnapshot(broadcast: false)
				}) as TextFieldBulletinPage
				
				item.alternativeButtonTitle = "Remove"
				
				item.alternativeHandler = { (item) in
					item.manager?.dismissBulletin()
					self.recipe.ingredients.remove(at: indexPath.row)
					self.captureSnapshot(broadcast: false)
				}
				
				break
			case .steps:
				let instruction = self.recipe.instructions[indexPath.row]
				
				item = BulletinFactory.makeTextFieldPage(title: "Modify Step", brief: "Tweak instructions, add extra information, etc. and aji will detect any timings and ingredients automatically", buttonTitle: "Save", defaultValue: instruction, placeholder: "Add butter to pan and baste", handler: { (item, text) in
					item.manager?.dismissBulletin()
					
					self.recipe.instructions[indexPath.row] = text!
					
					self.captureSnapshot(broadcast: false)
				}) as TextFieldBulletinPage
				
				item.alternativeButtonTitle = "Remove"
				
				item.alternativeHandler = { (item) in
					item.manager?.dismissBulletin()
					self.recipe.instructions.remove(at: indexPath.row)
					self.captureSnapshot(broadcast: false)
				}
				
				break
		}
		
		bulletinManager = BLTNItemManager(rootItem: item)
		
		bulletinManager?.showBulletin(above: self)
	}
}

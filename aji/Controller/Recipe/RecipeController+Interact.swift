//
//  RecipeController+edit.swift
//  aji
//
//  Created by aco on 28/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

import SafariServices

import SwiftNotificationCenter

extension RecipeController {

	@objc internal func didTouchUpInsideServingSupplementaryButton() {
		let item = BulletinFactory.makeStepperPage(yield: self.recipe.yield, yieldDescription: self.recipe.yieldDescription) { (yield) in
			self.recipe.adjustYield(to: yield)
			self.captureSnapshot(broadcast: false, animatingDifferences: false)
		}
		
		bulletinManager = BLTNItemManager(rootItem: item)
		bulletinManager?.showBulletin(above: self)
	}
	
	internal func presentSafariViewController(urlString: String) {
		guard let url = URL(string: urlString) else {
			return
		}
		
		let safariController = SFSafariViewController(url: url)
		
		safariController.preferredControlTintColor = Style.Colors.primaryGreen
		safariController.dismissButtonStyle = .cancel
		
		self.present(safariController, animated: true, completion: nil)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		modifyRecipeStage(indexPath: indexPath)
	}
	
	@objc internal func didTouchUpInsideBookmarkBarButton(_ sender: UIButton) {
		let favorited = DataManager.sharedInstance.favorited(id: recipe.id)

		sender.setImage(UIImage(systemName: favorited ? "heart" : "heart.fill"), for: .normal)
		
		if !favorited {
			self.navigationController?.view.makeToast("Added to favorites")
			
			sender.layer.add(Animator.shared.bounce, forKey: "anim")
		} else {
			self.navigationController?.view.hideAllToasts()
		}
		
		DataManager.sharedInstance.toggleFavorite(id: recipe.id, favorite: favorited)
	}
	
	@objc internal func didTouchUpInsideNewIngredientButton() {
		guard Constant.purchased else {
			presentUpgradeBulletin()
			return
		}
		
		self.bulletinManager = BLTNItemManager(rootItem: BulletinFactory.makeTextFieldPage(title: "New Ingredient", brief: "Add a new ingredient (if there is a quantity/volume, scale it to make \(self.recipe.yield))", buttonTitle: "Add", defaultValue: nil, placeholder: "200 grams of sugar", handler: { (page, text) in
			page.manager?.dismissBulletin()
			
			guard let text = text else {
				return
			}
			
			let ingredient = RecipeParser.sharedInstance.parseIngredient(ingredientString: text, index: self.recipe.ingredients.count + 1)
			
			self.recipe.ingredients.append(ingredient)
			self.captureSnapshot(broadcast: true, animatingDifferences: true)
		}))
		
		self.bulletinManager?.showBulletin(above: self)
	}
	
	@objc internal func didTouchUpInsideNewInstructionButton() {
		guard Constant.purchased else {
			presentUpgradeBulletin()
			return
		}
		
		self.bulletinManager = BLTNItemManager(rootItem: BulletinFactory.makeTextFieldPage(title: "New Instruction", brief: "Add a new instruction", buttonTitle: "Add", defaultValue: nil, placeholder: "Beat in egges one by one, being careful not to overmix the batter", handler: { (page, text) in
			page.manager?.dismissBulletin()
			
			guard let text = text else {
				return
			}
			
			self.recipe.instructions.append(text)
			self.captureSnapshot(broadcast: true, animatingDifferences: true)
		}))
		
		self.bulletinManager?.showBulletin(above: self)
	}
	
	private func presentUpgradeBulletin() {
		self.bulletinManager = BLTNItemManager(rootItem: UpgradeBulletin(description: "Adding to a recipe is an aji Pro! feature."))
		self.bulletinManager?.showBulletin(above: self)
	}
	
//	@objc internal func didTouchUpInsideShareBarButton(_ sender: UIButton) {
//		guard let urlString = self.recipe.urlString, let url = URL(string: urlString) else {
//			return
//		}
//
//		let safariViewController = SFSafariViewController(url: url)
//
//		safariViewController.configuration.barCollapsingEnabled = true
//		safariViewController.preferredControlTintColor = Style.Colors.primaryGreen
//
//		self.present(safariViewController, animated: true, completion: nil)
//	}
}

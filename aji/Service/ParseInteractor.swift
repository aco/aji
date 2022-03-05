//
//  ParseInteractor.swift
//  aji
//
//  Created by aco on 07/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

import SwiftNotificationCenter

class ParseInteractor {
	
	internal var activeViewController: UIViewController
	internal let circleTabBarController: CircleTabBarController
	
	internal var manager = BLTNItemManager(rootItem: BLTNItem())
	internal var urlString: String
	
	init(activeViewController: UIViewController, circleTabBarController: CircleTabBarController) {
		self.activeViewController = activeViewController
		self.circleTabBarController = circleTabBarController
		
		self.urlString = ""
	}
	
	internal func presentRecipeController(recipe: Recipe, image: UIImage?) {
		self.activeViewController = self.circleTabBarController.selectedViewController!
		self.circleTabBarController.toggleActivityIndicator(animating: false)
		
		let recipeController = RecipeController(recipe: recipe, image: image)
		
		recipeController.hidesBottomBarWhenPushed = true
		recipeController.navigationController?.hidesBottomBarWhenPushed = true
		
		(activeViewController as! UINavigationController).pushViewController(recipeController, animated: true)
		
		if !recipe.ingredients.allSatisfy({$0.quantity != nil && $0.unit != nil}) {
			activeViewController.view.makeToast("Couldn't parse every ingredient", duration: TimeInterval(5), position: .top, title: nil, image: nil, style: ToastManager.shared.style, completion: nil)
		}
		
		DataManager.sharedInstance.append(recipe: recipe, to: .recent)
	}
	
	internal func presentURLBulletin() {
		activeViewController.hidesBottomBarWhenPushed = false
		let page = BulletinFactory.makeURLTextFieldPage(title: "Import Recipe", brief: "Enter the link to the recipe and aji will try to save it", buttonTitle: "Start", defaultValue: nil, placeholder: "https://", handler: { (item, urlString) in
			guard let urlString = urlString, let url = URL(string: urlString) else {
				return
			}

			self.urlString = urlString

			self.circleTabBarController.toggleActivityIndicator(animating: true)
			item.manager?.dismissBulletin()

			let ec = ExtractionController(url: url)
//			(self.activeViewController as! UINavigationController).pushViewController(ec, animated: true)

			ec.didCompleteWithRecipe = self.presentRecipeController

			ec.didFail = {
				self.circleTabBarController.toggleActivityIndicator(animating: false)
				self.presentUnsuccessfulNoticeBulletin()
			}
		})

		self.manager = BLTNItemManager(rootItem: page)

		manager.showBulletin(above: activeViewController, animated: true) {
			page.textField.becomeFirstResponder()
		}
	}

	internal func presentUnsuccessfulNoticeBulletin() {
		let failInformationBulletin = BulletinFactory.makeNoticePage(title: "Unsuccessful", brief: "No recipe could be found on this page. Would you like to request it be supported?", buttonTitle: "Request") { (item) in
			item.manager?.dismissBulletin()
			self.presentEmailRequestController(urlString: self.urlString)
		}
		
		self.manager = BLTNItemManager(rootItem: failInformationBulletin)
		self.manager.showBulletin(above: self.activeViewController)
	}
	
	internal func presentEmailRequestController(urlString: String) {
		let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
		
		SendEmailViewController.sharedInstance.sendEmail(from: activeViewController, body: "Attempting to add recipe: \(urlString) from aji iOS version \(version).")
	}
}

//
//  RecipeCollectionController.swift
//  aji
//
//  Created by aco on 02/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

import SwiftNotificationCenter

class RecipeCollectionController: BaseRecipeCollectionController {
	
	internal let database: Database
	internal var systemIconImageEmpty: (String, String)? = nil
	
	internal let statusBarMask = Factory.generateStatusBarMask()
	
	init(database: Database) {
		self.database = database
		
		super.init(nibName: nil, bundle: nil)
		
		self.view.addSubview(statusBarMask)
		
		NSLayoutConstraint.activate([
			statusBarMask.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			statusBarMask.widthAnchor.constraint(equalTo: self.view.widthAnchor),
			statusBarMask.topAnchor.constraint(equalTo: self.view.topAnchor),
			statusBarMask.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
		])
		
		self.refreshFeed(animatingDiffernces: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Broadcaster.register(UpdateRecipes.self, observer: self)
	}
	
	internal func refreshFeed(animatingDiffernces: Bool) {
		self.collections = DataManager.sharedInstance.recipes(from: self.database)
		
		if let product = Constant.proProduct, !Constant.purchased, self.collections.count > 0 {
			if Constant.isiPad {
				self.collections.append(product)
			} else {
				self.collections.insert(product, at: 0)
			}
		}
		
		self.createAndApplySnapshot(animatingDifferences: animatingDiffernces)
	}
	
	override func presentRecipe(at indexPath: IndexPath) {
		self.tabmanParent?.hidesBottomBarWhenPushed = true
		
		super.presentRecipe(at: indexPath)
		
		self.tabmanParent?.hidesBottomBarWhenPushed = false
	}
	
	override func childrenForContextMenu(_ collectionView: UICollectionView, at indexPath: IndexPath) -> [UIMenuElement]? {
		guard var children = super.childrenForContextMenu(collectionView, at: indexPath) else {
			return nil
		}
		
		guard self.database != .favorites,
			let recipe = self.collections[indexPath.row] as? Recipe,
			DataManager.sharedInstance.recipe(id: recipe.id, in: self.database) else {
			return children
		}
		
		children.append(UIAction(title: "Remove from \(self.database.description.capitalized)",
														 image: UIImage(systemName: "trash"), identifier: nil) {_ in
			DataManager.sharedInstance.remove(recipe: recipe, from: self.database, broadcast: true)
		})
		
		return children
	}
	
	override func emptyInformationView() -> UIView {
		guard let systemIconImageEmpty = self.systemIconImageEmpty else {
			return super.emptyInformationView()
		}
		
		return EmptyInformationView(subtitle: systemIconImageEmpty.1, icon: systemIconImageEmpty.0)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tabmanParent?.hidesBottomBarWhenPushed = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension RecipeCollectionController: UpdateRecipes {
	
	func iapChanged() {
		refreshFeed(animatingDiffernces: true)
	}
	
	func recipeChanged(recipeId: String) {
		self.refreshFeed(animatingDiffernces: false)
	}
	
	func updateFromDatabase(database: Database) {
		refreshFeed(animatingDiffernces: true)
	}
}

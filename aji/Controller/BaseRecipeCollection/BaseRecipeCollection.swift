//
//  RecipeController.swift
//  aji
//
//  Created by aco on 28/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

import PINRemoteImage

class BaseRecipeCollectionController: UIViewController, UICollectionViewDelegate {
	
	internal var manager: BLTNItemManager? = nil
	
	internal lazy var collectionView = Factory.generateCollectionView(for: self.view, delegate: self, layout: self.makeCompositionalLayout())
	
	open var collections = Array<AnyHashable>()
	open var dataSource: UICollectionViewDiffableDataSource<String, AnyHashable>! = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureDataSource()
		createAndApplySnapshot(animatingDifferences: true)

		self.navigationItem.backBarButtonItem = Factory.generateBackBarButtonItem()
	}
	
	open func emptyInformationView() -> UIView {
		return EmptyInformationView(subtitle: "No recipes here", icon: "slash.circle")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		(self.tabBarController as? CircleTabBarController)?.setCircleViewVisibility(visible: true)
		self.navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		(self.tabBarController as? CircleTabBarController)?.setCircleViewVisibility(visible: false)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch self.collections[indexPath.row] {
			case is Recipe:
				self.presentRecipe(at: indexPath)
				break
			case is SKProduct:
				self.presentProductBulletin()
				break
			default:
				return
		}
	}
	
	internal func presentRecipe(at indexPath: IndexPath) {
		guard let recipe = self.collections[indexPath.row] as? Recipe else {
			return
		}
		
		let image = (collectionView.cellForItem(at: indexPath) as? LatestRecipeCell)?.imageView.image
		let recipeController = RecipeController(recipe: recipe, image: image)
		
		self.tabmanParent?.hidesBottomBarWhenPushed = true
		self.hidesBottomBarWhenPushed = true
		
		(self.tabBarController as? CircleTabBarController)?.setCircleViewVisibility(visible: false)
		
		self.navigationController?.pushViewController(recipeController, animated: true)
		
		self.hidesBottomBarWhenPushed = false
		self.tabmanParent?.hidesBottomBarWhenPushed = false
	}
	
	internal func childrenForContextMenu(_ collectionView: UICollectionView, at indexPath: IndexPath) -> [UIMenuElement]? {
		guard let recipe = self.collections[indexPath.row] as? Recipe else {
			return nil
		}
		
		let favorited = DataManager.sharedInstance.favorited(id: recipe.id)
		
		var cookbookItems = DataManager.sharedInstance.keys().filter({
			if case Database.cookbook = $0 {
				return true
			}
			
			return false
		}).map { (database) -> UIAction in
			let exists = DataManager.sharedInstance.recipe(id: recipe.id, in: database)
			
			return UIAction(title: database.description.capitalized, image: exists ? UIImage(systemName: "checkmark") : nil, identifier: nil) { (action) in
				if exists {
					DataManager.sharedInstance.remove(recipe: recipe, from: database, broadcast: true)
				} else {
					DataManager.sharedInstance.append(recipe: recipe, to: database, broadcast: true)
					self.navigationController?.view.makeToast("Added to \(database.description.capitalized)")
				}
			}
		}
		
		cookbookItems.append(UIAction(title: "New", image: UIImage(systemName: "plus"), identifier: nil) { (action) in
			self.presentNewCookbookBulletin(for: recipe)
		})
		
		let favoriteAction = UIAction(title: favorited ? "Unfavorite" : "Favorite", image: UIImage(systemName: favorited ? "heart.slash" : "heart"), identifier: nil) {_ in
			if !favorited {
				self.navigationController?.view.makeToast("Added to favorites")
			}
			
			DataManager.sharedInstance.toggleFavorite(id: recipe.id, favorite: favorited)
		}
		
		if !Constant.purchased {
			return [
				favoriteAction,
				UIAction(title: "Save to...", image: UIImage(systemName: "book.closed"), identifier: nil) {_ in
					self.manager = BLTNItemManager(rootItem: UpgradeBulletin(description: "Creating your own cookbooks is an aji Pro! feature."))
					self.manager?.showBulletin(above: self)
				}
			]
		}
		
		return [
			favoriteAction,
			UIMenu(title: "Save to...", image: UIImage(systemName: "book.closed"), identifier: nil, children: cookbookItems)
		]
	}
}

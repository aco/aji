//
//  LatestController+ContextMenu.swift
//  aji
//
//  Created by aco on 30/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

import SwiftNotificationCenter

extension BaseRecipeCollectionController {
	
	func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
		guard
			let indexPath = configuration.identifier as? NSIndexPath
		else {
			return
		}
		
		animator.addAnimations {
			self.presentRecipe(at: indexPath as IndexPath)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		guard let children = self.childrenForContextMenu(collectionView, at: indexPath) else {
			return nil
		}
		
		let menu = UIMenu(title: "", image: nil, identifier: nil, children: children)
		
		return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: { [weak self] () -> UIViewController? in
			guard let recipe = self?.collections[indexPath.row] as? Recipe else {
				return nil
			}
			
			return RecipeController(recipe: recipe, image: (collectionView.cellForItem(at: indexPath) as? LatestRecipeCell)?.imageView.image)
		}) { (suggestedActions) -> UIMenu? in
			return menu
		}
	}
}

//
//  RecipeController+Data.swift
//  aji
//
//  Created by aco on 27/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

import SwiftNotificationCenter

extension RecipeController {
	
	internal func configureDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: self.collectionView) {
			(collectionView: UICollectionView, indexPath: IndexPath, identifier: AnyHashable) -> UICollectionViewCell? in
			
			let cellIdent: String
			
			switch Section.allCases[indexPath.section] {
				case .name:
					cellIdent = RecipeTitleCell.reuseIdentifier
				case .author:
					cellIdent = RecipeAuthorCell.reuseIdentifier
				case .description:
					cellIdent = RecipeDescriptionCell.reuseIdentifier
				case .prep:
					cellIdent = RecipeTimingCell.reuseIdentifier
				case .ingredients:
					cellIdent = RecipeIngredientCell.reuseIdentifier
				case .steps:
					cellIdent = RecipeStepCell.reuseIdentifier
			}
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdent, for: indexPath) as! BaseRecipePresentableCell
			
			cell.process(recipe: self.recipe, indexPath: indexPath)
			
			return cell
		}

		dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
			switch kind {
				case RecipeController.titleElementKind:
					return self.generateTitleSupplementaryView(for: indexPath)
				case RecipeController.addFooterElementKind:
					return self.generateAddFooterSupplementaryView(for: indexPath)
				default:
					return nil
			}
		}
	}
	
	internal func captureSnapshot(broadcast: Bool, animatingDifferences: Bool = true) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
		
		snapshot.appendSections([.name])
		snapshot.appendItems([recipe.name])
		
		snapshot.appendSections([.author])
		snapshot.appendItems([recipe.author])
		
		snapshot.appendSections([.prep])
		snapshot.appendItems([recipe.cookTime + recipe.cookTime])
		
		snapshot.appendSections([.description])
		snapshot.appendItems([recipe.description])
		
		snapshot.appendSections([.ingredients(yield: self.recipe.yield)])
		snapshot.appendItems(recipe.ingredients)
		
		snapshot.appendSections([.steps])
		snapshot.appendItems(recipe.instructions)
		
		dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
		
		if broadcast {
			Broadcaster.notify(UpdateRecipes.self) {
				$0.recipeChanged(recipeId: self.recipe.id)
			}
		}
	}
}

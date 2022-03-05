//
//  RecipeController+Supplementary.swift
//  aji
//
//  Created by aco on 22/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

extension RecipeController {
	
	internal func generateTitleSupplementaryView(for indexPath: IndexPath) -> UICollectionReusableView? {
		let kind = RecipeController.titleElementKind
		
		switch Section.allCases[indexPath.section] {
			case .ingredients:
				guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: IngredientUnitSupplementaryView.reuseIdentifier, for: indexPath) as? IngredientUnitSupplementaryView else {
					return nil
				}
				
				let description: String
				
				if self.recipe.yield > 1 {
					description = self.recipe.yieldDescription.pluralized()
				} else {
					description = self.recipe.yieldDescription.singularized()
				}
				
				supplementaryView.actionButton.setTitle("\(self.recipe.yield) \(description)", for: .normal)
				supplementaryView.actionButton.addTarget(self, action: #selector(self.didTouchUpInsideServingSupplementaryButton), for: .touchUpInside)
				
				return supplementaryView
			case .steps:
				return self.generateReuseableTitleView(ofKind: kind, for: indexPath)
			default:
				return nil
		}
	}
	
	internal func generateAddFooterSupplementaryView(for indexPath: IndexPath) -> UICollectionReusableView? {
		let kind = RecipeController.addFooterElementKind
		
		guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CenterButtonSupplementary.reuseIdentifier, for: indexPath) as? CenterButtonSupplementary else {
			fatalError()
		}
		
		switch Section.allCases[indexPath.section] {
			case .ingredients:
				supplementaryView.button.setTitle("New ingredient", for: .normal)
				supplementaryView.button.addTarget(self, action: #selector(didTouchUpInsideNewIngredientButton), for: .touchUpInside)
				break
			case .steps:
				supplementaryView.button.setTitle("New instruction", for: .normal)
				supplementaryView.button.addTarget(self, action: #selector(didTouchUpInsideNewInstructionButton), for: .touchUpInside)
				break
			default:
				()
		}
		
		return supplementaryView
	}
	
	private func generateReuseableTitleView(ofKind: String, for indexPath: IndexPath) -> TitleSupplementaryView? {
		guard let titleView = collectionView.dequeueReusableSupplementaryView(
			ofKind: ofKind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as? TitleSupplementaryView else {
			return nil
		}
		
		switch Section.allCases[indexPath.section] {
			case .ingredients:
				return nil
			case .steps:
				titleView.titleLabel.text = "Instructions"
			default:
				()
		}
		
		return titleView
	}
}

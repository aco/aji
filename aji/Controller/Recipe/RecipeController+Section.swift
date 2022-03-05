//
//  RecipeController+Section.swift
//  aji
//
//  Created by aco on 27/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

extension RecipeController {
	
	internal func ingredientSection() -> NSCollectionLayoutSection {
		let section = CompositionalFactory.shared.listSection(backgroundDecoration: true)
		let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					 heightDimension: .estimated(44))
		
		let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: RecipeController.titleElementKind, alignment: .top)
		let addFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: RecipeController.addFooterElementKind, alignment: .bottom)

		section.boundarySupplementaryItems = [titleSupplementary, addFooter]
		
		section.interGroupSpacing = Constant.padding / 2
		section.contentInsets = NSDirectionalEdgeInsets(top: Constant.padding / 2, leading: 0,
																										bottom: 0, trailing: 0)
		return section
	}
	
	internal func stepSection() -> NSCollectionLayoutSection {
		let section = CompositionalFactory.shared.listSection(backgroundDecoration: true)
		let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					 heightDimension: .estimated(44))
		
		let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: RecipeController.titleElementKind, alignment: .top)
		let addFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: RecipeController.addFooterElementKind, alignment: .bottom)

		section.boundarySupplementaryItems = [titleSupplementary, addFooter]
		
		section.interGroupSpacing = Constant.padding
		section.contentInsets = NSDirectionalEdgeInsets(top: Constant.padding, leading: 0,
																										bottom: 0, trailing: 0)
		return section
	}
	
	internal func registerCells() {
		collectionView.register(RecipeTitleCell.self, forCellWithReuseIdentifier: RecipeTitleCell.reuseIdentifier)
		collectionView.register(RecipeAuthorCell.self, forCellWithReuseIdentifier: RecipeAuthorCell.reuseIdentifier)
		collectionView.register(RecipeDescriptionCell.self, forCellWithReuseIdentifier: RecipeDescriptionCell.reuseIdentifier)
		collectionView.register(RecipeTimingCell.self, forCellWithReuseIdentifier: RecipeTimingCell.reuseIdentifier)
		collectionView.register(RecipeStepCell.self, forCellWithReuseIdentifier: RecipeStepCell.reuseIdentifier)
		collectionView.register(RecipeIngredientCell.self, forCellWithReuseIdentifier: RecipeIngredientCell.reuseIdentifier)
		
		collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: RecipeController.titleElementKind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
		collectionView.register(CenterButtonSupplementary.self, forSupplementaryViewOfKind: RecipeController.addFooterElementKind, withReuseIdentifier: CenterButtonSupplementary.reuseIdentifier)
		collectionView.register(IngredientUnitSupplementaryView.self, forSupplementaryViewOfKind: RecipeController.titleElementKind, withReuseIdentifier: IngredientUnitSupplementaryView.reuseIdentifier)
	}
}

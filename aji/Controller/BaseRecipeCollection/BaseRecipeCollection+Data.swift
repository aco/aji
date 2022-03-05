//
//  LatestController+Data.swift
//  aji
//
//  Created by aco on 29/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

import StoreKit

extension BaseRecipeCollectionController {
	
	internal func prepareRecipeCell(for indexPath: IndexPath, recipe: Recipe) -> BaseRecipePresentableCell {
		guard let cell = collectionView.dequeueReusableCell(
						withReuseIdentifier: LatestRecipeCell.reuseIdentifier,
						for: indexPath) as? LatestRecipeCell else { fatalError("Cannot create new cell") }
		
		cell.process(recipe: recipe, indexPath: indexPath)
		
		var height = Constant.trueScreenWidth - (Constant.padding * 2)
		
		if Constant.isiPad {
			height /= 2
		}
		
		cell.setImageHeightConstraints(heightConstant: height)
		
		return cell
	}
	
	internal func prepareProductCell(for indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductProCell.reuseIdentifier, for: indexPath) as? ProductProCell else {
			fatalError()
		}
		
		return cell
	}
	
	internal func configureDataSource() {
		collectionView.register(LatestRecipeCell.self, forCellWithReuseIdentifier: LatestRecipeCell.reuseIdentifier)
		collectionView.register(ProductProCell.self, forCellWithReuseIdentifier: ProductProCell.reuseIdentifier)
		
		dataSource = UICollectionViewDiffableDataSource<String, AnyHashable>(collectionView: collectionView) {
			(collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
			if let recipe = self.collections[indexPath.row] as? Recipe {
				return self.prepareRecipeCell(for: indexPath, recipe: recipe)
			} else if let product = self.collections[indexPath.row] as? SKProduct, product == Constant.proProduct {
				return self.prepareProductCell(for: indexPath)
			}
			
			return collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
		}
	}
	
	internal func createAndApplySnapshot(animatingDifferences: Bool) {
		if dataSource == nil {
			self.configureDataSource()
		}
		
		var snapshot = NSDiffableDataSourceSnapshot<String, AnyHashable>()
		
		snapshot.appendSections(["Whatever"])
		snapshot.appendItems(collections)
		
		dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
		
		DispatchQueue.main.async {
			self.collectionView.alwaysBounceVertical = !snapshot.itemIdentifiers.isEmpty
			
			if snapshot.itemIdentifiers.isEmpty {
				self.collectionView.backgroundView = self.emptyInformationView()
			} else {
				UIView.animate(withDuration: 0.2) {
					self.collectionView.backgroundView = nil
				}
			}
		}
	}
	
	internal func makeCompositionalLayout() -> UICollectionViewLayout {
		let columns: CGFloat = Constant.isiPad ? 2 : 1
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					heightDimension: .estimated(Constant.trueScreenWidth / columns))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					 heightDimension: .estimated(Constant.trueScreenWidth / columns))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: Int(columns))
		
		group.interItemSpacing = .fixed(Constant.padding)
		
		let section = NSCollectionLayoutSection(group: group)
		
		section.contentInsets = NSDirectionalEdgeInsets(top: Constant.padding, leading: Constant.padding, bottom: Constant.padding, trailing: Constant.padding)
		section.interGroupSpacing = Constant.padding
		
		let layout = UICollectionViewCompositionalLayout(section: section)
	
		return layout
	}
}

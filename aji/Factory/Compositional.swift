//
//  Compositional.swift
//  aji
//
//  Created by aco on 23/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class CompositionalFactory {
	
	public static let shared = CompositionalFactory()
	
	public func listSection(backgroundDecoration: Bool, shouldInset: Bool = true) -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					heightDimension: .estimated(150))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					 heightDimension: .estimated(150))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
																									 subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		
		if backgroundDecoration {
			section.decorationItems = [.background(elementKind: SectionBackgroundDecorationView.elementKind)]
		}
		
		if shouldInset {
			section.interGroupSpacing = Constant.padding
			section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: Constant.padding, trailing: 0)
		}
		
		return section
	}
	
	public func gridSection() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
																					heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					 heightDimension: .fractionalHeight(0.3))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
																									 subitem: item, count: 3)
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .continuous
		return section
	}
}

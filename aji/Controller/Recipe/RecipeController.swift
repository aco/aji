//
//  RecipeController.swift
//  aji
//
//  Created by aco on 23/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

import PINRemoteImage

class RecipeController: HeaderUICollectionViewController {
	
	internal static let titleElementKind = "titleElementKind"
	internal static let addFooterElementKind = "addFooterElementKind"
	
	enum Section: Hashable, CaseIterable {
		static var allCases: [RecipeController.Section] = [.name, .author, .prep, .description, .ingredients(yield: 0), .steps]
		
		typealias AllCases = [Section]
		
		case name
		case author
		case prep
		case description
		case ingredients(yield: Int)
		case steps
	}
	
	internal var recipe: Recipe
	internal var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
	
	internal var bulletinManager: BLTNItemManager? = nil
	
	init(recipe: Recipe, image: UIImage?) {
		self.recipe = recipe
		
		super.init(image: image)
		
		let favorited = DataManager.sharedInstance.favorited(id: recipe.id)
		
		navigationItem.rightBarButtonItems = [
			Factory.generateBarButtonItemCustomView(systemImage: favorited ? "heart.fill" : "heart", selector: #selector(didTouchUpInsideBookmarkBarButton(_:)), target: self)
		]
		
		navigationItem.backBarButtonItem = Factory.generateBackBarButtonItem()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		registerCells()
		configureScrollViewHierarchy()
		configureDataSource()
		
		captureSnapshot(broadcast: false, animatingDifferences: false)
		
		self.hidesBottomBarWhenPushed = true
		
		self.stretchyHeaderView.navigationUnderlayGradientView.configureNavigationBackground()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.hidesBarsOnSwipe = false
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	override func makeCompositionalLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
			switch Section.allCases[sectionNumber] {
				case .name:
					let section =  CompositionalFactory.shared.listSection(backgroundDecoration: false, shouldInset: false)
					
					section.decorationItems = [
						.background(elementKind: RoundedSectionBackgroundDecorationView.elementKind)
					]
					
					return section
				case .author:
					return CompositionalFactory.shared.listSection(backgroundDecoration: true, shouldInset: true)
				case .description:
					return CompositionalFactory.shared.listSection(backgroundDecoration: true, shouldInset: true)
				case .prep:
					return CompositionalFactory.shared.listSection(backgroundDecoration: true, shouldInset: true)
				case .ingredients:
					return self.ingredientSection()
				case .steps:
					return self.stepSection()
			}
		}
		
		layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.elementKind)
		layout.register(RoundedSectionBackgroundDecorationView.self, forDecorationViewOfKind: RoundedSectionBackgroundDecorationView.elementKind)
		
		return layout
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

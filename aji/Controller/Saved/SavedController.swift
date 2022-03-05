//
//  SavedController.swift
//  aji
//
//  Created by aco on 30/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

import Pageboy
import Tabman
import SwiftNotificationCenter

class SavedController: TabmanViewController {
	
	typealias CircularIndicatorBar = TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMDotBarIndicator>
	
	internal var viewControllers = [RecipeCollectionController]()
	internal var collections: [Database] = []
	
	internal var systemIconImageEmpty: [Database : (String, String)] = [
		.recent : ("clock", "No recipes here - add some now!")
	]
	
	internal let bar = CircularIndicatorBar()
	internal let statusBarMask = Factory.generateStatusBarMask()
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		Broadcaster.register(UpdateCookbooks.self, observer: self)
		
		for collection in DataManager.sharedInstance.keys().sorted(by: {$0.description > $1.description}) {
			guard collection != .recent else {
				continue
			}
			
			if !self.collections.contains(collection) {
				self.collections.append(collection)
			}
		}
		
		for collection in collections {
			let controller = RecipeCollectionController(database: collection)
			
			controller.collections = DataManager.sharedInstance.recipes(from: collection)
			controller.systemIconImageEmpty = self.systemIconImageEmpty[collection]
			
			controller.createAndApplySnapshot(animatingDifferences: true)
			
			self.viewControllers.append(controller)
		}
		
		self.dataSource = self
		
		self.view.backgroundColor = Style.Colors.mainBackground
		self.navigationItem.backBarButtonItem = Factory.generateBackBarButtonItem()
		
		self.view.addSubview(statusBarMask)
		
		NSLayoutConstraint.activate([
			statusBarMask.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			statusBarMask.widthAnchor.constraint(equalTo: self.view.widthAnchor),
			statusBarMask.topAnchor.constraint(equalTo: self.view.topAnchor),
			statusBarMask.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
		])
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		addBar(bar, dataSource: self, at: .top)
		
		configureTabBarAppearance(bar: bar)
		adjustTabScrollContentMode()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		(self.tabBarController as? CircleTabBarController)?.setCircleViewVisibility(visible: true)
		self.navigationController?.setNavigationBarHidden(true, animated: true)
		
		self.hidesBottomBarWhenPushed = false
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		(self.tabBarController as? CircleTabBarController)?.setCircleViewVisibility(visible: false)
		self.hidesBottomBarWhenPushed = false
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		adjustTabScrollContentMode()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

//
//  SceneDelegate.swift
//  aji
//
//  Created by aco on 17/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	
	internal let tabBarController = CircleTabBarController()
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		guard let scene = (scene as? UIWindowScene) else {
			return
		}
		
		configureTabBarController()
		
		self.window = UIWindow(windowScene: scene)
		
		tabBarController.viewControllers = [
			generateNavigationForController(viewController: RecipeCollectionController(database: .recent), tabImageName: "clock", title: "Recent"),
			generateNavigationForController(viewController: UIViewController(), tabImageName: "plus", title: nil),
			generateNavigationForController(viewController: SavedController(), tabImageName: "book.closed", title: "Collections")
		]
		
		self.window?.rootViewController = tabBarController
		
		self.window?.makeKeyAndVisible()
	}
	
	private func configureTabBarController() {
		tabBarController.hidesBottomBarWhenPushed = true
		tabBarController.circleTintColorForNormal = Style.Colors.secondaryText
		tabBarController.tabBar.backgroundColor = Style.Colors.mainBackground
		
		tabBarController.circleButtonCustomAction = { _ in
			guard let selectedViewController = self.tabBarController.selectedViewController else {
				return
			}
			
			let parseInteractor = ParseInteractor(activeViewController: selectedViewController, circleTabBarController: self.tabBarController)
			
			parseInteractor.presentURLBulletin()
		}
		
		tabBarController.tabBar.tintColor = Style.Colors.primaryGreen
		tabBarController.tabBar.backgroundColor = Style.Colors.mainBackground

	}
	
	private func generateNavigationForController(viewController: UIViewController, tabImageName: String, title: String?) -> UINavigationController {
		let navigationController = UINavigationController(rootViewController: viewController)

		viewController.navigationItem.title = title
		navigationController.tabBarItem = Factory.generateTabBarItem(title: title, tabImageName: tabImageName)
		
		return navigationController
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
		
		DataManager.sharedInstance.persistToDisk()
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
		if self.tabBarController.entered {
			self.tabBarController.setCircleViewVisibility(visible: true)
		}
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
		if self.tabBarController.entered {
			self.tabBarController.setCircleViewVisibility(visible: true)
		}
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
		if self.tabBarController.entered {
			self.tabBarController.setCircleViewVisibility(visible: true)
		}
		
		DataManager.sharedInstance.persistToDisk()
	}
}

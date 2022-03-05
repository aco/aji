//
//  RecipeBroadcast.swift
//  aji
//
//  Created by aco on 09/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation

protocol UpdateRecipes: AnyObject {

	func recipeChanged(recipeId: String)
	func updateFromDatabase(database: Database)
	
	func iapChanged()
}

protocol UpdateCookbooks {
	
	func cookbookChanged(database: Database)
}

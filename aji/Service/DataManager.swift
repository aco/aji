//
//  DataManager.swift
//  aji
//
//  Created by aco on 03/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation

import Disk
import SwiftNotificationCenter

class DataManager {

	private(set) var bank = [String: Recipe]()
	private(set) var collections = [Database : Set<String>]()
	
	class var sharedInstance: DataManager {
		struct Singleton {
			static let instance = DataManager()
		}
		
		return Singleton.instance
	}
	
	init() {
		self.initFromDisk()
	}
	
	internal func keys() -> [Database] {
		return Array(self.collections.keys)
	}
	
	internal func recipes(from database: Database) -> [Recipe] {
		guard let ids = self.collections[database] else {
			return []
		}
		
		var recipes = [Recipe]()
		
		for id in ids {
			if let recipe = self.bank[id] {
				recipes.append(recipe)
			}
		}
		
		return recipes.sorted(by: {$0.timestamp > $1.timestamp})
	}
	
	internal func append(recipe: Recipe, to database: Database, broadcast: Bool = true) {
		self.collections[database, default: []].insert(recipe.id)
		self.bank[recipe.id] = recipe
		
		if broadcast {
			Broadcaster.notify(UpdateRecipes.self) {
				$0.updateFromDatabase(database: database)
			}
		}
		
		Broadcaster.notify(UpdateCookbooks.self) {
			$0.cookbookChanged(database: database)
		}
	}
	
	internal func remove(recipe: Recipe, from database: Database, broadcast: Bool) {
		self.collections[database]?.remove(recipe.id)
		
		if self.collections.allSatisfy({ (k, v) -> Bool in
			return !v.contains(recipe.id)
		}) {
			self.bank.removeValue(forKey: recipe.id)
		}
		
		if broadcast {
			Broadcaster.notify(UpdateRecipes.self) {
				$0.updateFromDatabase(database: database)
			}
		}
		
		if self.collections[database, default: []].count < 1 {
			self.collections.removeValue(forKey: database)
			
			Broadcaster.notify(UpdateCookbooks.self) {
			 $0.cookbookChanged(database: database)
		 }
		}
	}
	
	internal func favorited(id: String) -> Bool {
		return self.recipe(id: id, in: .favorites)
	}
	
	internal func toggleFavorite(id: String, favorite: Bool) {
		if favorite {
			self.collections[.favorites]!.remove(id)
		} else {
			self.collections[.favorites]!.insert(id)
		}
		
		Broadcaster.notify(UpdateRecipes.self) {
			$0.updateFromDatabase(database: .favorites)
		}
	}
	
	internal func recipe(id: String, in database: Database) -> Bool {
		return self.collections[database]?.contains(id) ?? false
	}
	
	internal func recipe(from id: String) -> Recipe? {
		return self.bank[id]
	}
	
}

extension DataManager {

	private func initFromDisk() {
		if let bank = try? Disk.retrieve("recipes", from: .applicationSupport, as: [String: Recipe].self) {
			self.bank = bank
		}
		
		if let collections = try? Disk.retrieve("org", from: .applicationSupport, as: [Database : Set<String>].self) {
			self.collections = collections
		} else {
			for database in Database.allCases {
				self.collections[database] = Set<String>()
			}
		}
	}
	
	internal func persistToDisk() {
		try! Disk.save(self.collections, to: .applicationSupport, as: "org")
		try! Disk.save(self.bank, to: .applicationSupport, as: "recipes")
	}
}

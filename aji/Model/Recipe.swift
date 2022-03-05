//
//  Recipe.swift
//  aji
//
//  Created by aco on 20/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class Recipe: Codable, Hashable {
	
	public let id: String
	public let timestamp: Double
	public var name: String = ""
	public var imageUrl: String? = nil
	
	public var description: String? = nil
	public var author: String? = nil
	
	public var yield: Int = 1
	public var yieldDescription: String
	
	public var categories: [String]? = nil
	public var cuisines: [String]? = nil
	
	public var urlString: String? = nil
	
	public var prepTime: Int = 0
	public var cookTime: Int = 0
	
	public var ingredients = [Ingredient]()
	public var instructions = [String]()
	
	internal func adjustYield(to yield: Int) {
		
		for (index, ingredient) in self.ingredients.enumerated() {
			if let quantity = ingredient.quantity as? Double {
				self.ingredients[index].quantity = Double(quantity / Double(self.yield)) * Double(yield)
			}
		}
		
		self.yield = yield
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.id = try container.decode(String.self, forKey: .id)
		self.timestamp = try container.decode(Double.self, forKey: .timestamp)
		self.name = try container.decode(String.self, forKey: .name)
		self.imageUrl = try? container.decode(String.self, forKey: .imageUrl)
		self.description = try? container.decode(String.self, forKey: .description)
		self.author = try? container.decode(String.self, forKey: .author)
		self.yield = try container.decode(Int.self, forKey: .yield)
		self.yieldDescription = try container.decode(String.self, forKey: .yieldDescription)
		self.urlString = try? container.decode(String.self, forKey: .urlString)
		self.ingredients = try container.decode([Ingredient].self, forKey: .ingredients)
		self.instructions = try container.decode([String].self, forKey: .instructions)
		self.prepTime = try container.decode(Int.self, forKey: .prepTime)
		self.cookTime = try container.decode(Int.self, forKey: .cookTime)
	}
	
	init(id: String, from dict: Dictionary<String, Any>, image: UIImage?) {
		self.id = id
		self.timestamp = Date().timeIntervalSince1970
		
		self.name = dict["name"] as? String ?? "Untitled Recipe"
		self.description = dict["description"] as? String
		self.yieldDescription = "serving"
		
		self.imageUrl = dict["imageUrl"] as? String
		self.author = dict["author"] as? String
		
		if let yield = dict["recipeYield"] as? String ?? dict["yield"] as? String, let regex = try? NSRegularExpression(pattern: "Serves|serves|between|from|around|to|\\d+ ?-", options: .caseInsensitive) {
			var modString = regex.stringByReplacingMatches(in: yield, options: [], range: NSRange(yield.startIndex..., in: yield), withTemplate: "")
			let stringArray = modString.components(separatedBy: CharacterSet.decimalDigits.inverted)
			
			for item in stringArray {
				if let number = Int(item) {
					self.yield = number
				}
			}

			modString = modString.replacingOccurrences(of: String(self.yield), with: "").trimmingCharacters(in: .whitespacesAndNewlines)
			
			if modString.count > 1 {
				self.yieldDescription = modString
			}
		}
		
		if let urlString = dict["urlString"] as? String {
			self.urlString = urlString
		}
		
		if let cuisine = dict["cuisine"] as? String {
			self.cuisines = [cuisine]
		} else if let cuisines = dict["cuisine"] as? [String] {
			self.cuisines = cuisines
		}
		
		if let category = dict["categories"] as? String {
			self.categories = [category]
		} else if let categories = dict["categories"] as? [String] {
			self.categories = categories
		}
		
		if let prepTime = dict["prepTime"] as? String, let components = DateComponents.durationFrom8601String(prepTime) {
			self.prepTime = (components.hour ?? 0) * 60
			self.prepTime += (components.minute ?? 0)
		}
		
		if let cookTime = dict["cookTime"] as? String, let components = DateComponents.durationFrom8601String(cookTime) {
			self.cookTime = (components.hour ?? 0) * 60
			self.cookTime += (components.minute ?? 0)
		}
	
		if let ingredients = dict["recipeIngredient"] as? [String] {
			self.ingredients = RecipeParser.sharedInstance.parseIngredients(ingredients: ingredients)
		}
		
		self.instructions = dict["recipeInstructions"] as? [String] ?? []
	}
	
	init(id: String) {
		self.id = id
		self.timestamp = Date().timeIntervalSince1970
		self.name = "asdasd"
		self.description = "i9rtueiogj dfklgj  ddsfadsf ftg8erhtguior"
//		self.image = nil
		self.author = "eee"
		self.ingredients = [Ingredient(id: "1222", originalString: "1 gram whatever sliced", name: "whatever", unit: "gram", quantity: 1.0, preparationComment: "sliced")]
		self.instructions = ["i9rtueiogj dfklgj  ddsfadsf ftg8erhtguiori9rtueiogj dfklgj  ddsfadsf ftg8erhtguior"]
		self.prepTime = 40
		self.cookTime = 5
		self.yieldDescription = "serving"
	}
}

extension Recipe {
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
		hasher.combine(self.name)
		hasher.combine(self.author)
		hasher.combine(self.prepTime)
		hasher.combine(self.cookTime)
		hasher.combine(self.ingredients)
		hasher.combine(self.instructions)
		hasher.combine(self.yield)
	}
	
	static func == (lhs: Recipe, rhs: Recipe) -> Bool {
		return lhs.id == rhs.id && lhs.name == rhs.name && lhs.cookTime + lhs.prepTime == rhs.cookTime + rhs.prepTime
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(self.id, forKey: .id)
		try container.encode(self.timestamp, forKey: .timestamp)
		try container.encode(name, forKey: .name)
		try container.encode(imageUrl, forKey: .imageUrl)
		try? container.encode(description, forKey: .description)
		try? container.encode(author, forKey: .author)
		try container.encode(yield, forKey: .yield)
		try? container.encode(yieldDescription, forKey: .yieldDescription)
		try? container.encode(urlString, forKey: .urlString)
		try container.encode(ingredients, forKey: .ingredients)
		try container.encode(instructions, forKey: .instructions)
		try container.encode(prepTime, forKey: .prepTime)
		try container.encode(cookTime, forKey: .cookTime)
//		try container.encode(image, forKey: .image)
	}
	
	enum CodingKeys: String, CodingKey {
		case id,
				 timestamp,
				 name,
				 imageUrl,
				 image,
				 description,
				 author,
				 yield,
				 yieldDescription,
				 categories,
				 cuisines,
				 urlString,
				 prepTime,
				 cookTime,
				 ingredients,
				 instructions
//				 renderedImage
	}
}

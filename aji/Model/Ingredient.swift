//
//  Ingredient.swift
//  aji
//
//  Created by aco on 21/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation

public struct Ingredient: Codable, Hashable {
	
	public let id: String
	public var originalString: String
	
	public var name: String
	public var unit: String?
	public var quantity: Any?
	public var preparationComment: String?
	
	init(id: String, originalString: String, name: String, unit: String?, quantity: Any?, preparationComment: String?) {
		self.id = id
		self.originalString = originalString.trimmingCharacters(in: .whitespacesAndNewlines)
		
		self.name = name
		self.unit = unit
		
		if let quantity = quantity as? String {
			if let q = Double(quantity) {
				self.quantity = q
			} else if let q = Int(quantity) {
				self.quantity = q
			} else {
				self.quantity = quantity
			}
		} else {
			self.quantity = quantity
		}
		
		if preparationComment != self.name {
			self.preparationComment = preparationComment
		}
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.id = try container.decode(String.self, forKey: .id)
		self.originalString = try container.decode(String.self, forKey: .originalString)
		
		self.name = try container.decode(String.self, forKey: .name)
		self.unit = try container.decodeIfPresent(String.self, forKey: .unit)
		self.preparationComment = try container.decodeIfPresent(String.self, forKey: .preparationComment)
		
		if let storedQuantity = try container.decodeIfPresent(String?.self, forKey: .quantity), storedQuantity != nil {
			if let quantity = Double(storedQuantity!) {
				self.quantity = quantity
			} else if let quantity = Int(storedQuantity!) {
				self.quantity = quantity
			} else {
				self.quantity = storedQuantity!
			}
		}
	}
	
	public func recognised() -> Bool {
		return true
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(self.id, forKey: .id)
		try container.encode(self.originalString, forKey: .originalString)
		try container.encode(self.name, forKey: .name)
		try container.encode(self.unit, forKey: .unit)
		try container.encode(self.preparationComment, forKey: .preparationComment)
		
		if let quantity = self.quantity {
			try container.encode(String(describing: quantity), forKey: .quantity)
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case id
		case originalString
		case name
		case unit
		case quantity
		case preparationComment
	}
	
	public static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
		let qtyEqual = isEqual(type: Double.self, a: lhs.quantity, b: rhs.quantity) || isEqual(type: String.self, a: lhs.quantity, b: rhs.quantity) || isEqual(type: String.self, a: lhs.quantity, b: rhs.quantity)
		
		return lhs.id == rhs.id && qtyEqual && lhs.unit == rhs.unit
	}
	
	static func isEqual<T: Equatable>(type: T.Type, a: Any?, b: Any?) -> Bool {
			guard let a = a as? T, let b = b as? T else { return false }

			return a == b
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
		hasher.combine(self.name)
		hasher.combine(self.unit)
		hasher.combine(self.preparationComment)
		
		if let quantity = quantity as? Double {
			hasher.combine(quantity)
		} else if let quantity = quantity as? String {
			hasher.combine(quantity)
		} else if let quantity = quantity as? Int {
			hasher.combine(quantity)
		}
	}
}

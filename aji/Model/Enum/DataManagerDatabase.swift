//
//  DataManagerDatabase.swift
//  aji
//
//  Created by aco on 21/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation

enum Database: Hashable {
	
	case feed
	case recent
	case favorites
	case cookbook(name: String)
}

extension Database: Codable {
	
	enum Key: CodingKey {
		case rawValue
		case associatedValue
	}
	
	enum CodingError: Error {
		case unknownValue
	}
	
	var description: String {
		get {
			if case let .cookbook(str) = self {
				return str
			} else {
				return String(describing: self)
			}
		}
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: Key.self)
		let rawValue = try container.decode(Int.self, forKey: .rawValue)
		
		switch rawValue {
			case 0:
				self = .feed
			case 1:
				self = .recent
			case 2:
				self = .favorites
			case 3:
				let name = try container.decode(String.self, forKey: .associatedValue)
				self = .cookbook(name: name)
			default:
				throw CodingError.unknownValue
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: Key.self)
		
		switch self {
			case .feed:
				try container.encode(0, forKey: .rawValue)
			case .recent:
				try container.encode(1, forKey: .rawValue)
			case .favorites:
				try container.encode(2, forKey: .rawValue)
			case .cookbook(let name):
				try container.encode(3, forKey: .rawValue)
				try container.encode(name, forKey: .associatedValue)
		}
	}
}

extension Database: CaseIterable {
	
	typealias AllCases = [Database]
	
	static var allCases: AllCases {
		get {
			return [.recent, .favorites]
		}
	}
}

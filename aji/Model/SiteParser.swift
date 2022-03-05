//
//  SiteSpecification.swift
//  aji
//
//  Created by aco on 21/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation

struct SiteParser: Codable {
	
	public let domain: String
	
	public let name: String
	public let author: String?
	public let yield: String?
	
	public let recipeIngredient: String
	public let recipeInstructions: String
	
	public let datePublished: String?
	public let description: String?
	public let imageUrl: String?
	
	public let categories: String?
	public let cuisines: String?
	
	public let prepTime: String?
	public let cookTime: String?
	
	public let updated: Double
}

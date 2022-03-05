//
//  HrecipeParser.swift
//  aji
//
//  Created by aco on 21/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import CoreML
import NaturalLanguage

extension String {

		func replace(_ pattern: String, options: NSRegularExpression.Options = [], collector: ([String]) -> String) -> String {
				guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
					return self
				}
			
				let matches = regex.matches(in: self,
																		options: NSRegularExpression.MatchingOptions(rawValue: 0), range:
																			NSMakeRange(0, (self as NSString).length))
			
				guard matches.count > 0 else {
					return self
				}
			
				var splitStart = startIndex
				
			return matches.map { (match) -> (String, [String]) in
						let range = Range(match.range, in: self)!
						let split = String(self[splitStart ..< range.lowerBound])
			
				splitStart = range.upperBound
				
				return (split, (0 ..< match.numberOfRanges)
								.compactMap { Range(match.range(at: $0), in: self) }
								.map { String(self[$0]) }
						)
				}.reduce("") {
					"\($0)\($1.0)\(collector($1.1))"
				} + self[Range(matches.last!.range, in: self)!.upperBound ..< endIndex]
		}
	
		func replace(_ regexPattern: String, options: NSRegularExpression.Options = [], collector: @escaping () -> String) -> String {
				return replace(regexPattern, options: options) { (_: [String]) in collector() }
		}
}

class RecipeParser {
	
	class var sharedInstance: RecipeParser {
		struct Singleton {
			static let instance = try! RecipeParser()
		}
		
		return Singleton.instance
	}
	
	internal let hrecipeBundle: String
	
	internal let scheme: NLTagScheme
	internal let tagger: NLTagger
	
	init() throws {
		if
			let filepath = Bundle.main.path(forResource: "hrecipe", ofType: "js"),
			let hrecipeBundle = try? String(contentsOfFile: filepath) {
			self.hrecipeBundle = hrecipeBundle
		} else {
			self.hrecipeBundle = ""
		}
		
		let modelURL = Bundle.main.url(forResource: "tagger", withExtension: "mlmodelc")
		
		self.scheme = NLTagScheme("scheme")
		self.tagger = NLTagger(tagSchemes: [scheme])
		
		self.tagger.setModels([try NLModel(contentsOf: modelURL!)], forTagScheme: scheme)
	}
	
	private func cleanItemArray(items: [String]?) -> String? {
		guard let items = items, items.count > 0 else {
			return nil
		}
		
		let borderPunctuation = ".,:;- "
		var corrected = items
		
		if borderPunctuation.contains(items.last!.last!) {
			_ = corrected.popLast()
		}
		
		var output = corrected.joined(separator: " ")
		
		if output.starts(with: ",") {
			output = output.replacingOccurrences(of: ",", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
		}
		
		output = output.replacingOccurrences(of: "( ", with: "(")
		output = output.replacingOccurrences(of: " )", with: ")")
		output = output.replacingOccurrences(of: " , ", with: ", ")
		output = output.replacingOccurrences(of: " - ", with: "-")
		output = output.replacingOccurrences(of: " %", with: "%")
		
		return output.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	public func parseIngredient(ingredientString: String, index: Int) -> Ingredient {
		let ing = ingredientString.replace(#".*?\d+\s?([A-Za-z]*g)(?!rams)"#, options: .caseInsensitive) { (strs) -> String in
			guard strs.count > 1 else {
				return strs.last ?? strs.first ?? ""
			}
			
			let unit: String
			
			switch strs[1] {
				case "g":
					unit = " grams"
				case "mg":
					unit = " milligrams"
				case "kg":
					unit = " kilograms"
				default:
					unit = strs[1]
			}
			
			return strs[0].replacingOccurrences(of: strs[1], with: unit)
		}
		var results = [String : [String]]()
		
		let cleanedIngredientInput = ing.replacingOccurrences(of: "<[^>]+>", with: "",
																													options: .regularExpression, range: nil)
			.replacingOccurrences(of: "[\\)\\(]", with: "", options: .regularExpression, range: nil)
		
		tagger.string = cleanedIngredientInput
		
		tagger.enumerateTags(in: cleanedIngredientInput.startIndex..<cleanedIngredientInput.endIndex,
												 unit: .word, scheme: self.scheme) { (tag, range) -> Bool in
			if tag != .whitespace {
				results[tag!.rawValue, default: []].append(String(cleanedIngredientInput[range]))
			}
			
			return true
		}
		
		let comments = results["COMMENT", default: []] + results["OTHER", default: []]
		
		if let name = cleanItemArray(items: results["NAME"]) {
			let quantity: Any? = cleanItemArray(items: results["QTY", default: []])
			
			return Ingredient(id: String(index), originalString: cleanedIngredientInput,
												name: name, unit: cleanItemArray(items: results["UNIT", default: []]),
												quantity: quantity, preparationComment: cleanItemArray(items: comments))
		} else {
			return Ingredient(id: String(index), originalString: cleanedIngredientInput,
												name: cleanedIngredientInput, unit: nil, quantity: nil, preparationComment: nil)
		}
	}
	
	public func parseIngredients(ingredients: [String]) -> [Ingredient] {
		var collected = [Ingredient]()
		
		for (index, ingredient) in ingredients.enumerated() {
			collected.append(self.parseIngredient(ingredientString: ingredient, index: index))
		}
		
		return collected
	}
}

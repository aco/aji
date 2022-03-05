//
//  DateComponents.swift
//  aji
//
//  Created by aco on 30/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation

public extension DateComponents {
	
		static func durationFrom8601String(_ durationString: String) -> DateComponents? {
				guard durationString.starts(with: "P") else {
						logErrorMessage(durationString: durationString)
						return nil
				}

				let durationString = String(durationString.dropFirst())
				var dateComponents = DateComponents()

				if durationString.contains("W") {
						let weekValues = componentsForString(durationString, designatorSet: CharacterSet(charactersIn: "W"))

						if let weekValue = weekValues["W"], let weekValueDouble = Double(weekValue) {
								// 7 day week specified in ISO 8601 standard
								dateComponents.day = Int(weekValueDouble * 7.0)
						}
						return dateComponents
				}

				let tRange = (durationString as NSString).range(of: "T", options: .literal)
				let periodString: String
				let timeString: String
				if tRange.location == NSNotFound {
						periodString = durationString
						timeString = ""
				} else {
						periodString = (durationString as NSString).substring(to: tRange.location)
						timeString = (durationString as NSString).substring(from: tRange.location + 1)
				}

				// DnMnYn
				let periodValues = componentsForString(periodString, designatorSet: CharacterSet(charactersIn: "YMD"))
				dateComponents.day = Int(periodValues["D"] ?? "")
				dateComponents.month = Int(periodValues["M"] ?? "")
				dateComponents.year = Int(periodValues["Y"] ?? "")

				// SnMnHn
				let timeValues = componentsForString(timeString, designatorSet: CharacterSet(charactersIn: "HMS"))
				dateComponents.second = Int(timeValues["S"] ?? "")
				dateComponents.minute = Int(timeValues["M"] ?? "")
				dateComponents.hour = Int(timeValues["H"] ?? "")

				return dateComponents
		}

		private static func componentsForString(_ string: String, designatorSet: CharacterSet) -> [String: String] {
				if string.isEmpty {
						return [:]
				}

				let componentValues = string.components(separatedBy: designatorSet).filter { !$0.isEmpty }
				let designatorValues = string.components(separatedBy: .decimalDigits).filter { !$0.isEmpty }

				guard componentValues.count == designatorValues.count else {
						print("String: \(string) has an invalid format")
						return [:]
				}

				return Dictionary(uniqueKeysWithValues: zip(designatorValues, componentValues))
		}

		private static func logErrorMessage(durationString: String) {
				print("String: \(durationString) has an invalid format")
				print("The durationString must have a format of PnYnMnDTnHnMnS or PnW")
		}
}


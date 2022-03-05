//
//  Helper.swift
//  aji
//
//  Created by aco on 30/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation

class Helper {
	
	static func minutesToFormattedInterval(interval: Int, style: DateComponentsFormatter.UnitsStyle) -> String? {
		let formatter = DateComponentsFormatter()
		
		formatter.allowedUnits = [.day, .hour, .minute, .second]
		formatter.unitsStyle = style

		return formatter.string(from: TimeInterval(interval))
	}
}

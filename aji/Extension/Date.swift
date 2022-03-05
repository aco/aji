//
//  Date.swift
//  nea
//
//  Created by aco on 01/08/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

extension Date {
	
	func string(format: String) -> String {
		let formatter = DateFormatter()
		
		formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: Locale.current)!
		
		return formatter.string(from: self)
	}
}

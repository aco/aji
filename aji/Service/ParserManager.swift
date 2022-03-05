//
//  ParserManager.swift
//  aji
//
//  Created by aco on 06/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation

class ParserManager {
	
	private var parsers = Dictionary<String, SiteParser>()
	private(set) var mostRecentParserUpdate: Double = 0
	
	class var sharedInstance: ParserManager {
		struct Singleton {
			static let instance = ParserManager()
		}
		
		return Singleton.instance
	}
	
	init() {
		let decoder = JSONDecoder()
		
		guard
			let url = Bundle.main.url(forResource: "parsers", withExtension: "json"),
			let data = try? Data(contentsOf: url),
			let parsers = try? decoder.decode([SiteParser].self, from: data)
		else {
			return
		}
		
		for parser in parsers {
			self.parsers[parser.domain] = parser
		}
	}
	
	internal func parserFor(domain: String) -> SiteParser? {
		return self.parsers[domain]
	}
}

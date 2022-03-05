//
//  OfflineWebView.swift
//  aji
//
//  Created by aco on 20/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

import WebKit

class OfflineWebView: WKWebView {
	
	init(frame: CGRect, configuration: WKWebViewConfiguration, messageHandler: WKScriptMessageHandler) {
		configuration.allowsAirPlayForMediaPlayback = false
		configuration.allowsInlineMediaPlayback = false
		configuration.allowsPictureInPictureMediaPlayback = false
		configuration.ignoresViewportScaleLimits = true
		
		configuration.userContentController.add(messageHandler, name: "default")
		
				let blockRules = """
					[{ \"trigger\": { \"url-filter\": \".*\", \"resource-type\": [\"image\"] }, \"action\": { \"type\": \"block\" } }]
					"""
		
				WKContentRuleListStore.default().compileContentRuleList(
					forIdentifier: "ContentBlockingRules",
					encodedContentRuleList: blockRules
				) { contentRuleList, error in
					if let _ = error {
						// Handle error
					} else if let contentRuleList = contentRuleList {
						configuration.userContentController.add(contentRuleList)
					} else {
						// Handle error
					}
				}
		
		super.init(frame: frame, configuration: configuration)
	}
	
	public func evaluate(script: String, completion: @escaping (Any?, Error?) -> Void) {
		var finished = false
		
		evaluateJavaScript(script, completionHandler: { (result, error) in
			if error == nil {
				if result != nil {
					completion(result, nil)
				}
			} else {
				completion(nil, error)
			}
			finished = true
		})
		
		while !finished {
			RunLoop.current.run(mode: RunLoop.Mode(rawValue: "NSDefaultRunLoopMode"), before: NSDate.distantFuture)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

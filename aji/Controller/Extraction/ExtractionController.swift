//
//  ViewController.swift
//  aji
//
//  Created by aco on 17/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import UIKit
import WebKit

import PINRemoteImage

class ExtractionController: UIViewController {
	
	internal lazy var webView = OfflineWebView(frame: self.view.frame,
																						 configuration: WKWebViewConfiguration(), messageHandler: self)
	
	open var didCompleteWithRecipe: ((Recipe, UIImage?) -> ())!
	open var didFail: (() -> ())? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.addSubview(webView)
		
		NSLayoutConstraint.activate([
			webView.topAnchor.constraint(equalTo: view.topAnchor),
			webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
	}
	
	init(url: URL) {
		super.init(nibName: nil, bundle: nil)
		
		self.webView.navigationDelegate = self
		self.webView.load(URLRequest(url: url))
	}
	
	internal func fetchImage(results: Dictionary<String, Any>, completion: @escaping (Dictionary<String, Any>, UIImage?) -> ()) {
		if let imagePath = results["imageUrl"] as? String, let url = URL(string: imagePath) {
			let m = PINRemoteImageManager()
			
			m.downloadImage(with: url, options: [], progressImage: nil) { (result) in
				guard let image = result.image else {
					completion(results, nil)
					return
				}
				
				completion(results, image)
			}
		} else {
			completion(results, nil)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension ExtractionController: WKNavigationDelegate, WKScriptMessageHandler {
	
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		return
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		var results = [String:Any]()
		
		let group = DispatchGroup()
		
		if let host = self.webView.url?.host?.replacingOccurrences(of: "www.", with: ""), let siteSpecification = ParserManager.sharedInstance.parserFor(domain: host) {
			for child in Mirror(reflecting: siteSpecification).children {
				guard let extractor = child.value as? String, extractor.count > 3 else {
					continue
				}
				
				group.enter()
				
				self.webView.evaluate(script: extractor) { (result, error) in
					if let label = child.label {
						results[label] = result
					}
					
					group.leave()
				}
			}
		} else {
			group.enter()
			
			self.webView.evaluate(script: RecipeParser.sharedInstance.hrecipeBundle) { (result, error) in
				if let result = result as? Dictionary<String, Any> {
					results = result
				}
				
				group.leave()
			}
		}
		
		group.notify(queue: .main) {
			guard !results.isEmpty else {
				DispatchQueue.main.async {
					self.didFail?()
				}
				
				return
			}
			
			self.fetchImage(results: results) { (final, image) in
				DispatchQueue.main.async {
					let recipe = Recipe(id: self.webView.url?.absoluteString ?? UUID().uuidString, from: final, image: image)
		 
					if recipe.urlString == nil {
						recipe.urlString = self.webView.url?.absoluteString
					}
					
					self.didCompleteWithRecipe(recipe, image)
				}
			}
		}
	}
}

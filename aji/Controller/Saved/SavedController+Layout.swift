//
//  SavedController+Layout.swift
//  aji
//
//  Created by aco on 03/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

import Tabman
import Pageboy

extension SavedController: PageboyViewControllerDataSource, TMBarDataSource {
	
	func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
		return viewControllers.count
	}
	
	func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
		return viewControllers[index]
	}
	
	func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
		return nil
	}
	
	func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
		return TMBarItem(title: collections[index].description.capitalized)
	}
	
	internal func adjustTabScrollContentMode() {
		var titleWidth: CGFloat = CGFloat(self.viewControllers.count) * (Constant.padding * 2)
		
		for collection in collections {
			let title = collection.description.capitalized
			
			titleWidth += (title as NSString).size(withAttributes: [
				NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
			]).width
		}
		
		if titleWidth <= self.view.frame.width {
			bar.layout.contentMode = .fit
		}else {
			bar.layout.contentMode = .intrinsic
		}
	}
	
	internal func configureTabBarAppearance(bar: CircularIndicatorBar) {
		bar.buttons.customize { (button) in
			button.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constant.padding / 2, right: 0)
			
			button.font = .systemFont(ofSize: 15, weight: .medium)
			button.tintColor = Style.Colors.primaryText
			button.backgroundColor = Style.Colors.mainBackground
			button.selectedTintColor = Style.Colors.primaryGreen
		}
		
		bar.backgroundColor = Style.Colors.mainBackground
		bar.rootContentStack.backgroundColor = Style.Colors.mainBackground
		bar.fadesContentEdges = true
		bar.backgroundView.style = .flat(color: Style.Colors.mainBackground)
		bar.indicator.tintColor = Style.Colors.primaryGreen
		bar.indicator.size = .small

		bar.spacing = Constant.padding

		bar.layout.transitionStyle = .progressive
		bar.layout.interButtonSpacing = Constant.padding
		bar.rootContentStack.backgroundColor = Style.Colors.mainBackground
		
		bar.layout.separatorInset = UIEdgeInsets(top: 0, left: Constant.padding, bottom: 0, right: Constant.padding)
		bar.layout.contentInset = UIEdgeInsets(top: 0, left: Constant.padding, bottom: Constant.padding / 2, right: Constant.padding)
	}
}


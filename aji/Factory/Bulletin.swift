//
//  BulletinFactory.swift
//  aji
//
//  Created by aco on 28/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class BulletinFactory {
	
	static func makeTextFieldPage(title: String, brief: String, buttonTitle: String, defaultValue: String?, placeholder: String?, handler: @escaping (TextFieldBulletinPage, String?) -> ()) -> TextFieldBulletinPage {
		let page = TextFieldBulletinPage(title: title)
		
		page.isDismissable = true
		page.descriptionText = brief
		page.actionButtonTitle = buttonTitle
		page.textFieldPlaceholder = placeholder
		page.textField.text = defaultValue
		
		page.textInputHandler = handler
		
		return page
	}
	
	static func makeURLTextFieldPage(title: String, brief: String, buttonTitle: String, defaultValue: String?, placeholder: String?, handler: @escaping (TextFieldBulletinPage, String?) -> ()) -> URLTextFieldBulletinPage {
		let page = URLTextFieldBulletinPage(title: title)
		
		page.isDismissable = true
		page.descriptionText = brief
		page.actionButtonTitle = buttonTitle
		page.textFieldPlaceholder = placeholder
		page.textField.text = defaultValue
		page.textField.keyboardType = .URL
		page.alternativeButtonTitle = "Paste"
		
		page.textInputHandler = handler
		page.alternativeHandler = { item in
			page.textField.text = UIPasteboard.general.string
		}
		
		return page
	}
	
	static func makeIntervalPickerPage(title: String, brief: String?, buttonTitle: String, defaultValue: Int, handler: @escaping (BLTNActionItem) -> ()) -> IntervalPickerBulletin {
		let page = IntervalPickerBulletin(title: title)
		
		page.descriptionText = brief
		page.actionButtonTitle = buttonTitle
		page.isDismissable = true
		
		page.picker.countDownDuration = TimeInterval(defaultValue)
		
		page.actionHandler = handler
		
		return page
	}
	
	static func makeNoticePage(title: String, brief: String?, buttonTitle: String, handler: @escaping (BLTNActionItem) -> ()) -> FeedbackPageBLTNItem {
		let page = FeedbackPageBLTNItem(title: title)
		
		page.descriptionText = brief
		page.actionButtonTitle = buttonTitle
		page.isDismissable = true
		
		page.alternativeButtonTitle = "No thanks"
		
		page.alternativeHandler = { (item) in
			item.manager?.dismissBulletin()
		}
		
		page.actionHandler = handler
		
		return page
	}
	
	static func makeStepperPage(yield: Int, yieldDescription: String, changeHandler: @escaping (Int) -> Void) -> FeedbackPageBLTNItem {
		let page = StepperBulletin(yield: yield, yieldDescription: yieldDescription, changeHandler: changeHandler)
		
		page.descriptionText = "Where possible, aji will scale the recipe proportions for the selected serving size"
		
		return page
	}
}

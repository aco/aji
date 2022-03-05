//
//  TextEntryBulletin.swift
//  aji
//
//  Created by aco on 28/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

@objc public class FeedbackPageBLTNItem: BLTNPageItem {
	
	private let feedbackGenerator = SelectionFeedbackGenerator()
	
	override public func actionButtonTapped(sender: UIButton) {
		feedbackGenerator.prepare()
		feedbackGenerator.selectionChanged()
		
		super.actionButtonTapped(sender: sender)
		
	}
	
	override public func alternativeButtonTapped(sender: UIButton) {
		feedbackGenerator.prepare()
		feedbackGenerator.selectionChanged()
		
		super.alternativeButtonTapped(sender: sender)
	}
}

@objc public class TextFieldBulletinPage: FeedbackPageBLTNItem {
	
	@objc public var textFieldPlaceholder: String? = nil
	
	@objc public lazy var textField = BLTNInterfaceBuilder(appearance: BLTNItemAppearance()).makeTextField(placeholder: self.textFieldPlaceholder, returnKey: .done, delegate: self)
	
	@objc public var textInputHandler: ((TextFieldBulletinPage, String?) -> Void)? = nil
	
	override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
		return [textField]
	}
	
	override public func tearDown() {
		super.tearDown()
		textField.delegate = nil
	}
	
	override public func actionButtonTapped(sender: UIButton) {
		textField.resignFirstResponder()
		super.actionButtonTapped(sender: sender)
	}
}

// MARK: - UITextFieldDelegate

extension TextFieldBulletinPage: UITextFieldDelegate {
	
	@objc open func isInputValid(text: String?) -> Bool {
		guard let text = text else {
			return false
		}
		
		return !text.isEmpty
	}
	
	public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		return true
	}
	
	public func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.backgroundColor = nil
	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	public func textFieldDidEndEditing(_ textField: UITextField) {
		
		if isInputValid(text: textField.text) {
			textInputHandler?(self, textField.text)
		} else {
			descriptionLabel!.text = "You can't submit blank text!"
			
			textField.backgroundColor = Style.Colors.tomato.withAlphaComponent(0.25)
		}
	}
}

@objc public class URLTextFieldBulletinPage: TextFieldBulletinPage {
	
	func verifyUrl(urlString: String?) -> Bool {
			guard let urlString = urlString,
						let url = URL(string: urlString) else {
					return false
			}

			return UIApplication.shared.canOpenURL(url)
	}
	
	public override func textFieldDidEndEditing(_ textField: UITextField) {
		if isInputValid(text: textField.text) {
			textInputHandler?(self, textField.text)
		} else {
			descriptionLabel!.text = "aji needs a valid URL to search for a recipe"
			
			textField.backgroundColor = Style.Colors.tomato.withAlphaComponent(0.25)
		}
	}

	public override func isInputValid(text: String?) -> Bool {
		return super.isInputValid(text: text) && verifyUrl(urlString: text)
	}
}

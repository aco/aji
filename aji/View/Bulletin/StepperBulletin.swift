//
//  StepperBulletin.swift
//  aji
//
//  Created by aco on 09/11/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class StepperBulletin: FeedbackPageBLTNItem {
	
	private lazy var increaseButton = self.createChoiceCell(systemImageName: "plus")
	private lazy var decreaseButton = self.createChoiceCell(systemImageName: "minus")
	
	internal var yield: Int
	internal let yieldDescription: String
	
	private var selectionFeedbackGenerator = SelectionFeedbackGenerator()
	
	let changeHandler: (Int) -> Void

	@objc public init(yield: Int, yieldDescription: String, changeHandler: @escaping (Int) -> Void) {
		self.yield = yield
		self.yieldDescription = yieldDescription
		self.changeHandler = changeHandler
		
		super.init(title: "")
		
		self.updateYieldTitle()
	}

	public override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
		increaseButton.tag = 1
		decreaseButton.tag = -1
		
		increaseButton.addTarget(self, action: #selector(didTouchUpInsideButton), for: .touchUpInside)
		decreaseButton.addTarget(self, action: #selector(didTouchUpInsideButton), for: .touchUpInside)
		
		let petsStack = interfaceBuilder.makeGroupStack(spacing: Constant.padding, axis: .horizontal)
		
		petsStack.addArrangedSubview(increaseButton)
		petsStack.addArrangedSubview(decreaseButton)
		
		return [petsStack]
	}
	
	private func updateYieldTitle() {
		let description = self.yield > 1 ? self.yieldDescription.pluralized() : self.yieldDescription.singularized()
		self.title = "\(self.yield) \(description)"
	}
	
	@objc internal func didTouchUpInsideButton(sender: UIButton) {
		let newYield = self.yield + sender.tag
		
		guard newYield > 0 else {
			return
		}
		
		self.yield = newYield
		updateYieldTitle()
		
		self.decreaseButton.isEnabled = self.yield > 1
		self.changeHandler(self.yield)
	}
	
	func createChoiceCell(systemImageName: String) -> UIButton {
		let button = UIButton(type: .system)
		
		if let image = UIImage(systemName: systemImageName) {
			button.setImage(image, for: .normal)
		} else {
			button.setTitle(systemImageName.capitalized, for: .normal)
		}
		
		button.tintColor = Style.Colors.primaryGreen
		button.layer.borderColor = Style.Colors.altBackground.cgColor
		
		button.layer.cornerRadius = Constant.padding
		button.layer.borderWidth = Constant.hairlineWidth
		
		button.contentHorizontalAlignment = .center
		button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		let heightConstraint = button.heightAnchor.constraint(equalToConstant: 50)
		
		heightConstraint.priority = .defaultHigh
		heightConstraint.isActive = true
		
		return button
	}
}


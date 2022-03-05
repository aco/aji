////
////  Tab.swift
////  aji
////
////  Created by aco on 17/10/2020.
////  Copyright © 2020 aco. All rights reserved.
////

import Foundation
import UIKit

fileprivate struct CircleTabBarBaseDimension {
	static var tabBarHeight: CGFloat {
		return 50
	}
	static var circleViewSize: CGSize {
		return CGSize(width: 62, height: 62)
	}
	static var circleViewCornerRadius: CGFloat {
		return CircleTabBarBaseDimension.circleViewSize.height / 2
	}
}

class CircleTabBarController: AnimatedTabBar {
	
	public typealias CircleButtonActionCallBack = (_ completion: @escaping () -> Void) -> Void
	
	internal var circleVisible = false
	
	private var barHeight: CGFloat {
		get {
			return CircleTabBarBaseDimension.tabBarHeight + view.safeAreaInsets.bottom
		}
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		view.bringSubviewToFront(circleView)
		self.updateFrames()
	}
	
	public func setCircleViewVisibility(visible: Bool) {
		self.circleVisible = visible
	}
	
	public var circleTintColorForNormal: UIColor? {
		didSet {
//			circleImageView.tintColor = circleTintColorForNormal
			if let centerIndex = canAddCenterCircleView.centerIndex, let centerTabBarItem = self.tabBar.items?[centerIndex], let selectedColor = circleTintColorForSelected {
				centerTabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : selectedColor], for: .normal)
			}
		}
	}
	public var circleTintColorForSelected: UIColor? {
		didSet {
			if let centerIndex = canAddCenterCircleView.centerIndex, let centerTabBarItem = self.tabBar.items?[centerIndex], let selectedColor = circleTintColorForSelected {
				centerTabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : selectedColor], for: .selected)
			}
		}
	}
	public var circleTabBarItemImage: UIImage?
	public var circleButtonCustomAction: CircleButtonActionCallBack?
	
	private lazy var circleView: UIView = {
		let view = UIView()
		
		view.layer.cornerRadius = CircleTabBarBaseDimension.circleViewCornerRadius
		view.isUserInteractionEnabled = true
		view.backgroundColor = Style.Colors.primaryGreen
		
		view.layer.shadowColor = UIColor.black.withAlphaComponent(0.24).cgColor
		view.layer.shadowOffset = CGSize(width: 0, height: -2.0)
		view.layer.shadowOpacity = 1.0
		view.layer.shadowRadius = 4
		view.layer.masksToBounds = false
		
		return view
	}()
	
	private lazy var circleButton: UIButton = {
		let view = UIButton(type: .system)
		
		view.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
		view.layer.cornerRadius = CircleTabBarBaseDimension.circleViewCornerRadius
		view.tintColor = .white
		view.setTitleColor(Style.Colors.primaryGreen, for: .selected)
		view.backgroundColor = .clear
		
		view.addTarget(self, action: #selector(circleButtonTap), for: .touchUpInside)
		
		return view
	}()
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		
		indicator.color = .white
		indicator.translatesAutoresizingMaskIntoConstraints = false
		indicator.isUserInteractionEnabled = false
		
		return indicator
	}()
	
	private lazy var maskLayer: CAShapeLayer = {
		let maskLayer = CAShapeLayer()
		maskLayer.fillRule = .evenOdd
		maskLayer.fillColor = UIColor.white.cgColor
		return maskLayer
	}()
	
	private var canAddCenterCircleView: (bool: Bool, centerIndex: Int?) {
		guard
			let viewControllers = viewControllers, viewControllers.count % 2 != 0 && viewControllers.count <= 5
		else {
			return (bool: false, centerIndex: nil)
		}

		return (bool: true, centerIndex: (viewControllers.count / 2))
	}
	
	private var centerViewController: UIViewController?
	private var shouldInit: Bool = true
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	
		self.tabBar.barTintColor = Style.Colors.primaryGreen

		self.tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.24).cgColor
		self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0.0)
		self.tabBar.layer.shadowOpacity = 1.0
		self.tabBar.layer.shadowRadius = 4.0
	}
	
	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.commonInit()
	}
	
	func commonInit() {
		if shouldInit == true, canAddCenterCircleView.bool == true, let centerIndex = canAddCenterCircleView.centerIndex {
			
			defer {
				shouldInit = false
			}

			self.addSubViews()
			
			if centerViewController == nil {
				centerViewController = viewControllers?[centerIndex]
			}
			
			circleTabBarItemImage = self.tabBar.items?[centerIndex].image
			self.tabBar.items?[centerIndex].image = UIImage()
			
			NSLayoutConstraint.activate([
				activityIndicator.centerXAnchor.constraint(equalTo: circleButton.centerXAnchor),
				activityIndicator.centerYAnchor.constraint(equalTo: circleButton.centerYAnchor),
			])
		}
	}
	
	func updateFrames() {
		if canAddCenterCircleView.bool {
			self.updateTabBarFrame()
			self.updateCircleViewFrame()
		}
	}
	
	func addSubViews() {
		if circleView.subviews.contains(circleButton) == false {
			circleView.addSubview(circleButton)
			circleView.addSubview(activityIndicator)
		}
		if view.subviews.contains(circleView) == false {
			self.view.addSubview(circleView)
		}
	}
	
	func updateTabBarFrame() {
		var tabFrame = self.tabBar.frame

		tabFrame.size.height = barHeight
		tabFrame.origin.y = self.view.frame.size.height - barHeight

		self.tabBar.frame = tabFrame
		
		self.circleButton.frame = self.circleView.bounds
		self.activityIndicator.frame = self.circleView.bounds

		tabBar.setNeedsLayout()
	}
	
	func updateCircleViewFrame() {
		guard let centerIndex = canAddCenterCircleView.centerIndex else {
			return
		}
		
		let tabWidth = self.view.bounds.width / CGFloat(self.tabBar.items?.count ?? 3)
		
		let animator = UIViewPropertyAnimator(duration: self.circleVisible ? 1.33 : 0.66, timingParameters: Animator.shared.springTimingFunction)
		let y = self.circleVisible ? self.tabBar.frame.origin.y - CircleTabBarBaseDimension.circleViewCornerRadius / 2 : self.viewControllers![0].view.bounds.height
																					
		animator.addAnimations {
			self.circleView.frame = CGRect(x: (tabWidth * CGFloat(centerIndex)) + tabWidth / 2 - CircleTabBarBaseDimension.circleViewCornerRadius,
																y: y,
																width: CircleTabBarBaseDimension.circleViewSize.width, height: CircleTabBarBaseDimension.circleViewSize.height)
			
			self.circleButton.frame = self.circleView.bounds
			self.activityIndicator.frame = self.circleView.bounds
		}
		
		animator.startAnimation()
	}
	
	internal func toggleActivityIndicator(animating: Bool) {
		self.activityIndicator.frame = self.circleView.bounds
		if animating {
			self.activityIndicator.startAnimating()
			self.circleButton.alpha = 0
		} else {
			self.activityIndicator.stopAnimating()
			self.circleButton.alpha = 1
		}
	}
	
	@objc func circleButtonTap() {
		if let circleButtonCustomAction = circleButtonCustomAction {
			circleButtonCustomAction {
				
			}
		}
	}
}

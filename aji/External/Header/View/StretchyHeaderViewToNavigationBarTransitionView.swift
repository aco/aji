//
//  StretchyHeaderViewToNavigationBarTransitionView.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/9/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

import UIKit

class StretchyHeaderViewToNavigationBarTransitionView: UIView, StretchyHeaderViewToNavigationBarTransitionCapable {
	
	// MARK: - Members
	
	var navigationUnderlayHeight: CGFloat
	
	internal var placeholderImage: UIImage?
	internal var defaultMultiplier: CGFloat? = nil
	
	var multiplier: CGFloat {
		guard let placeholderImage = self.placeholderImage else {
			return 0.5
		}
		
		let width = placeholderImage.size.width
		let height = min(placeholderImage.size.height, Constant.trueScreenHeight * (Constant.isiPad ? 2.5 : 6))

		return 1 / (width / height)
	}
	
	private(set) lazy var navigationUnderlayGradientView: GradientView = {
		let view = GradientView()
		
		view.translatesAutoresizingMaskIntoConstraints = false
		view.configureNavigationBackground()
		
		return view
	}()
	
	private(set) lazy var imageView: UIImageView = {
		let imageView = UIImageView(image: placeholderImage)
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill // This is required for the stretchy effect
		imageView.clipsToBounds = true
		imageView.backgroundColor = Style.Colors.primaryGreen
		
		return imageView
	}()
	
	private(set) lazy var visualEffectView: UIVisualEffectView = {
		let effect = UIBlurEffect(style: .systemUltraThinMaterial)
		let view = UIVisualEffectView(effect: effect)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		view.alpha = .zero
		view.isUserInteractionEnabled = false
		
		return view
	}()
	
	// MARK: - Initializers
	
	init(frame: CGRect, navigationUnderlayHeight: CGFloat, image: UIImage?, multiplier: CGFloat) {
		if let image = image {
			self.placeholderImage = image
		}
		
		self.navigationUnderlayHeight = navigationUnderlayHeight * 1.5
		self.defaultMultiplier = multiplier
		
		super.init(frame: frame)
		
		configureHierarchy()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	func updateImage(image: UIImage) {
		imageView.image = placeholderImage
	}
	
	//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
	//        super.traitCollectionDidChange(previousTraitCollection)
	//
	//        imageView.image = placeholderImage
	//    }
}

// MARK: - Helpers

private extension StretchyHeaderViewToNavigationBarTransitionView {
	
	func configureHierarchy() {
		self.isUserInteractionEnabled = false
		self.preservesSuperviewLayoutMargins = true
		
		self.backgroundColor = UIColor(white: 1, alpha: 0.2)
		
		addSubview(imageView)
		addSubview(navigationUnderlayGradientView)
		addSubview(visualEffectView)
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: topAnchor),
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			navigationUnderlayGradientView.topAnchor.constraint(equalTo: topAnchor),
			navigationUnderlayGradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
			navigationUnderlayGradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
			navigationUnderlayGradientView.heightAnchor.constraint(equalToConstant: navigationUnderlayHeight),
			
			visualEffectView.topAnchor.constraint(equalTo: topAnchor),
			visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
			visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
			visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}

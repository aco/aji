//
//  HeaderCollectionViewController.swift
//  aji
//
//  Created by aco on 27/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class HeaderUICollectionViewController: UIViewController, UICollectionViewDelegate, StretchyHeaderViewToNavigationBarTransitioning {
	
	var animator: UIViewPropertyAnimator?
	var headerTopConstraint: NSLayoutConstraint!
	var headerHeightConstraint: NSLayoutConstraint!
	var overlayBottomConstraint: NSLayoutConstraint!
	var overlayHeightConstraint: NSLayoutConstraint!
	
	internal let image: UIImage?
	internal var defaultMultiplier: CGFloat = 2.5
	
	private(set) lazy var scrollView: UIScrollView = collectionView
	private(set) lazy var transitioningHeaderView: StretchyHeaderViewToNavigationBarTransitionCapable = stretchyHeaderView
	private(set) lazy var transitioningOverlayView: UIView = overlayHeaderView
	private(set) lazy var transitioningOverlayViewOffset: CGPoint = CGPoint(x: 0, y: 0)
	
	private(set) lazy var stretchyHeaderView: StretchyHeaderViewToNavigationBarTransitionView = {
		let view = StretchyHeaderViewToNavigationBarTransitionView(frame: .zero, navigationUnderlayHeight: navigationControllerHeight, image: self.image, multiplier: self.defaultMultiplier)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private(set) lazy var overlayHeaderView: OverlayHeaderView = {
		let view = OverlayHeaderView()
		
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		
		return view
	}()
	
	internal lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCompositionalLayout())
		
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = Style.Colors.mainBackground
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.alwaysBounceVertical = true
		
		collectionView.backgroundColor = Style.Colors.mainBackground
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		collectionView.contentInset.bottom = 34
		collectionView.delegate = self
		
		view.addSubview(collectionView)
		self.view.addSubview(collectionView)
		
		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		
		return collectionView
	}()
	
	init(image: UIImage?) {
		self.image = image
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		scrollViewWillLayoutSubviews()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)

		scrollViewWillTransition(to: size, with: coordinator)
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
			scrollViewDidPerformTransition()
	}
	
	open func makeCompositionalLayout() -> UICollectionViewLayout {
		return UICollectionViewLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

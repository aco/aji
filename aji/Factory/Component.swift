//
//  Factory.swift
//  aji
//
//  Created by aco on 22/10/2020.
//  Copyright © 2020 aco. All rights reserved.
//

import Foundation
import UIKit

class Factory {
	
	static func generateSubtitleTextLabel(numberOfLines: Int) -> UILabel {
		let label = UILabel()
		
		label.font = UIFont.systemFont(ofSize: 12)
		label.numberOfLines = numberOfLines
		label.textColor = Style.Colors.secondaryText
		label.isUserInteractionEnabled = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}
	
	static func generateTitleTextLabel(numberOfLines: Int, fontSize: CGFloat = 16) -> UILabel {
		let label = UILabel()
		
		label.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
		label.numberOfLines = numberOfLines
		label.textColor = Style.Colors.primaryText
		label.isUserInteractionEnabled = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}
	
	static func generateRelativeTimestamp(from date: Date) -> String {
		let formatter = RelativeDateTimeFormatter()
		formatter.unitsStyle = .full
		
		return formatter.localizedString(for: date, relativeTo: Date())
	}
	
	static func buildAdditionalSourcesLabel(height: CGFloat, backgroundColor: UIColor?) -> UILabel {
		let label = UILabel() // Factory.generateSubtitleTextLabel(numberOfLines: 1)
		
		label.isUserInteractionEnabled = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 12)
		
		label.layer.masksToBounds = true
		label.layer.cornerRadius = height / 2
		
		if let backgroundColor = backgroundColor {
			label.backgroundColor = backgroundColor
			label.textColor = Style.Colors.linkInverted
		} else {
			label.backgroundColor = Style.Colors.link
			label.textColor = Style.Colors.linkInverted
		}
		
		return label
	}
	
	static func generateBodyTextView() -> UILabel {
		let textView = UILabel()
		
		textView.font = .systemFont(ofSize: 15)
		textView.textColor = Style.Colors.primaryText
		//		textView.isEditable = false
		textView.numberOfLines = 0
		textView.translatesAutoresizingMaskIntoConstraints = false
		
		return textView
	}
	
	static func generateIconLabel(icon: String, altIcon: String? = nil, color: UIColor, size: CGFloat = 20) -> UILabel {
		let label = UILabel()

		let imageAttachment = NSTextAttachment()
		let image = UIImage(systemName: icon) ?? UIImage(systemName: altIcon ?? "")
		
		imageAttachment.image = image?.withRenderingMode(.alwaysTemplate).withTintColor(color)
		
		label.attributedText = NSAttributedString(attachment: imageAttachment)
		label.font = .systemFont(ofSize: size)
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}
	
	static func generateBarButtonItem(title: String, selector: Selector, target: Any?, spacing: CGFloat?) -> UIBarButtonItem {
		let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
		
		if let spacing = spacing {
			barButton.width = spacing
		}
		
		return barButton
	}
	
	static func generateBarButtonItemCustomView(systemImage: String, selector: Selector, target: Any?) -> UIBarButtonItem {
		let button = UIButton(type: .system)
		
		button.setImage(UIImage(systemName: systemImage)?.withRenderingMode(.alwaysTemplate).withTintColor(Style.Colors.primaryGreen), for: .normal)
		button.addTarget(target, action: selector, for: .touchUpInside)
		
		return UIBarButtonItem(customView: button)
	}
	
	static func generateBackBarButtonItem() -> UIBarButtonItem {
		return UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}
	
	static func generateTabBarItem(title: String?, tabImageName: String) -> UITabBarItem {
		let tabBarImage = UIImage(systemName: tabImageName)?.withRenderingMode(.alwaysTemplate)
		let selectedTabBarImage = UIImage(systemName: "\(tabImageName).fill")?.withRenderingMode(.alwaysTemplate)
		
		let tabBarItem = UITabBarItem(title: title, image: tabBarImage, selectedImage: selectedTabBarImage)
		
		return tabBarItem
	}
	
	static func generateRoundedImageView(cornerRadius: CGFloat = Constant.padding) -> UIImageView {
		let imageView = UIImageView()
		
		imageView.backgroundColor = Style.Colors.altBackground
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		imageView.backgroundColor = Style.Colors.altBackground
		
		imageView.layer.borderWidth = Constant.hairlineWidth
		imageView.layer.borderColor = Style.Colors.border.cgColor
		imageView.layer.cornerRadius = cornerRadius
		
		return imageView
	}
	
	static func generateBorderView() -> UIView {
		let view = UIView()
		
		view.backgroundColor = Style.Colors.border
		
		return view
	}
	
	static func generateStatusBarMask() -> UIView {
		let view = UIView()
		
		view.backgroundColor = Style.Colors.mainBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}
	
	static func generateCollectionView(for view: UIView?, delegate: UICollectionViewDelegate, layout: UICollectionViewLayout) -> UICollectionView {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = Style.Colors.mainBackground
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.alwaysBounceVertical = true
		
		collectionView.backgroundColor = Style.Colors.mainBackground
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		collectionView.contentInset.bottom = 34
		collectionView.delegate = delegate
		
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
		
		if let view = view {
			view.addSubview(collectionView)

			NSLayoutConstraint.activate([
				collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				collectionView.topAnchor.constraint(equalTo: view.topAnchor),
				collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			])
		}
		
		return collectionView
	}
}

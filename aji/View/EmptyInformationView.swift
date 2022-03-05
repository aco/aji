//
//  EmptyInformationView.swift
//  nea
//
//  Created by ac on 30/01/2019.
//  Copyright © 2019 abstersi. All rights reserved.
//

import Foundation
import UIKit

class EmptyInformationView: UIView {
	
	private var entranceComplete = false
	
	internal let iconLabel: UIImageView = {
		let imageView = UIImageView()
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = Style.Colors.altBackground
		
		return imageView
	}()
	
	internal let subtitleLabel: UILabel = {
		let label = UILabel()
		
		label.font = UIFont.systemFont(ofSize: 15)
		label.numberOfLines = 0
		label.textAlignment = .center
		label.textColor = Style.Colors.tertiaryText
		label.isUserInteractionEnabled = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}()
	
	init(subtitle: String, icon: String) {
		self.iconLabel.image = UIImage(systemName: icon)?.withRenderingMode(.alwaysTemplate)
		
		super.init(frame: .zero)
		
		let contentView = UIView()
		
		contentView.translatesAutoresizingMaskIntoConstraints = false
		
		subtitleLabel.text = subtitle
		
		contentView.addSubview(iconLabel)
		contentView.addSubview(subtitleLabel)
		
		addSubview(contentView)
		
		NSLayoutConstraint.activate([
			iconLabel.widthAnchor.constraint(equalToConstant: 64),
			iconLabel.heightAnchor.constraint(equalToConstant: 64),
			iconLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			
			contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -64),
			contentView.leadingAnchor.constraint(lessThanOrEqualTo: self.leadingAnchor),
			contentView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor),
			
			subtitleLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: Constant.padding / 2),
			subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
			subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding)
		])
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if !entranceComplete {
			Animator.applyEntranceAnimation(target: iconLabel, offset: Constant.padding * 1.5, delay: 0, direction: .up, fade: true)
			Animator.applyEntranceAnimation(target: subtitleLabel, offset: Constant.padding, delay: 0.15, direction: .up, fade: true)
			
			entranceComplete = true
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


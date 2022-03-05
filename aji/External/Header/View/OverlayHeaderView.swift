//
//  OverlayHeaderView.swift
//  stretchy-header-to-navigation-bar
//
//  Created by Antoine Barre on 3/9/20.
//  Copyright © 2020 Pomanks. All rights reserved.
//

import UIKit

final class OverlayHeaderView: UIView {

    // MARK: - Members

    private(set) lazy var maskGradientView: GradientView = {
        let view = GradientView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.configureDefaultBackground()

        return view
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers

private extension OverlayHeaderView {

    func configureHierarchy() {
        insetsLayoutMarginsFromSafeArea = false
        overrideUserInterfaceStyle = .dark
        preservesSuperviewLayoutMargins = true
    }
}

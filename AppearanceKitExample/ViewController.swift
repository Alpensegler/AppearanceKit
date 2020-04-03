//
//  ViewController.swift
//  AppearanceKitDemo
//
//  Created by Frain on 2020/3/25.
//  Copyright © 2020 Frain. All rights reserved.
//

import UIKit
import AppearanceKit

enum Theme: CaseIterable {
    case red
    case blue
    case green
    
    static let `default` = Theme.allCases.randomElement()!
}

class CustomLayer: CALayer {
    override func configureAppearance() {
        super.configureAppearance()
    }
}

extension AppearanceTrait {
    var theme: StoredEnvironment<Theme> { .init(defaultValue: .default) }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .bindEnvironment(\.theme) {
            switch $0 {
            case .blue: return .systemRed
            case .red: return .systemBlue
            case .green: return .systemGreen
            }
        }

        let layer = CustomLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        layer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        if #available(iOS 13.0, *) {
            let color = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }.dynamicCGColor

            layer.backgroundColor = UIColor.white.cgColor
            layer.borderColor = color
            layer.borderWidth = 1
        }

        view.layer.addSublayer(layer)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refresh)
        )
    }
    
    override func configureAppearance() {
        super.configureAppearance()
    }
    
    @objc private func refresh() {
        ap.theme = Theme.allCases.lazy.filter { $0 != self.ap.theme }.randomElement()!
    }
}

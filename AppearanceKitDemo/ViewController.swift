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

extension AppearanceTrait {
    var theme: EnvironmentValue<Theme> { .stored(defaultValue: .default) }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(bindEnvironment: \.theme) {
            switch $0 {
            case .blue: return .red
            case .red: return .blue
            case .green: return .green
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refresh)
        )
        
        print(ap.theme)
        print(ap.theme)
    }
    
    var assciatedValue: Int {
        get { getAssociated(\.assciatedValue) }
        set { setAssociated(\.assciatedValue, newValue) }
    }
    
    @objc private func refresh() {
        ap.theme = Theme.allCases.randomElement()!
    }
}


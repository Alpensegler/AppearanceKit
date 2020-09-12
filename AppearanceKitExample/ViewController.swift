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
    
    var color: UIColor {
        switch self {
        case .blue: return .systemRed
        case .red: return .systemBlue
        case .green: return .systemGreen
        }
    }
    
    static let `default` = Theme.allCases.randomElement()!
}

extension AppearanceTrait {
    var theme: StoredEnvironment<Theme> { .init(defaultValue: .default) }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .bindEnvironment(\.theme) { $0.color }

        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        layer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        if #available(iOS 13.0, *) {
            let color = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }.dynamicCGColor

            layer.backgroundColor = UIColor.systemBackground.dynamicCGColor
            layer.borderColor = color
            layer.borderWidth = 1
        }

        view.layer.addSublayer(layer)
        
        let mutableAttributeString = NSMutableAttributedString(
            string: "change theme ",
            attributes: [.foregroundColor: UIColor.bindEnvironment(\.theme) { $0.color }]
        )
        let attachment = NSTextAttachment()
        attachment.image = .bindEnvironment(\.theme) {
            .init(
                lightAppearance: $0.color.lightColor.cellImage(),
                darkAppearance: $0.color.darkColor.cellImage()
            )
        }
        mutableAttributeString.append(NSAttributedString(attachment: attachment))
        
        let button = UIButton()
        button.setAttributedTitle(mutableAttributeString, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.sizeToFit()
        button.center = layer.position
        button.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        view.addSubview(button)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
    }
    
    @objc private func refresh() {
        UIView.animate(withDuration: 0.3) {
            self.ap.theme = Theme.allCases.lazy.filter { $0 != self.ap.theme }.randomElement()!
        }
    }
}

extension UIColor {
    func cellImage(forSize size: CGSize = CGSize(width: 15, height: 15)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { (context) in
            let bounds = context.format.bounds
            set()
            context.fill(bounds)
        }
    }
}

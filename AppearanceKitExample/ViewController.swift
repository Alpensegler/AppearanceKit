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
        case .blue: return .systemBlue
        case .red: return .systemRed
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

        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        layer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        if #available(iOS 13.0, *) {
            let color = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }.dynamicCGColor

            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: layer.bounds.height / 2))
            path.addLine(to: CGPoint(x: layer.bounds.width, y: layer.bounds.height / 2))
            
            layer.path = path.cgPath
            layer.lineWidth = 3
            layer.backgroundColor = UIColor.systemBackground.dynamicCGColor
            layer.strokeColor = .bindEnvironment(\.theme) { $0.color.dynamicCGColor }
            layer.borderColor = color
            layer.borderWidth = 1
            
            layer.onAppearanceChanged = { [unowned layer] in
                print(layer.ap.theme, layer.ap.isUserInterfaceDark)
            }
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
        
        let label = UILabel()
        label.textColor = .bindEnvironment(\.theme) { $0.color }
        label.font = .systemFont(ofSize: 20)
        label.text = "Color"
        label.sizeToFit()
        label.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2 + 30)
        view.addSubview(label)
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

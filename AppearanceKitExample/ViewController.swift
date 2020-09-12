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
        
        let image = UIImage.bindEnvironment(\.theme) {
            switch $0 {
            case .blue:
                return .init(
                    lightAppearance: UIColor.systemRed.lightColor.cellImage(),
                    darkAppearance: UIColor.systemRed.darkColor.cellImage()
                )
            case .red:
                return .init(
                    lightAppearance: UIColor.systemBlue.lightColor.cellImage(),
                    darkAppearance: UIColor.systemBlue.darkColor.cellImage()
                )
            case .green:
                return .init(
                    lightAppearance: UIColor.systemRed.lightColor.cellImage(),
                    darkAppearance: UIColor.systemGreen.darkColor.cellImage()
                )
            }
        }
        
        let label = UILabel()
        let mutableAttributeString = NSMutableAttributedString(string: "text ")
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds.size = image.size
        mutableAttributeString.append(NSAttributedString(attachment: attachment))
        label.attributedText = mutableAttributeString
        label.font = .systemFont(ofSize: 20)
        label.sizeToFit()
        label.center = layer.position
        view.addSubview(label)

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

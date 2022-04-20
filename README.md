# AppearanceKit

一个用于主题切换的框架，你可以用于在 iOS 13 以下支持 Dark mode，同时也能在 iOS 13 及以上与 Dark mode 一同使用

## 核心功能

- [x] 动态更新颜色而无需重启 App
- [x] 支持 `CALayer` / `CGColor`
- [x] 支持 `NSAttributedString` 和 `NSTextAttachment`
- [x] 支持 Assets 中定义的含 Darkmode 的 Image 和 Color
- [x] 支持自定义 Dark mode / 主题更新时的行为
- [x] 全局 / 局部主题更新

## 例子

使用 AppearanceKit，需要先调用 `AppearanceManager.setup()`，可以放在 `application:didFinishLaunchingWithOptions:` 中，然后可以定义主题

```swift
import AppearanceKit

enum Theme: CaseIterable {
    static let `default` = Theme.allCases.randomElement()!
    case red, blue, green
    
    var color: UIColor {
        switch self {
        case .blue: return .systemBlue
        case .red: return .systemRed
        case .green: return .systemGreen
        }
    }
}

extension AppearanceTrait {
    var theme: StoredEnvironment<Theme> { .init(defaultValue: .default) }
}
```

可以注意到 Theme 的 `color` 属性是自带 Dark mode 的颜色，这里一共会出现 3 * 2 种颜色

接着添加一些 extension 方便使用（非必须）

```swift
extension UIColor {
    static let themeColor = UIColor.bindEnvironment(\.theme) { $0.color }
}

extension CGColor {
    static let themeColor = CGColor.bindEnvironment(\.theme) {
        $0.color.dynamicCGColor 
    }
}
```

然后就能非常容易地使用：

```swift
view.backgroundColor = .themeColor
layer.strokeColor = .themeColor
label.attributedText = NSAttributedString(
    string: "Theme color",
    attributes: [.foregroundColor: UIColor.themeColor]
)
uiImage.image = .bindEnvironment(\.theme) {
    switch $0 {
    case .red: return UIImage(named: "backgroundForRed")!
    case .blue: return UIImage(named: "backgroundForBlue")!
    case .green: return UIImage(named: "backgroundForGreen")!
    }
}
```

更新主题时，可以全局更新

```swift
AppearanceManager.updateEnvironment(\.theme, with: .blue)
```

也可以局部更新

```swift
parentView.ap.theme = .green
```

## 安装

### Carthage

将下面一行添加进 Cartfile 即可：

```text
github "Alpensegler/AppearanceKit"
```

### Swift Package Manager

在 Xcode 中，点击 "Files -> Swift Package Manager -> Add Package Dependency..."，在搜索栏中输入 "https://github.com/Alpensegler/AppearanceKit"

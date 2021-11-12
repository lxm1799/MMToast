# MMToast

[![CI Status](https://img.shields.io/travis/luckyBoy/MMToast.svg?style=flat)](https://travis-ci.org/luckyBoy/MMToast)
[![Version](https://img.shields.io/cocoapods/v/MMToast.svg?style=flat)](https://cocoapods.org/pods/MMToast)
[![License](https://img.shields.io/cocoapods/l/MMToast.svg?style=flat)](https://cocoapods.org/pods/MMToast)
[![Platform](https://img.shields.io/cocoapods/p/MMToast.svg?style=flat)](https://cocoapods.org/pods/MMToast)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- iOS 10.0
- Xcode 13.0+
- Swift 5.0

## Installation

MMToast is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MMToast'
```

## Usage

```swift
import MMToast

//建议根据项目需求，再次封装一层,示例

///展示提示icon类型
enum MMToastIconType:String {
    case success = "toast_success"
    case error = "toast_error"
    case waring = "toast_waring"
}


extension MMToast{

    ///纯文字，自动隐藏
    static func showText(text:String?) {
        guard let msgText = text else {
            return
        }
        var model = MMToastConfig.init(type: .text)
        model.text = msgText
        MMToast.showToast(model: model)
    }

    static func showLoading(color:UIColor) {
        var model = MMToastConfig.init(type: .loading)
//        model.loadingColor = color
//        model.bgColor = .randomColor
        MMToast.showToast(model: model)
    }

    ///成功，自动隐藏
    static func showSuccess(text:String? = nil,icon:String? = nil) {
        show(text: text ?? "操作成功", iconType: .success)
    }

    ///失败，自动隐藏
    static func showError(text:String? = nil,icon:String? = nil) {
        show(text: text ?? "操作失败", iconType: .error)
    }

    ///警告，自动隐藏
    static func showWaring(text:String? = nil) {
        show(text: text ?? "警告", iconType: .waring)
    }

    ///文字+icon，自动隐藏
    static func show(text:String?,iconType:MMToastIconType) {
        var model = MMToastConfig.init(type: .iconAndText)
        model.text = text
        model.iconName = iconType.rawValue
        MMToast.showToast(model: model)
    }
}


extension UIColor {
    //返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
```

## Author

luckyBoy, goodlucky1130@163.com

## License

MMToast is available under the MIT license. See the LICENSE file for more info.

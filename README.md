# MMToast

[![CI Status](https://img.shields.io/travis/luckyBoy/MMToast.svg?style=flat)](https://travis-ci.org/luckyBoy/MMToast)
[![Version](https://img.shields.io/cocoapods/v/MMToast.svg?style=flat)](https://cocoapods.org/pods/MMToast)
[![License](https://img.shields.io/cocoapods/l/MMToast.svg?style=flat)](https://cocoapods.org/pods/MMToast)
[![Platform](https://img.shields.io/cocoapods/p/MMToast.svg?style=flat)](https://cocoapods.org/pods/MMToast)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- iOS 10.0
- Swift 5.0

## Installation

MMToast is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MMToast'
```


##Preview
| 效果  | 预览图 |
![菊花圈](https://github.com/lxm1799/MMToast/blob/master/pic/juhua.png)
![操作成功](https://github.com/lxm1799/MMToast/blob/master/pic/success.png)
![操作失败](https://github.com/lxm1799/MMToast/blob/master/pic/error.png)
![警告](https://github.com/lxm1799/MMToast/blob/master/pic/waring.png)
![纯文本](https://github.com/lxm1799/MMToast/blob/master/pic/text.png)

## Usage

```
import 'MMToast'

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        ///显示菊花圈
        MMToast.showLoading()
        ///显示纯文本,默认2s关闭
        MMToast.showText(text: "操作成功")
        ///关闭所有toast
        MMToast.hideAll()
        ///2s自动隐藏
        MMToast.autoHide(duration: 2)
        
        
        ///根据项目需求配置，下面介绍中有配置示范
        var model = MMToastConfig.init(type: .loading)
        model.iconName = "toast_success"
        model.text = "操作成功"
        MMToast.showToast(model: model)
        
    }
}


### Quick Start

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




### Main Class 


```
///目前支持3种样式
public enum MMToastType {
    ///菊花
    case loading
    ///纯文字tip
    case text
    ///icon+文字的tip
    case iconAndText
}



//MARK: -MMToast的配置属性
public struct MMToastConfig{
    
    public init(type:MMToastType) {
        self.type = type
    }
    ///显示类型
    public var type:MMToastType
    ///是否可以交互，默认true
    public var isUserInteractionEnabled:Bool = true
    ///默认自动关闭时间2秒（非loading有效）
    public var autoHideDuration:TimeInterval = 2
    ///是否定时隐藏（非loading有效）
    public var isAutoHide = true
    ///背景大小,默认100
    public var bgSize:CGSize = .init(width: 100, height: 100)
    ///背景颜色
    public var bgColor:UIColor = .init(red: 0, green: 0, blue: 0, alpha: 0.45)
    ///切角默认8
    public var cornerRadius:CGFloat = 8
    ///菊花圈颜色
    public var loadingColor:UIColor = .init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    
    ///图片的配置，没有则不显示
    public var iconName:String?
    ///默认根据image大小展示，如果设置，则根据iconSize的值来设置
    public var iconSize:CGSize?
    

    
    
    ///文字的配置
    public var text:String?
    ///文字默认居中展示
    public var textAlignment:NSTextAlignment = .center
    ///文字大小，默认系统12
    public var font:UIFont = UIFont.systemFont(ofSize: 12)
    ///字体颜色，默认白色
    public var textColor:UIColor = .init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    ///纯文字时候才会生效
    public var textBgColor:UIColor = .init(red: 0, green: 0, blue: 0, alpha: 0.45)
    ///设置文字距离屏幕的左右间距（针对纯文字有效）
    public var textMargin:CGFloat = 60
    ///设置text与icon的上下间距
    public var textAndIconMargin:CGFloat = 10
    ///文字高度 = 文字本身高度+textExtraHeight（纯文字下为了设置圆角）
    public var textExtraHeight:CGFloat = 10
}





## License

MMToast is available under the MIT license. See the LICENSE file for more info.

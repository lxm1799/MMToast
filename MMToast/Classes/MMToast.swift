//
//  MMToast.swift
//  MMToast
//
//  Created by mac on 2021/11/12.
//


import UIKit

///当前控制器的view
private let MMCurrentView = UIApplication.shared.windows.last
///设备最大宽度
private let MMMaxWidth:CGFloat = UIScreen.main.bounds.width
///设备最大高度
private let MMMaxHeight:CGFloat = UIScreen.main.bounds.height


public struct MMToast{
    
    ///展示toast
    public static func showToast(model:MMToastConfig){
        MMToastView.show(config: model)
    }
    
    ///菊花圈，不会自动隐藏
    public static func showLoading(){
        let model = MMToastConfig.init(type: .loading)
        MMToastView.show(config: model)
    }
    
    
    ///定时隐藏所有taost
    public static func autoHide(duration:TimeInterval = 2) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            MMToast.hideAll()
        }
    }
    
    
    ///隐藏所有taost
    public static func hideAll(){
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let views = MMCurrentView?.subviews ?? [UIView]()
            _ = views.compactMap({ view in
                if view.isMember(of: MMToastView.self) {
                    view.removeFromSuperview()
                }
            })
        }
    }
}



public enum MMToastType {
    ///菊花
    case loading
    ///纯文字tip
    case text
    ///icon+文字的tip
    case iconAndText
}



//MARK: -MMToast的配置
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




//MARK: -ToastView
fileprivate class MMToastView:UIView{

    static func show(config:MMToastConfig) {
        let view = MMToastView.init(config: config)
        MMCurrentView?.addSubview(view)
        if config.type != .loading && config.isAutoHide{
            view.hide()
        }
    }
    
    
    
    //初始化方法
    private var config:MMToastConfig!
    
    private init(config:MMToastConfig) {
        super.init(frame: UIScreen.main.bounds)
        self.config = config
        
        isUserInteractionEnabled = config.isUserInteractionEnabled
        if self.isUserInteractionEnabled {
            self.frame = .init(x: 0, y: 0, width: config.bgSize.width, height: config.bgSize.height)
            self.center = .init(x: MMMaxWidth/2, y: MMMaxHeight/2)
            self.backgroundColor = config.bgColor
            self.layer.cornerRadius = config.cornerRadius
        }else{
            bgView.center = self.center
            bgView.backgroundColor = config.bgColor
            bgView.layer.cornerRadius = config.cornerRadius
        }
        initSubView()
    }

    
    //隐藏方法
    private func hide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + config.autoHideDuration) {
            self.removeFromSuperview()
        }
    }


    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //布局
    private func initSubView() {

        switch config.type {
        case .loading:
            addSubview(bgView)
            bgView.addSubview(loadingProgressView)
        case .text:
            if config.text?.count ?? 0 > 0 {
                layoutOnlyText()
            }
        case .iconAndText:
            if let iconName = config.iconName {
                
                addSubview(bgView)
                bgView.addSubview(iconView)
                
                let icon = UIImage.init(named: iconName)
                var iconSize = icon?.size ?? .zero
                if let imgSize = config.iconSize{
                    iconSize = imgSize
                }
                iconView.image = icon
                
                if let text = config.text {
                    
                    textLab.text = text
                    bgView.addSubview(textLab)
                    
                    let leftMargin:CGFloat = 2
                    let textWidth = bgView.frame.width - leftMargin*2
                    let textLeft = (bgView.frame.width - textWidth)/2
                    let textSize = textLab.sizeThatFits(.init(width: textWidth, height: CGFloat(MAXFLOAT)))
                    
                    ///总的子view高度
                    let allSubViewH = iconSize.height + textSize.height + config.textAndIconMargin
                    
                    let iconLeft = (bgView.frame.width - iconSize.width)/2
                    let iconTop:CGFloat = (bgView.frame.height - allSubViewH)/2
                    iconView.frame = .init(x: iconLeft, y: iconTop, width: iconSize.width, height: iconSize.height)
                    
                    let textTop = iconView.frame.maxY + config.textAndIconMargin
                    textLab.frame = .init(x: textLeft, y:textTop, width: textWidth, height: textSize.height)
                    textLab.backgroundColor = .clear
                    
                }else{
                    
                    let iconLeft = (bgView.frame.width - iconSize.width)/2
                    let iconTop = (bgView.frame.height - iconSize.height)/2
                    iconView.frame = .init(x: iconLeft, y: iconTop, width: iconSize.width, height: iconSize.height)
                }

            }else{
                layoutOnlyText()
            }
        }
        
    }
    
    
    ///纯文字下的布局
    private func layoutOnlyText() {
        
        self.frame = UIScreen.main.bounds
        self.backgroundColor = .clear
        self.clipsToBounds = false
        
        addSubview(textLab)
        textLab.sizeToFit()
        var labSize = textLab.frame.size
        let labMaxW = MMMaxWidth - config.textMargin*2
        
        if labSize.width > labMaxW {
            labSize.width = labMaxW
            let size = textLab.sizeThatFits(.init(width: labMaxW, height: CGFloat(HUGE)))
            labSize.height = size.height
        }else{
            labSize.width = labSize.width + config.textExtraHeight*2
        }
        labSize.height += config.textExtraHeight
        textLab.frame = .init(x: 0, y: 0, width:  labSize.width, height: labSize.height)
        textLab.center = self.center
        textLab.layer.cornerRadius = 5
    }
    
    
    
    //懒加载
    ///bgView
    private lazy var bgView: UIView = {
        let bgView = UIView.init(frame: .init(x: 0, y: 0, width: config.bgSize.width, height: config.bgSize.height))
        bgView.clipsToBounds = true
        return bgView
    }()
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView.init()
        iconView.contentMode = .scaleAspectFill
        return iconView
    }()
    
    private lazy var textLab: UILabel = {
        let textLab = UILabel.init(frame: .zero)
        textLab.text = config.text
        textLab.textColor = config.textColor
        textLab.font = config.font
        textLab.textAlignment = config.textAlignment
        textLab.numberOfLines = 0
        textLab.clipsToBounds = true
        textLab.backgroundColor = config.textBgColor
        return textLab
    }()
    
    
    ///菊花圈
    private lazy var loadingProgressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        let height:CGFloat = 50
        let left:CGFloat = (bgView.frame.width - height)/2
        let top:CGFloat = (bgView.frame.height - height)/2
        view.frame = .init(x: left, y: top, width: height, height: height)
        view.color = config.loadingColor
        view.startAnimating()
        return view
    }()
}

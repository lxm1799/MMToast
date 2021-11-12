//
//  ViewController.swift
//  MMToast
//
//  Created by luckyBoy on 11/12/2021.
//  Copyright (c) 2021 luckyBoy. All rights reserved.
//

import UIKit
import MMToast

class ViewController: UIViewController {

    private let btnH:CGFloat = 50
    private let types = ["菊花圈","纯文字","操作成功","操作失败","警告","2s后关闭所有","关闭所有"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
      
        let btnSize:CGSize = .init(width: 80, height: 40)
        let top:CGFloat = 100
        let left:CGFloat = 10
        
        for (index,title) in types.enumerated() {
    
            let btnY = (btnSize.height + 10) * CGFloat(index)
            let btn = UIButton.init(frame: .init(x: left, y: btnY + top, width: btnSize.width, height: btnSize.height))
            btn.setTitle(title, for: .normal)
            btn.backgroundColor = .red
            btn.setTitleColor(.white, for: .normal)
            btn.tag = index
            btn.titleLabel?.font = .systemFont(ofSize: 10)
            btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
            view.addSubview(btn)
        }
    }
    

    @objc private func btnAction(btn:UIButton) {
        if btn.tag == 0 {

            MMToast.showLoading(color: .randomColor)

        }else if btn.tag == types.count - 1{

            MMToast.hideAll()

        }else if btn.tag == types.count - 2{

            MMToast.autoHide(duration: 2)

        }else if btn.tag == 1{

            MMToast.showText(text: btn.titleLabel?.text)

        }else{

            var type = MMToastIconType.success
            if btn.tag == 3 {
                type = .error
            }else if btn.tag == 4 {
                type = .waring
            }

            MMToast.show(text: btn.titleLabel?.text, iconType: type)
        }
    }
}



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



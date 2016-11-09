//
//  RootViewController.swift
//  WKWebView_JavaScript_Demo
//
//  Created by 123 on 16/11/8.
//  Copyright © 2016年 cw. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    var btn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.title = "rootViewControler"

        btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 40, y: 80, width: 80, height: 80)
        btn.setTitle("push JSAndSwiftViewController", for: .normal)
        btn.setTitleColor(UIColor.init(red: 0.3, green: 0.5, blue: 0.6, alpha: 1), for: .normal)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(touchBtnPushJSAndSwiftViewController), for: .touchUpInside)
    }
    
   @objc func touchBtnPushJSAndSwiftViewController() -> Void {
        self.navigationController?.pushViewController(JSAndSwiftViewController(), animated: true)
    }
}

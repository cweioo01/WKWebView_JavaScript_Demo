//
//  AppDelegate.swift
//  WKWebView_JavaScript_Demo
//
//  Created by 123 on 16/11/8.
//  Copyright © 2016年 cw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        /// 根控制器
        let rootVc = UINavigationController(rootViewController: RootViewController())
        
        // 设置主窗口
        window = UIWindow.init()
        window?.rootViewController = rootVc;
        window?.makeKeyAndVisible()
        
        return true
    }
}


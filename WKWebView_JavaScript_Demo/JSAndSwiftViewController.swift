//
//  JSAndSwiftViewController.swift
//  WKWebView_JavaScript_Demo
//
//  Created by 123 on 16/11/8.
//  Copyright © 2016年 cw. All rights reserved.
//

/** 
 * JS 调用 Swfit  和 Swift 调用 JS
 */

private var myContext = 0

import UIKit
import WebKit

class JSAndSwiftViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
   @objc dynamic var webView: WKWebView?
    let progress:UIProgressView = {
        let progress = UIProgressView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 5))
        progress.backgroundColor = UIColor.white
        progress.tintColor = UIColor.blue
        progress.trackTintColor = UIColor.gray
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.title = "Swift和js互调"
        
        /// 设置webView
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.userContentController = WKUserContentController()
        /// 增加消息处理
        webViewConfiguration.userContentController.add(self, name: "JSCallSwiftFirst")
        webViewConfiguration.userContentController.add(self, name: "JSCallSwiftTwo")
        webViewConfiguration.userContentController.add(self, name: "addSubViewMessage")
        
        webView = WKWebView.init(frame: view.bounds, configuration: webViewConfiguration)
        view.addSubview(webView!)
        view.addSubview(progress)
        
//        // 加载html文件
        let path = Bundle.main.path(forResource: "JSCallOC", ofType: "html")!
        let url =  URL.init(fileURLWithPath: path)
        webView!.loadFileURL(url, allowingReadAccessTo: url)

        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: &myContext)
         self.addObserver(self, forKeyPath: "webView.isLoading", options: .new, context: &myContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &myContext {
            if (keyPath == "estimatedProgress") {
                //progress是UIProgressView
                progress.isHidden = webView?.estimatedProgress==1
                progress.setProgress(Float((webView?.estimatedProgress)!), animated: true)
                
            } else if (keyPath == "isLoading") {
                //progress是UIProgressView
                progress.isHidden = webView?.estimatedProgress==1
                progress.setProgress(Float((webView?.estimatedProgress)!), animated: true)
            }else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "estimatedProgress");
        removeObserver(self, forKeyPath: "webView.isLoading");
    }

}

extension JSAndSwiftViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message, message.body)
         let dic = message.body as! Dictionary<String, AnyObject>
        var result = 0;
        if(message.name == "JSCallSwiftFirst") {
            if let input = dic["body"]?["inputNumber"]  {
             let   resultSTring = input as! NSString

                if Int(resultSTring as String) != nil {
                    result = Int(resultSTring as String)!
                }else {
                    let alertVc =  UIAlertController(title: "错误的输入", message: "请输入合法的数字", preferredStyle: .actionSheet)
                    alertVc.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
                    present(alertVc, animated: true, completion: nil)
                    
                    return
                }
            }else {
                result = 0
            }
            
            result = calculate(input: result)
            // 测试传数组用的.
            //   let array = [5, 6, 9, "五","一"] as [Any]
            // 调用JS方法.显示结果在html上.
            message.webView?.evaluateJavaScript("showResult(\(result))", completionHandler: { (string, error) in
            
            })
            
        }else if(message.name == "addSubViewMessage") {
            if (dic["body"]) != nil  {
                addSubView(viewColor: dic["body"] as! String)
            }
        }
    }
    
    /// 计算结果,返回给JS显示
    func calculate(input a: Int) -> Int {
        
        return a + 20
    }
    
    /// 添加子控件
    func addSubView(viewColor: String) -> Void {
        let subView = UIView.init(frame: CGRect(x: 80, y: 200, width: 80, height: 80))

        if viewColor == "red" {
            
            subView.backgroundColor = UIColor.red
        }else {
        subView.backgroundColor = UIColor.blue
        }
        view.addSubview(subView)
    }
}

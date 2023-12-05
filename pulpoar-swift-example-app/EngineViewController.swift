//
//  EngineViewController.swift
//  pulpoar-swift-example-app
//
//  Created by Eren Kayacan on 24.05.2022.
//

import UIKit
import WebKit

class EngineViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    @IBOutlet private weak var keyEvent: UILabel!
    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: CGRect(x: 0, y: 80, width: view.frame.width, height: view.frame.height-80), configuration: configuration)
        webView.navigationDelegate = self
        view.addSubview(webView)

        let myURL = URL(string: "https://engine.pulpoar.com/engine/v0/e4c278ef-0bef-40cc-85d5-5643b179a05c")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)

        let contentController = self.webView.configuration.userContentController
        contentController.add(self, name: "jsHandler")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard let dict = message.body as? [String : AnyObject] else {
                return
            }
        keyEvent.text = dict["message"] as? String
        }
     
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.targetFrame == nil {
            // This is an "_blank" link; open it in a new WebView
            if let url = navigationAction.request.url {
                // Create a new view controller with a WKWebView
                let newWebViewController = UIViewController()
                let newWebView = WKWebView(frame: newWebViewController.view.bounds)
                newWebView.navigationDelegate = self // You might want to set a delegate if needed.
                newWebViewController.view.addSubview(newWebView)
                
                // Create a close button, it is optional ux decision
                let closeButton = UIButton()
                closeButton.setTitle("Close", for: .normal)
                closeButton.backgroundColor = UIColor.red // Set the background color
                closeButton.setTitleColor(UIColor.white, for: .normal) // Set the text color
                closeButton.layer.cornerRadius = 8 // Add rounded corners
                    
                let buttonWidth: CGFloat = 80
                let buttonHeight: CGFloat = 40
                let buttonX = (newWebView.frame.size.width - buttonWidth) / 2
                let buttonY = newWebView.frame.origin.y + newWebView.frame.size.height-120
                closeButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
                
                closeButton.addTarget(self, action: #selector(self.closeButtonTapped), for: .touchUpInside)
                newWebViewController.view.addSubview(closeButton)
                
                newWebView.load(URLRequest(url: url))
                self.present(newWebViewController, animated: true, completion: nil)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }

    @objc func closeButtonTapped() {
        // Handle the close button action
        dismiss(animated: true, completion: nil)
    }

    



}

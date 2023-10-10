//
//  EngineViewController.swift
//  pulpoar-swift-example-app
//
//  Created by Eren Kayacan on 24.05.2022.
//

import UIKit
import WebKit

class EngineViewController: UIViewController, WKScriptMessageHandler {
    @IBOutlet private weak var keyEvent: UILabel!
    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), configuration: configuration)

        view.addSubview(webView)

        let myURL = URL(string: "https://engine.pulpoar.com/engine/v0/ca8e71e3-58f0-40d9-b8e9-af0df5d2864b")
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
}

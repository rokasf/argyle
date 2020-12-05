//
//  WebViewController.swift
//  argyle
//
//  Created by Rokas Firantas on 2020-12-05.
//

import Foundation
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!

    private let url: URL

    init(_ url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

//
//  WevKitView.swift
//  HadoPad
//
//  Created by song on 2026/1/28.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    // wkwebview url
    let webUrl: URL
    // is debug
    let debug: Bool
    // userAgent
    // let userAgent = Bundle.main.object(forInfoDictionaryKey: "USERAGENT") as? String ?? ""

    func makeUIView(context: Context) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        // 允许本地文件访问
        webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        // 允许跨域访问
        webConfiguration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        // 配置媒体权限，允许自动播放和内联播放
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.allowsPictureInPictureMediaPlayback = true
        
        // enable developer extras
        if #available(iOS 16.4, *) {
            webConfiguration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        } else {
            webConfiguration.preferences.setValue(true, forKey: "developerExtrasEnabled")
            UserDefaults.standard.set(true, forKey: "WebKitDeveloperExtras")
        }
        // creat wkwebview
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)

        // debug script
        // if debug, let debugScript = WebView.loadJSFile(named: "vConsole") {
        //     let fullScript = debugScript + "\nvar vConsole = new window.VConsole();"
        //     let userScript = WKUserScript(
        //         source: fullScript,
        //         injectionTime: .atDocumentStart,
        //         forMainFrameOnly: true
        //     )
        //     webView.configuration.userContentController.addUserScript(userScript)
        //     if #available(iOS 16.4, *) {
        //         webView.isInspectable = true
        //     }
        // }
        // config userAgent
        // if !userAgent.isEmpty {
        //     webView.customUserAgent = userAgent
        // }

        // disable double tap zoom
        let script = """
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            document.head.appendChild(meta);
        """
        let scriptInjection = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(scriptInjection)

        // load custom script
        // if let customScript = WebView.loadJSFile(named: "custom") {
        //     let userScript = WKUserScript(
        //         source: customScript,
        //         injectionTime: .atDocumentStart,
        //         forMainFrameOnly: true
        //     )
        //     webView.configuration.userContentController.addUserScript(userScript)
        // }

        if webUrl.host?.contains("pakeplus.com") == true {
            // load html file
            if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
                webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            }
        } else {
            // load url
            webView.load(URLRequest(url: webUrl))
        }

        // delegate 设置

        // Add gesture recognizers
        let rightSwipeGesture = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleRightSwipe(_:)))
        rightSwipeGesture.direction = .right
        webView.addGestureRecognizer(rightSwipeGesture)

        let leftSwipeGesture = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLeftSwipe(_:)))
        leftSwipeGesture.direction = .left
        webView.addGestureRecognizer(leftSwipeGesture)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    // add coordinator to prevent zoom
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

// swifui coordinator
class Coordinator: NSObject, UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // disable zoom
        return nil
    }

    // Handle right swipe gesture
    @objc func handleRightSwipe(_ gesture: UISwipeGestureRecognizer) {
        if let webView = gesture.view as? WKWebView, webView.canGoBack {
            webView.goBack()
        }
    }

    // Handle left swipe gesture
    @objc func handleLeftSwipe(_ gesture: UISwipeGestureRecognizer) {
        if let webView = gesture.view as? WKWebView, webView.canGoForward {
            webView.goForward()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish navigation: \(String(describing: webView.url))")
        // currentURL = webView.url
    }
}

extension WebView {
    // load js file from bundle
    static func loadJSFile(named filename: String) -> String? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "js") else {
            print("Could not find \(filename).js in bundle")
            return nil
        }

        do {
            let jsString = try String(contentsOfFile: path, encoding: .utf8)
            return jsString
        } catch {
            print("Error loading \(filename).js: \(error)")
            return nil
        }
    }
}

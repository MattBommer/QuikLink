//
//  WebView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/24/23.
//

import SwiftUI
import WebKit
import UIKit


class Spinner: UIView {
    
    private let shapeLayer = CAShapeLayer()
    
    init() {
        super.init(frame: .zero)
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor.brandBlue.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.strokeEnd = 0
        layer.addSublayer(shapeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        shapeLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: 4.0, dy: 4.0)).cgPath
    }
    
    override func didMoveToWindow() {
        startSpinning()
    }
    
    func startSpinning() {
        let strokeAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        strokeAnimation.keyTimes = [0, 0.2, 0.3, 0.4, 0.6, 0.7, 0.9, 1]
        strokeAnimation.values = [0.2, 0.5, 0.7, 0.9, 0.4, 0.1, 0.5, 0.2]
        strokeAnimation.duration = 2.0
        strokeAnimation.repeatCount = .infinity
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 8 * Double.pi
        rotationAnimation.duration = 2.0
        rotationAnimation.repeatCount = .infinity
        
        shapeLayer.add(strokeAnimation, forKey: nil)
        shapeLayer.add(rotationAnimation, forKey: nil)
    }
    
    
    func stopSpinning() {
        shapeLayer.removeAllAnimations()
        removeFromSuperview()
    }
}

class ArticleWebViewController: UIViewController, CAAnimationDelegate, WKNavigationDelegate {
    
    private let spinner = Spinner()
    private var webView = WKWebView()
    private let articleRequest: URLRequest
    private var request: WKNavigation?
    
    init(url: URL) {
        articleRequest = URLRequest(url: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.backgroundColor = .clear
        view.addSubview(spinner)
        
        view.addConstraints([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 50),
            spinner.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        webView.navigationDelegate = self
        request = webView.load(articleRequest)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard navigation == request else { return }
        spinner.stopSpinning()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard navigation == request else { return }
        spinner.stopSpinning()
    }
}

struct ArticleWebView: UIViewControllerRepresentable {
    
    var url: URL
    
    func makeUIViewController(context: Context) -> ArticleWebViewController {
        return ArticleWebViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: ArticleWebViewController, context: Context) {
        //noop
    }
}

struct SpinnerView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> Spinner {
        return Spinner()
    }
    
    func updateUIView(_ uiView: Spinner, context: Context) {
        //noop
    }
}

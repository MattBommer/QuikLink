//
//  WebView.swift
//  RssReader
//
//  Created by Matt Bommer on 1/24/23.
//

import SwiftUI
import WebKit
import UIKit

class ArticleWebViewController: UIViewController, CAAnimationDelegate, WKNavigationDelegate {
    
    private let shapeLayer = CAShapeLayer()
    private let spinnerView = UIView()
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
        
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.backgroundColor = .clear
        view.addSubview(spinnerView)
        
        view.addConstraints([
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinnerView.heightAnchor.constraint(equalToConstant: 50),
            spinnerView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor.brandBlue.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.strokeEnd = 0
        spinnerView.layer.addSublayer(shapeLayer)
        
        webView.navigationDelegate = self
        request = webView.load(articleRequest)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shapeLayer.frame = spinnerView.bounds
        shapeLayer.path = UIBezierPath(ovalIn: spinnerView.bounds).cgPath
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard navigation == request else { return }
        stopSpinning()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard navigation == request else { return }
        stopSpinning()
    }
    
    func stopSpinning() {
        shapeLayer.removeAllAnimations()
        shapeLayer.removeFromSuperlayer()
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

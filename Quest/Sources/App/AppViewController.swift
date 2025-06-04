import WebKit
import UIKit
import Foundation

class AppViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    var WebView: WKWebView!
    var url: String
    var isRedirecting = false
    
    init(urlStr: String) {
        self.url = urlStr
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(" init(coder:) has not been implemented yet")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: self.url), url.absoluteString.contains("bot") {
            print(" Initial URL doesn't contain 'bot', trying to opening app directly")
            
            let viewController = ViewController()
            DispatchQueue.main.async {
                viewController.StartHandler()
            }
            
            return
        }
        
        self.view.backgroundColor = UIColor(named: "dark")
        
        let topBackgroundUIView = UIView()
        topBackgroundUIView.backgroundColor = UIColor(named: "dark")
        topBackgroundUIView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundUIView)
        
        let bottomBackgroundView = UIView()
        bottomBackgroundView.backgroundColor = UIColor(named: "dark")
        bottomBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBackgroundView)
        
        NSLayoutConstraint.activate([
            topBackgroundUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBackgroundUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBackgroundUIView.topAnchor.constraint(equalTo: view.topAnchor),
            topBackgroundUIView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            bottomBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.WebView = self.deafoultSetupWeb(frame: self.view.bounds, configuration: nil)
        self.view.addSubview(self.WebView)
        
        self.WebView.alpha = 0
        self.view.alpha = 0
        
        self.constrsHandling()
        
        if let url = URL(string: self.url) {
            let urlRequest = URLRequest(url: url)
            self.WebView.load(urlRequest)
        }
        
        self.makeWindowAsync()
        Orientation.orientation = .all
    }
    
    func makeWindowAsync() {
        DispatchQueue.main.async {
            let window = UIApplication.shared.keyWindow
            let field = UITextField()
            field.isSecureTextEntry = true
            window?.addSubview(field)
            window?.layer.superlayer?.addSublayer(field.layer)
        }
    }
    
    func deafoultSetupWeb(frame: CGRect, configuration: WKWebViewConfiguration?) -> WKWebView {
        let configuration = configuration ?? WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: frame, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.allowsLinkPreview = false
        webView.scrollView.bounces = false
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }
    
    func constrsHandling() {
        NSLayoutConstraint.activate([
            self.WebView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.WebView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.WebView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.WebView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if #available(iOS 15.0, *) {
            self.view.backgroundColor = self.WebView.underPageBackgroundColor
            if let finalURL = webView.url {
                print(" Final URL after all redirects: \(finalURL.absoluteString)")
                self.isRedirecting = false
                if UserDefaults.standard.string(forKey: "finalURL") == nil {
                    UserDefaults.standard.set(finalURL.absoluteString, forKey: "finalURL")
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if !self.isRedirecting {
                    self.view.alpha = 1
                    self.WebView.alpha = 1
                    print(" WebView fully loaded with final URL.")
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        if !["http", "https"].contains(url.scheme ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        
        if UserDefaults.standard.string(forKey: "finalURL") == nil {
            print(" Redirected to: \(url.absoluteString)")
            isRedirecting = true
        }
        
        if url.absoluteString.contains("bot") {
            print(" Redirect contains 'bot', open app")
            DispatchQueue.main.async { [weak self] in
                self?.dismiss(animated: false, completion: {
                    let viewController = ViewController()
                    viewController.StartHandler()
                })
            }
        }
        
        decisionHandler(.allow)
    }
    
    func getCurrentUser() async -> String? {
        let webView = WKWebView(frame: .zero)
        return await withCheckedContinuation { continuation in
            webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
                if let userAgent = result as? String {
                    continuation.resume(returning: userAgent)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil || !navigationAction.targetFrame!.isMainFrame {
            let topInset: CGFloat = 44
            let containerView = UIView(frame: self.view.frame)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = UIColor.black
            
            self.view.addSubview(containerView)
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
                containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
            
            var webViewFrame = self.view.safeAreaLayoutGuide.layoutFrame
            webViewFrame.size.height -= topInset
            webViewFrame.origin.y += topInset
            
            let targetView = self.deafoultSetupWeb(frame: webViewFrame, configuration: configuration)
            targetView.translatesAutoresizingMaskIntoConstraints = false
            if let url = navigationAction.request.url {
                targetView.load(URLRequest(url: url))
            }
            targetView.uiDelegate = self
            
            containerView.addSubview(targetView)
            
            let closeButton = UIButton(type: .system)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.tintColor = UIColor.white
            closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
            containerView.addSubview(closeButton)
            
            NSLayoutConstraint.activate([
                closeButton.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -15),
                closeButton.centerYAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 22),
                targetView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: topInset),
                targetView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
                targetView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
                targetView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor)
            ])
            
            containerView.alpha = 0.0
            UIView.animate(withDuration: 0.2) {
                containerView.alpha = 1.0
            }
            
            return targetView
        }
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if let view = webView.superview {
            UIView.animate(withDuration: 0.2) {
                view.alpha = 0.0
            } completion: { _ in
                view.removeFromSuperview()
            }
        }
    }
    
    @objc func closeButtonTapped(_ sender: UIButton) {
        if let view = sender.superview {
            UIView.animate(withDuration: 0.2) {
                view.alpha = 0.0
            } completion: { _ in
                view.removeFromSuperview()
            }
        }
    }
    
}

private extension String {
    
    private var kUIInterfaceOrientationPortrait: String {
        return "UIInterfaceOrientationPortrait"
    }
    
    private var kUIInterfaceOrientationLandscapeLeft: String {
        return "UIInterfaceOrientationLandscapeLeft"
    }
    
    private var kUIInterfaceOrientationLandscapeRight: String {
        return "UIInterfaceOrientationLandscapeRight"
    }
    
    private var kUIInterfaceOrientationPortraitUpsideDown: String {
        return "UIInterfaceOrientationPortraitUpsideDown"
    }
    
    var deviceOrientation: UIInterfaceOrientationMask {
        switch self {
        case kUIInterfaceOrientationPortrait:
            return .portrait
            
        case kUIInterfaceOrientationLandscapeRight:
            return .landscapeRight
            
        case kUIInterfaceOrientationLandscapeLeft:
            return .landscapeLeft
            
        case kUIInterfaceOrientationPortraitUpsideDown:
            return .portraitUpsideDown
            
        default:
            return .all
        }
    }
}


class Orientation {
    private static var preferredOrientation: UIInterfaceOrientationMask {
        guard let maskStringArray = Bundle.main.object(forInfoDictionaryKey: "UISupportedInterfaceOrientations") as? [String] else {
            return .all
        }
        
        let masksArray = maskStringArray.compactMap { $0.deviceOrientation }
        
        return UIInterfaceOrientationMask(masksArray)
    }
    
    fileprivate(set) public static var orientation: UIInterfaceOrientationMask = preferredOrientation
}


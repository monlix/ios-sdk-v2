import UIKit
import WebKit

class MonlixWebViewController: UIViewController {
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupNavigationBar()
        registerNotifications()
        
        guard MonlixOfferWall.isInitialized else {
            dismiss(animated: true)
            return
        }
        
        let url = MonlixOfferWall.getUrlWithParameters()
        loadWebView(with: url)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed || isMovingFromParent {
            cleanupWebView()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        view.addSubview(webView)
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(closeWebView),
            name: NSNotification.Name(MonlixConstants.CLOSE_ACTION),
            object: nil
        )
    }
    
    private func loadWebView(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc private func closeWebView() {
        dismiss(animated: true)
    }
    
    private func cleanupWebView() {
        webView.stopLoading()
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
    }
}

extension MonlixWebViewController: WKNavigationDelegate {
    private func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        
        if url.contains(MonlixConstants.URL_CLOSE_PARAM) {
            decisionHandler(.cancel)
            dismiss(animated: true)
            return
        }
        
        if url.hasPrefix(MonlixConstants.BASE_URL) {
            decisionHandler(.allow)
            return
        }
        
        if let openURL = navigationAction.request.url,
           UIApplication.shared.canOpenURL(openURL) {
            UIApplication.shared.open(openURL)
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
}

extension MonlixWebViewController: WKUIDelegate {
    private func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler()
        }))
        present(alertController, animated: true)
    }
    
    private func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completionHandler(false)
        }))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler(true)
        }))
        present(alertController, animated: true)
    }
}

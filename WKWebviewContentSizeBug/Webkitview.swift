import UIKit
import WebKit


protocol NauWebKitViewDelegate: class {
    func webViewDidDoubleTap()
    func webViewDidFinishLoad(_ webView: WKWebView, height: CGFloat)
    func openExternalUrl(_ url: URL)
}

class NauWebKitView: WKWebView {
    enum WebViewConfiguration {
        case none
        case custom(WKWebViewConfiguration)
        case card
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    private var isCard = false
    private var urlCredential: URLCredential?
    
    weak var delegate: NauWebKitViewDelegate?
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        let jscript = """
            document.body.style.fontFamily = ['-apple-system', 'system-ui', 'SanFrancisco', 'HelveticaNeue'];
            document.body.style.margin = '0';
            document.body.style.padding = '0';
            var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}';
            var head = document.head || document.getElementsByTagName('head')[0];
            var style = document.createElement('style');
            style.type = 'text/css';
            style.appendChild(document.createTextNode(css));
            head.appendChild(style);
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            head.appendChild(meta);
        """
        
        let userScript = WKUserScript(
            source: jscript,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        
        let wkUController = WKUserContentController()
        wkUController.addUserScript(userScript)
        
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        
        super.init(frame: frame, configuration: wkWebConfig)
        
        navigationDelegate = self
        
        backgroundColor = .white
        isOpaque = false
        scrollView.isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadHTMLString(_ string: String, baseURL: URL?) -> WKNavigation? {
        activityIndicator.startAnimating()
        
        return super.loadHTMLString("<meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0;\">" + string, baseURL: nil)
    }
}

// MARK: - WKNavigationDelegate

extension NauWebKitView: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        guard url != URL(string: "about:blank"), UIApplication.shared.canOpenURL(url) else {
            decisionHandler(.allow)
            return
        }
        delegate?.openExternalUrl(url)
        decisionHandler(.cancel)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { [weak self] complete, _ in
            guard let _ = complete, let self = self else {
                return
            }
            
            self.activityIndicator.stopAnimating()
            
            self.evaluateJavaScript("document.body.scrollHeight", completionHandler: { [weak self] height, _ in
                if let udpatedHeight = height as? CGFloat {
                    self?.delegate?.webViewDidFinishLoad(webView, height: udpatedHeight)
                }
            })
        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
}

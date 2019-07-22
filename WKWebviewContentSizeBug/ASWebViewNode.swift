//
//  ASWebViewNode.swift
//  WKWebviewContentSizeBug
//
//  Created by Vadim Vitvickiy on 22/07/2019.
//  Copyright © 2019 Vadim Vitvickiy. All rights reserved.
//

import WebKit

class ASWebViewNode: ASCellNode, NauWebKitViewDelegate {
    
    var html: String
    
    lazy var contentWebviewNode = ASDisplayNode(viewBlock: { () -> UIView in
        let webview = NauWebKitView(frame: .zero)
        webview.isUserInteractionEnabled = false
        return webview
    })
    
    init(html: String) {
        self.html = html
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        style.flexGrow = 1.0
        
        contentWebviewNode.style.height = ASDimensionMake(10)
        contentWebviewNode.style.maxHeight = ASDimensionMake(130)
        contentWebviewNode.style.width = ASDimensionAuto
    }

    override func didLoad() {
        let webView = contentWebviewNode.view as? NauWebKitView
        webView?.delegate = self
        _ = webView?.loadHTMLString(html, baseURL: nil)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let webSpec = ASAbsoluteLayoutSpec(sizing: .sizeToFit, children: [contentWebviewNode])
        webSpec.style.flexGrow = 1
        webSpec.style.flexShrink = 1
        let textNode = ASTextNode()
        textNode.attributedText = NSAttributedString(string: "Text")
        let spec = ASStackLayoutSpec(direction: .horizontal,
                                     spacing: 8,
                                     justifyContent: .start,
                                     alignItems: .start,
                                     children: [textNode, webSpec])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16), child: spec)
    }
    
    func webViewDidDoubleTap() {
        
    }
    
    func openExternalUrl(_ url: URL) {
       
    }
    
    func webViewDidFinishLoad(_ webView: WKWebView, height: CGFloat) {
        contentWebviewNode.style.height = ASDimensionMake(height)
        setNeedsLayout()
    }
}

//
//  WebViewCell.swift
//  WKWebviewContentSizeBug
//
//  Created by Vadim Vitvickiy on 22/07/2019.
//  Copyright © 2019 Vadim Vitvickiy. All rights reserved.
//

import UIKit
import WebKit

class WebViewCell: UITableViewCell, NauWebKitViewDelegate {
    
    let webView = NauWebKitView(frame: .zero)
    var webViewHeight: NSLayoutConstraint!
    var indexPath: IndexPath!
    weak var tableView: UITableView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        webView.delegate = self
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(webView)
        
        webViewHeight = webView.heightAnchor.constraint(equalToConstant: 15)
        webViewHeight.isActive = true
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func webViewDidDoubleTap() {
        
    }
    
    func openExternalUrl(_ url: URL) {
        
    }
    
    func webViewDidFinishLoad(_ webView: WKWebView, height: CGFloat) {
        tableView.beginUpdates()
        webViewHeight.constant = height
        setNeedsLayout()
        superview?.setNeedsLayout()
        tableView.endUpdates()
    }
}

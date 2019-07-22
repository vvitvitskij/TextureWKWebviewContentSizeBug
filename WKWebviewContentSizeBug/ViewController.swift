//
//  ViewController.swift
//  WKWebviewContentSizeBug
//
//  Created by Vadim Vitvickiy on 22/07/2019.
//  Copyright © 2019 Vadim Vitvickiy. All rights reserved.
//

import UIKit

class ViewController: ASViewController<ASTableNode>, ASTableDataSource, ASTableDelegate {
    
    var ds: [String] = []
    
    init() {
        let tableNode = ASTableNode(style: .grouped)
        
        super.init(node: tableNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        for _ in 0...1000 {
            ds.append("Problem open")
        }
        
        node.dataSource = self
        node.delegate = self
    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return ds.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let html = ds[indexPath.row]
        return {
            return ASWebViewNode(html: html)
        }
    }
}


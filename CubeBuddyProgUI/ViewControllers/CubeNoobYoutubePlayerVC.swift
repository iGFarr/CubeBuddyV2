//
//  CubeNoobYoutubePlayerVC.swift
//  CubeBuddyProgUI
//
//  Created by Isaac Farr on 7/3/22.
//

import UIKit
import WebKit

class CubeNoobYoutubePlayerVC: CBBaseViewController {
    private let webView = WKWebView()
    
    private var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.title = CBConstants.CBMenuPickerPages.cubeNoob.rawValue
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        
        if let url = URL(string: CBConstants.URLStrings.channelPage) {
            let request = URLRequest(url: url)
            DispatchQueue.main.async {
                self.webView.load(request)
                self.constrainWebView()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let url = URL(string: CBConstants.URLStrings.channelPage) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath! == "URL" {
            url = URL(string: (webView.url?.absoluteString)!)
        }
    }
    
    private func constrainWebView(){
        guard let navBarHeight = self.navigationController?.navigationBar.frame.size.height else { return }
        
        var statusHeight: CGFloat!
        if #available(iOS 13.0, *) {
            statusHeight = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height
        } else {
            // Fallback on earlier versions
            statusHeight = UIApplication.shared.statusBarFrame.height
        }
        
        let topBarHeight = navBarHeight + statusHeight
        CBConstraintHelper.constrainWithCustomInsets(subView: webView, to: view, topInset: topBarHeight)
    }
}

//
//  TMDBAuthViewController.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - WebViewController: UIViewController

class WebViewController: UIViewController {
    
    // MARK: Properties
    
    var urlRequest: NSURLRequest? = nil
    // MARK: Outlets
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //webView.delegate = self
        
        navigationItem.title = "Udacity Sign Up"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(cancelSignup))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if urlRequest != nil {
            
            webView.loadRequest(urlRequest!)
        }
    }
    
    // MARK: Cancel Auth Flow
    
    func cancelSignup() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - TMDBAuthViewController: UIWebViewDelegate

extension WebViewController: UIWebViewDelegate {
    

}
//
//  TableViewController.swift
//  On The Map
//
//  Created by Jaekwang Seo on 9/13/16.
//  Copyright © 2016 Jaekwang Seo. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController {
    
    
    @IBOutlet weak var studentLocationTableView: UITableView!
    
    var studentLocations: [StudentLocation] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let mapViewController = self.tabBarController?.viewControllers?[0] as? MapViewController {
            studentLocations = mapViewController.studentLocations
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.studentLocationTableView.reloadData()
        })

    }
    
    override func viewWillAppear(animated: Bool) {
        parentViewController!.navigationItem.leftBarButtonItem?.enabled = true
    }
    

    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /* Get cell type */
        let cellReuseIdentifier = "StudentLocationTableViewCell"
        let studentLocation = studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        if let firstName = studentLocation.firstName, let lastName = studentLocation.lastName {
            cell.textLabel!.text = firstName + " " + lastName
            
        } else {
            cell.textLabel!.text = ""
        }
        cell.imageView!.image = UIImage(named: "pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let studentLocation = studentLocations[indexPath.row]
        
        if let url = studentLocation.mediaURL {
            print(url)
            let url = NSURL(string: url)
            let request = NSURLRequest(URL: url!)
            let webViewController = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            webViewController.urlRequest = request
            webViewController.title = ""
            
            let webNavigationController = UINavigationController()
            webNavigationController.pushViewController(webViewController, animated: false)
            
            self.presentViewController(webNavigationController, animated: true, completion: nil)
        }
    }
}
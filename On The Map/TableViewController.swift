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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        
        if let urlString = studentLocation.mediaURL {
            print(urlString)
            let app = UIApplication.sharedApplication()
            guard let url = NSURL(string: urlString) else {
                displayAlert("Couldn't open the URL", message: "Couldn't open the URL: \(urlString)")
                return
            }
            
            let result = app.openURL(url)
            if !result {
                displayAlert("Couldn't open the URL", message: "Couldn't open the URL: \(urlString)")
            }

        }
    }
    
    func displayAlert(title: String?, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default ) { (action) in
            
        }
        
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

}